import 'package:flutter/material.dart';
import '../../../../shared/helpers/mobile_text.dart';

extension OperationsText on BuildContext {
  String operationText(
    String source, [
    Map<String, Object> values = const {},
  ]) => mobileText(source, values);
}
