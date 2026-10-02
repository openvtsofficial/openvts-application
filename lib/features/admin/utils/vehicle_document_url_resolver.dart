/// Resolves a vehicle document to an openable URL.
///
/// Priority order (mirrors the web application):
///   1. [AdminVehicleDocument.url] — if non-empty and valid absolute HTTP/HTTPS
///   2. [AdminVehicleDocument.filePath] — relative path, prefixed with the
///      active API base URL
///   3. Returns `null` when neither field yields a usable URL.
///
/// Base URL handling (matches web-app `buildFileUrl`):
///   - Absolute base URL (http/https): only the origin is kept, any path is
///     discarded — a reverse-proxy prefix like `/api` only applies in the
///     relative case.
///   - Relative base URL (e.g. `/api`): used verbatim after stripping trailing
///     slashes.
///
/// Path rules:
///   - No duplicate slashes between base and path.
///   - Encoded path segments and query parameters are preserved.
///   - A leading `/` in the path is always guaranteed.
class VehicleDocumentUrlResolver {
  const VehicleDocumentUrlResolver._();

  /// Resolves [url] or [filePath] against [apiBaseUrl] into an openable [Uri].
  ///
  /// Returns `null` if neither value produces a valid URL.
  static Uri? resolve({
    required String url,
    required String filePath,
    required String apiBaseUrl,
  }) {
    // Priority 1: absolute URL field.
    final trimmedUrl = url.trim();
    if (trimmedUrl.isNotEmpty) {
      if (_isAbsolute(trimmedUrl)) {
        return Uri.tryParse(trimmedUrl);
      }
      // url field is present but not absolute — fall through to filePath logic
      // using this value as the relative path.
      return _resolveRelative(trimmedUrl, apiBaseUrl);
    }

    // Priority 2: filePath field.
    final trimmedPath = filePath.trim();
    if (trimmedPath.isEmpty) return null;
    if (_isAbsolute(trimmedPath)) {
      return Uri.tryParse(trimmedPath);
    }
    return _resolveRelative(trimmedPath, apiBaseUrl);
  }

  static bool _isAbsolute(String value) {
    final lower = value.toLowerCase();
    return lower.startsWith('http://') || lower.startsWith('https://');
  }

  /// Combines [apiBaseUrl] and a relative [path] without duplicate slashes.
  ///
  /// - Absolute base URL → use origin only (mirrors web-app behaviour where an
  ///   absolute URL is assumed to be the raw backend; `/api` is a proxy prefix
  ///   and is not part of the origin).
  /// - Relative base URL (e.g. `/api`) → used as-is.
  static Uri? _resolveRelative(String path, String apiBaseUrl) {
    final base = apiBaseUrl.trim();

    String effectiveBase;
    if (_isAbsolute(base)) {
      final parsed = Uri.tryParse(base);
      if (parsed == null) return null;
      // Keep scheme + authority only (strip any path such as "/api").
      effectiveBase = '${parsed.scheme}://${parsed.authority}';
    } else {
      effectiveBase = base.replaceAll(RegExp(r'/+$'), '');
    }

    // Ensure the path begins with exactly one slash.
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.tryParse('$effectiveBase$normalizedPath');
  }
}
