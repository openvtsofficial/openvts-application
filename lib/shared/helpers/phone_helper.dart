class NormalizedPhone {
  const NormalizedPhone({
    required this.dialCode,
    required this.nationalNumber,
    required this.displayNumber,
  });

  final String dialCode;
  final String nationalNumber;
  final String displayNumber;
}

NormalizedPhone normalizePhoneParts({
  required String dialCode,
  required String mobile,
}) {
  final cleanDialCode = dialCode.trim();
  var cleanMobile = mobile.trim().replaceAll(RegExp(r'[\s\-]+'), '');

  if (cleanDialCode.isNotEmpty && cleanMobile.isNotEmpty) {
    final dialDigits = cleanDialCode.replaceAll('+', '');

    if (cleanMobile.startsWith(cleanDialCode)) {
      cleanMobile = cleanMobile.substring(cleanDialCode.length);
    } else if (cleanMobile.startsWith('+$dialDigits')) {
      cleanMobile = cleanMobile.substring(dialDigits.length + 1);
    } else if (cleanMobile.startsWith(dialDigits) &&
        cleanMobile.length > dialDigits.length + 6) {
      cleanMobile = cleanMobile.substring(dialDigits.length);
    }
  }

  if (cleanMobile.startsWith('0') && cleanMobile.length > 7) {
    cleanMobile = cleanMobile.substring(1);
  }

  cleanMobile = cleanMobile.replaceAll(RegExp(r'[^\d]'), '');

  final display = [cleanDialCode, cleanMobile]
      .where((p) => p.isNotEmpty && p != '-')
      .join(' ')
      .trim();

  return NormalizedPhone(
    dialCode: cleanDialCode,
    nationalNumber: cleanMobile,
    displayNumber: display.isEmpty ? '-' : display,
  );
}
