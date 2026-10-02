/// A short-lived login challenge. Never saved to device storage.
class MfaLoginChallenge implements Exception {
  const MfaLoginChallenge({required this.token, required this.expiresAt});

  final String token;
  final DateTime expiresAt;
  bool get isExpired => !DateTime.now().isBefore(expiresAt);

  factory MfaLoginChallenge.fromJson(Map<String, dynamic> json) {
    final token = json['challengeToken']?.toString() ?? '';
    final seconds = json['expiresIn'];
    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(token) ||
        seconds is! num || seconds <= 0) {
      throw const FormatException('Invalid login verification response.');
    }
    return MfaLoginChallenge(
      token: token,
      expiresAt: DateTime.now().add(Duration(seconds: seconds.toInt())),
    );
  }
}
