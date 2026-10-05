import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/open_vts_spacing.dart';
import '../../core/theme/open_vts_typography.dart';
import '../helpers/validation_localizations.dart';

class OpenVtsTextField extends StatelessWidget {
  const OpenVtsTextField({
    required this.label,
    this.controller,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.prefixIcon,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.focusNode,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final isPassword =
        obscureText ||
        (autofillHints?.any(
              (hint) =>
                  hint == AutofillHints.password ||
                  hint == AutofillHints.newPassword,
            ) ??
            false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(child: Text(label, style: OpenVtsTypography.label)),
        const SizedBox(height: OpenVtsSpacing.xs),
        Semantics(
          label: label,
          child: TextFormField(
            enabled: enabled,
            readOnly: readOnly,
            onChanged: onChanged,
            focusNode: focusNode,
            autocorrect: !isPassword,
            enableSuggestions: !isPassword,
            controller: controller,
            validator: context.localizedValidator(validator),
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLines: maxLines,
            maxLength: maxLength,
            textInputAction: textInputAction,
            autofillHints: autofillHints,
            inputFormatters: inputFormatters,
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(
                      prefixIcon,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
