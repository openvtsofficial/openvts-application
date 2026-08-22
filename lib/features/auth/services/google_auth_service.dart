import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  GoogleAuthService._();

  static final GoogleAuthService instance = GoogleAuthService._();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    await _googleSignIn.initialize();
    _initialized = true;
  }

  Future<String?> signInAndGetServerAuthCode() async {
    await initialize();

    final account = await _googleSignIn.authenticate();

    final authorization = await account.authorizationClient
        .authorizeServer(const <String>[]);

    return authorization?.serverAuthCode;
  }

  Future<void> signOut() async {
    await initialize();
    await _googleSignIn.signOut();
  }
}
