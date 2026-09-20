#!/usr/bin/env python3
"""Source-only iOS/API checks; does not compile Flutter or contact a server.

Usage: python3 tools/validate_ios_source.py --backend /path/to/backend --output report.json
The optional backend is the unmodified ANS backend supplied for comparison.
Dynamic expressions are reported as unresolved, never silently counted as passes.
"""

import argparse
from collections import Counter
import json
from pathlib import Path
import plistlib
import re
import sys


def uncomment(source):
    """Remove comments while preserving literals, offsets and line numbers."""
    pattern = r"('(?:\\.|[^'\\])*'|\"(?:\\.|[^\"\\])*\"|`(?:\\.|[^`\\])*`)|(//[^\n]*|/\*[\s\S]*?\*/)"
    return re.sub(pattern, lambda m: m[1] if m[1] else re.sub(r"[^\n]", " ", m[2]), source)


def line_at(source, position):
    return source.count("\n", 0, position) + 1


def path_template(value):
    value = re.sub(r"\$\{[^}]*\}|\$[A-Za-z_]\w*", ":parameter", value)
    return "/" + value.strip("/")


def route_matches(template, actual):
    left, right = template.strip("/").split("/"), actual.strip("/").split("/")
    if len(left) != len(right):
        return False
    return all(a == b or (a.startswith(":") and not b.startswith(":"))
               or (a.startswith(":") and b.startswith(":"))
               for a, b in zip(left, right))


def backend_routes(root):
    routes, unsupported = [], []
    decorator = re.compile(r"@(Controller|Get|Post|Put|Patch|Delete|Options|Head|All)\s*\(([^)]*)\)")
    for file in sorted((root / "src").rglob("*.ts")):
        source = uncomment(file.read_text(encoding="utf-8"))
        prefix = None
        for match in decorator.finditer(source):
            name, raw = match[1], match[2].strip()
            if raw == "":
                path = ""
            elif re.fullmatch(r"(['\"])[^'\"]*\1", raw):
                path = raw[1:-1]
            else:
                unsupported.append({"file": str(file.relative_to(root)), "line": line_at(source, match.start()), "decorator": match[0]})
                if name == "Controller":
                    prefix = None
                continue
            if name == "Controller":
                prefix = path
            elif prefix is not None:
                routes.append({"method": name.upper(), "path": path_template("/".join([prefix, path])), "file": str(file.relative_to(root)), "line": line_at(source, match.start())})
    return routes, unsupported


def endpoint_definitions(root):
    file = root / "lib/core/api/api_endpoints.dart"
    source = uncomment(file.read_text(encoding="utf-8"))
    classes = list(re.finditer(r"class _(\w+)Endpoints\s*\{", source))
    definitions = {}
    for index, cls in enumerate(classes):
        body_end = classes[index + 1].start() if index + 1 < len(classes) else len(source)
        body = source[cls.end():body_end]
        member = re.compile(r"\bString\s+(?:get\s+)?(\w+)\s*(?:\([^;]*?\))?\s*=>\s*([^;]+);", re.S)
        for match in member.finditer(body):
            expression = match[2].strip()
            key = cls[1].lower() + "." + match[1]
            literal = re.fullmatch(r"(['\"])([\s\S]*)\1", expression)
            definitions[key] = {"path": path_template(literal[2]) if literal else None,
                                "expression": expression,
                                "line": line_at(source, cls.end() + match.start())}
    for _ in range(5):
        for key, item in definitions.items():
            alias = re.fullmatch(r"(\w+)\([^;]*\)", item["expression"])
            if item["path"] is None and alias:
                target = definitions.get(key.split(".")[0] + "." + alias[1])
                if target:
                    item["path"] = target["path"]
    return definitions


def first_argument(source, start):
    level, quote, escaped = 0, None, False
    for i in range(start, len(source)):
        char = source[i]
        if quote:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == quote:
                quote = None
        elif char in "'\"":
            quote = char
        elif char in "([{":
            level += 1
        elif char in ")]}":
            if level == 0:
                return source[start:i].strip()
            level -= 1
        elif char == "," and level == 0:
            return source[start:i].strip()
    return source[start:].strip()


def api_calls(root, definitions, routes):
    calls = []
    pattern = re.compile(r"\b(_apiClient|refreshDio|_dio)\.(get|post|put|patch|delete)\s*(?:<[^();]*>)?\s*\(")
    for file in sorted((root / "lib").rglob("*.dart")):
        if file == root / "lib/core/api/api_client.dart":
            continue  # generic transport forwarding, not application endpoints
        source = uncomment(file.read_text(encoding="utf-8"))
        for match in pattern.finditer(source):
            argument = first_argument(source, match.end())
            direct = re.fullmatch(r"ApiEndpoints\s*\.\s*(\w+)\s*\.\s*(\w+)(?:\([\s\S]*\))?", argument)
            expanded = re.sub(r"\$\{ApiEndpoints\.(\w+\.\w+)\}", lambda m: definitions.get(m[1], {}).get("path") or m[0], argument)
            literal = re.fullmatch(r"(['\"])(/[\s\S]*)\1", expanded)
            external = re.fullmatch(r"(['\"])(https?://[\s\S]*)\1", argument)
            path = definitions.get(direct[1] + "." + direct[2], {}).get("path") if direct else None
            if literal:
                path = path_template(literal[2])
            found = [route for route in routes if path and route["method"] in (match[2].upper(), "ALL") and route_matches(route["path"], path)]
            status = "external_url" if external else "matched" if found else "unresolved" if path is None else "no_matching_route"
            calls.append({"file": str(file.relative_to(root)), "line": line_at(source, match.start()),
                          "method": match[2].upper(), "argument": argument, "path": path,
                          "status": status, "backend": found})
    return calls


