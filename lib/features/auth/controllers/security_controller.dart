import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/security_service.dart';
import 'auth_controller.dart';

final securityControllerProvider =
    StateNotifierProvider.autoDispose<SecurityController, SecurityState>(
        (ref) => SecurityController(ref.watch(securityServiceProvider),
            ref.watch(authControllerProvider.notifier)));

class SecurityState {
  const SecurityState(
      {this.status, this.tokens, this.loading = false, this.error});
  final Map<String, dynamic>? status, tokens;
  final bool loading;
  final String? error;
}

class SecurityController extends StateNotifier<SecurityState> {
  SecurityController(this._service, this._auth) : super(const SecurityState());
  final SecurityService _service;
  final AuthController _auth;
  Future<void> load() async {
    state = SecurityState(
        status: state.status, tokens: state.tokens, loading: true);
    try {
      final results = await Future.wait([_service.status(), _service.tokens()]);
      if (mounted) {
        state = SecurityState(status: results[0], tokens: results[1]);
      }
    } catch (error) {
      if (mounted) state = SecurityState(error: errorMessage(error));
    }
  }

  Future<Map<String, dynamic>> enroll(Map<String, dynamic> proof) =>
      _service.enroll(proof);
  Future<Map<String, dynamic>> confirm(String token, String code) async =>
      _apply(await _service.confirm(token, code));
  Future<Map<String, dynamic>> change(
          String action, Map<String, dynamic> proof) async =>
      _apply(await _service.change(action, proof));
  Future<Map<String, dynamic>> _apply(Map<String, dynamic> result) async {
    await _auth
        .applySecuritySession(SecurityService.payload(result['session']));
    return result;
  }

  Future<Map<String, dynamic>> createToken(Map<String, dynamic> values) =>
      _service.createToken(values);
  Future<void> revokeToken(String id) => _service.revokeToken(id);
  Future<void> deleteAccount(Map<String, dynamic> proof) async {
    await _service.deleteAccount(proof);
    await _auth.logoutAllRoles(deregisterPush: false);
  }

  static String errorMessage(Object error) =>
      SecurityService.errorMessage(error);
}
