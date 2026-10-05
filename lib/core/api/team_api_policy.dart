import 'api_endpoints.dart';
import 'api_exception.dart';

/// Explicit method/path adaptation for shared Admin screens under a Team login.
class TeamApiPolicy {
  const TeamApiPolicy._();
  static String resolve(String method, String path) {
    if (!path.startsWith('${TeamApiEndpointRules.adminPrefix}/')) return path;
    final suffix = path.substring(TeamApiEndpointRules.adminPrefix.length);
    String? target = TeamApiEndpointRules.exact[suffix];
    if (target == null) {
      for (final entry in TeamApiEndpointRules.patterns) {
        final match = entry.$1.firstMatch(suffix);
        if (match != null) {
          target = entry.$2(match);
          break;
        }
      }
    }
    target ??= '/team$suffix';
    if (!isSupported(method, target)) {
      throw const ApiException(
        message: 'This action is not available for your team account.',
        statusCode: 403,
      );
    }
    return target;
  }

  static bool isSupported(String method, String path) => _contracts.any(
    (entry) => entry.$1 == method.toUpperCase() && entry.$2.hasMatch(path),
  );
  static final _contracts = teamApiContracts
      .map((contract) {
        final parts = contract.split(' ');
        final pattern = parts[1]
            .split('/')
            .map(
              (part) => part.startsWith(':') ? r'[^/]+' : RegExp.escape(part),
            )
            .join('/');
        return (parts[0], RegExp('^$pattern\$'));
      })
      .toList(growable: false);
}