def live_map_routes(root, routes):
    """Inspect the concrete production-role factories independently of dispatch.

    These are configuration declarations, not extra HTTP call sites. The demo
    factory is excluded because it is disabled for the App Store distribution.
    """
    file = root / "lib/features/live_map/models/live_map_role_config.dart"
    source = uncomment(file.read_text(encoding="utf-8"))
    factories = list(re.finditer(r"factory LiveMapRoleConfig\.(\w+)\([^)]*\)\s*\{", source))
    findings = []
    for index, factory in enumerate(factories):
        if factory[1] not in ("superadmin", "admin", "user"):
            continue
        end = factories[index + 1].start() if index + 1 < len(factories) else len(source)
        body = source[factory.end():end]
        base = re.search(r"const base = (['\"])([^'\"]+)\1;", body)
        if not base:
            findings.append({"role": factory[1], "status": "unresolved", "reason": "factory base is not a literal"})
            continue
        for field in re.finditer(r"(\w+):\s*(?:\([^)]*\)\s*=>\s*)?(['\"])(\$base/[^'\"]+|/user/commands/send-bulk)\2", body):
            method = "POST" if field[1] in ("sendCommandByImei", "userSendCommandBulkEndpoint") else "GET"
            path = path_template(field[3].replace("$base", base[2]))
            found = [route for route in routes if route["method"] in (method, "ALL") and route_matches(route["path"], path)]
            findings.append({"role": factory[1], "field": field[1], "method": method, "path": path,
                             "status": "matched" if found else "no_matching_route", "backend": found,
                             "file": str(file.relative_to(root)), "line": line_at(source, factory.end() + field.start())})
    return findings


def native_checks(root):
    checks = []

    def check(name, okay, detail):
        checks.append({"check": name, "status": "pass" if okay else "fail", "detail": detail})

    info = None
    for file in sorted((root / "ios").rglob("*")):
        if file.suffix not in (".plist", ".entitlements", ".xcprivacy"):
            continue
        try:
            value = plistlib.loads(file.read_bytes())
            check("plist syntax", True, str(file.relative_to(root)))
            if file == root / "ios/Runner/Info.plist":
                info = value
        except (ValueError, plistlib.InvalidFileException) as error:
            check("plist syntax", False, f"{file.relative_to(root)}: {error}")
    if info:
        ats = info.get("NSAppTransportSecurity", {})
        check("no global ATS bypass", not ats.get("NSAllowsArbitraryLoads", False), "Info.plist NSAllowsArbitraryLoads")
        for name in ("UILaunchStoryboardName", "UIMainStoryboardFile"):
            if info.get(name):
                storyboard = root / "ios/Runner/Base.lproj" / (info[name] + ".storyboard")
                check("storyboard resource exists", storyboard.is_file(), str(storyboard.relative_to(root)))
    for file in sorted((root / "ios/Runner/Assets.xcassets").rglob("Contents.json")):
        for item in json.loads(file.read_text()).get("images", []):
            if item.get("filename"):
                image = file.parent / item["filename"]
                check("asset catalog resource exists", image.is_file(), str(image.relative_to(root)))
    privacy = root / "ios/Runner/PrivacyInfo.xcprivacy"
    check("app privacy manifest exists", privacy.is_file(), "ios/Runner/PrivacyInfo.xcprivacy")
    pbx = (root / "ios/Runner.xcodeproj/project.pbxproj").read_text()
    resource_section = re.search(r"/\* Begin PBXResourcesBuildPhase section \*/([\s\S]*?)/\* End PBXResourcesBuildPhase section \*/", pbx)
    check("privacy manifest in Xcode resources", bool(resource_section and "PrivacyInfo.xcprivacy in Resources" in resource_section[1]), "Runner PBXResourcesBuildPhase")
    return checks


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
    parser.add_argument("--backend", type=Path, help="Read-only backend root containing src/")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    report = {"scope": "Source inspection only: not a Flutter compile, API integration test, security review, or App Store approval.", "native_checks": native_checks(args.root)}
    failures = sum(item["status"] == "fail" for item in report["native_checks"])
    if args.backend:
        routes, unsupported = backend_routes(args.backend)
        definitions = endpoint_definitions(args.root)
        calls = api_calls(args.root, definitions, routes)
        map_routes = live_map_routes(args.root, routes)
        report.update({"backend_route_count": len(routes), "unsupported_backend_decorators": unsupported,
                       "api_call_summary": dict(Counter(item["status"] for item in calls)), "api_calls": calls,
                       "live_map_config_summary": dict(Counter(item["status"] for item in map_routes)),
                       "live_map_config_routes": map_routes})
        failures += sum(item["status"] == "no_matching_route" for item in calls)
        failures += sum(item["status"] == "no_matching_route" for item in map_routes)
    report["failure_count"] = failures
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({key: value for key, value in report.items() if key not in ("native_checks", "api_calls", "live_map_config_routes")}, indent=2))
    for check in report["native_checks"]:
        if check["status"] == "fail":
            print("FAIL:", check["check"], check["detail"])
    for call in report.get("api_calls", []) + report.get("live_map_config_routes", []):
        if call["status"] == "no_matching_route":
            print("API MISMATCH:", call["method"], call["path"], f"{call['file']}:{call['line']}")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
