import 'dart:typed_data';

/// Private proof metadata returned by OperationsTripProofDto. Proof IDs are
/// decimal strings (database bigint), never parsed as floating point numbers.
class UserOperationProof {
  const UserOperationProof({
    required this.tripId,
    required this.id,
    required this.name,
    required this.mimeType,
    required this.sizeBytes,
  });
  final String tripId;
  final String id;
  final String name;
  final String mimeType;
  final int sizeBytes;
  static const maxBytes = 5 * 1024 * 1024;
  static const extensions = {
    'application/pdf': 'pdf',
    'image/jpeg': 'jpg',
    'image/png': 'png',
    'image/webp': 'webp',
  };

  factory UserOperationProof.fromJson(
    String tripId,
    Map<String, dynamic> json,
  ) {
    final proof = UserOperationProof(
      tripId: tripId,
      id: '${json['id'] ?? ''}',
      name: '${json['originalFileName'] ?? 'proof'}',
      mimeType: '${json['mimeType'] ?? ''}'.toLowerCase(),
      sizeBytes: int.tryParse('${json['sizeBytes']}') ?? 0,
    );
    proof.validate();
    if (json['assignmentId'] != null && '${json['assignmentId']}' != tripId) {
      throw const FormatException(
        'This proof does not belong to the selected trip.',
      );
    }
    return proof;
  }
  void validate() {
    if (!RegExp(
          r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
        ).hasMatch(tripId) ||
        !RegExp(r'^[1-9][0-9]*$').hasMatch(id)) {
      throw const FormatException('Invalid trip proof identifier.');
    }
    if (!extensions.containsKey(mimeType) ||
        sizeBytes < 1 ||
        sizeBytes > maxBytes) {
      throw const FormatException(
        'This proof has an unsupported type or size.',
      );
    }
  }

  bool get isImage => mimeType.startsWith('image/');
  String get safeName {
    var value = name
        .replaceAll(RegExp(r'[\\/:*?"<>|\x00-\x1f\x7f]'), '_')
        .trim();
    if (value.length > 160) value = value.substring(0, 160);
    final extension = extensions[mimeType] ?? 'bin';
    if (value.isEmpty || value == '.' || value == '..') value = 'proof-$id';
    if (!value.toLowerCase().endsWith('.$extension')) {
      value = '$value.$extension';
    }
    return value;
  }

  void validateContent(Uint8List bytes) {
    if (bytes.isEmpty || bytes.length > maxBytes || bytes.length != sizeBytes) {
      throw const FormatException(
        'The downloaded proof is incomplete or has changed. Refresh the trip.',
      );
    }
    bool starts(List<int> signature) =>
        bytes.length >= signature.length &&
        Iterable<int>.generate(
          signature.length,
        ).every((i) => bytes[i] == signature[i]);
    final valid = switch (mimeType) {
      'application/pdf' => starts([0x25, 0x50, 0x44, 0x46, 0x2d]),
      'image/jpeg' => starts([0xff, 0xd8, 0xff]),
      'image/png' => starts([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
      'image/webp' =>
        starts([0x52, 0x49, 0x46, 0x46]) &&
            bytes.length >= 12 &&
            bytes[8] == 0x57 &&
            bytes[9] == 0x45 &&
            bytes[10] == 0x42 &&
            bytes[11] == 0x50,
      _ => false,
    };
    if (!valid) {
      throw const FormatException(
        'The downloaded proof does not match its file type.',
      );
    }
  }

  @override
  bool operator ==(Object other) =>
      other is UserOperationProof &&
      other.tripId == tripId &&
      other.id == id &&
      other.mimeType == mimeType &&
      other.sizeBytes == sizeBytes &&
      other.name == name;
  @override
  int get hashCode => Object.hash(tripId, id, mimeType, sizeBytes, name);
}
