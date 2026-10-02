import '../../../shared/models/user_role.dart';
import '../models/current_user.dart';
import '../models/mfa_login_challenge.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.isDemo = false,
    this.mfaChallenge,
    this.isVerifyingMfa = false,
  });

  const AuthState.initial() : this(status: AuthStatus.initial);
  const AuthState.loading() : this(status: AuthStatus.loading);
  const AuthState.unauthenticated({String? errorMessage})
      : this(status: AuthStatus.unauthenticated, errorMessage: errorMessage);
  const AuthState.authenticated(
    CurrentUser user, {
    bool isDemo = false,
  }) : this(
          status: AuthStatus.authenticated,
          user: user,
          isDemo: isDemo,
        );

  final AuthStatus status;
  final CurrentUser? user;
  final String? errorMessage;
  final bool isDemo;
  final MfaLoginChallenge? mfaChallenge;
  final bool isVerifyingMfa;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;
  bool get isRealSession => isAuthenticated && !isDemo;
  UserRole? get activeRole => user?.role;
  UserRole? get role => user?.role;
}
