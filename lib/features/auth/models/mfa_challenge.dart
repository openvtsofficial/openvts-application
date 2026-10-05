/// An unauthenticated, short-lived verification challenge. Never persisted.
class MfaChallenge {
  const MfaChallenge({required this.token, required this.expiresAt});
  final String token;
  final DateTime expiresAt;
  bool get isExpired => !DateTime.now().isBefore(expiresAt);
  factory MfaChallenge.fromJson(Map<String, dynamic> json) {
    final token = json['challengeToken']?.toString() ?? '';
    final seconds = int.tryParse('${json['expiresIn']}') ?? 300;
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(token) || seconds <= 0) {
      throw const FormatException('Invalid sign-in verification challenge.');
    }
    return MfaChallenge(
        token: token,
        expiresAt: DateTime.now().add(Duration(seconds: seconds)));
  }
}

class MfaRequiredException implements Exception {
  const MfaRequiredException(this.challenge);
  final MfaChallenge challenge;
}
