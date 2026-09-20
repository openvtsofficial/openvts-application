import 'package:flutter/material.dart';

import '../../../../../core/theme/open_vts_spacing.dart';
import '../../../../../core/theme/open_vts_typography.dart';
import '../../../../../shared/widgets/open_vts_text_field.dart';

class AdminUserDropdownOption {
  const AdminUserDropdownOption({
    required this.value,
    required this.label,
    this.isFallback = false,
  });

  final String value;
  final String label;
  final bool isFallback;
}

class AdminUserFormSection extends StatelessWidget {
  const AdminUserFormSection({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: OpenVtsTypography.label.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: OpenVtsSpacing.sm),
        ...children,
      ],
    );
  }
}

class AdminUserDropdownField extends StatelessWidget {
  const AdminUserDropdownField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.hintText,
    this.prefixIcon,
    this.validator,
    this.isLoading = false,
    this.selectedLabel,
    this.searchable = false,
    super.key,
  });

  final String label;
  final String? value;
  final List<AdminUserDropdownOption> options;
  final ValueChanged<String?>? onChanged;
  final String? hintText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final bool isLoading;

  /// When non-null, overrides the text shown in the closed field for the
  /// selected value. The full [AdminUserDropdownOption.label] is still shown
  /// in the open menu. Has no effect on other dropdowns.
  final String? Function(String value)? selectedLabel;

  /// When true, replaces the standard dropdown with a tappable field that
  /// opens a searchable bottom sheet. Useful for long lists (countries, states,
  /// cities) where the user benefits from typing to filter.
  final bool searchable;

  @override
  Widget build(BuildContext context) {
    final normalizedValue = _normalized(value);
    final menuItems = _menuItems(normalizedValue);
    final safeValue = menuItems.any((item) => item.value == normalizedValue)
        ? normalizedValue
        : null;
    final optionSignature = menuItems.map((item) => item.value ?? '').join('|');

    final resolvedSelectedLabel = selectedLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: OpenVtsTypography.label),
        const SizedBox(height: OpenVtsSpacing.xs),
        if (searchable)
          _SearchableField(
            key: ValueKey('search:$label:${safeValue ?? ''}:$optionSignature'),
            label: label,
            safeValue: safeValue,
            options: _distinctRawOptions(),
            hintText: hintText,
            prefixIcon: prefixIcon,
            isLoading: isLoading,
            validator: validator,
            selectedLabel: resolvedSelectedLabel,
            onChanged: onChanged,
          )
        else
          DropdownButtonFormField<String>(
            key: ValueKey('$label:${safeValue ?? ''}:$optionSignature'),
            initialValue: safeValue,
            isExpanded: true,
            items: menuItems,
            onChanged: isLoading ? null : onChanged,
            validator: validator,
            dropdownColor: Theme.of(context).colorScheme.surface,
            selectedItemBuilder: resolvedSelectedLabel == null
                ? null
                : (context) => menuItems.map((item) {
                      final compact = item.value == null
                          ? ''
                          : (resolvedSelectedLabel(item.value!) ?? item.value!);
                      return Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          compact,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: OpenVtsTypography.body.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      );
                    }).toList(growable: false),
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(
                      prefixIcon,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              suffixIcon: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
            ),
          ),
      ],
    );
  }

  List<AdminUserDropdownOption> _distinctRawOptions() {
    final distinct = <AdminUserDropdownOption>[];
    final seen = <String>{};
    for (final option in options) {
      final v = option.value.trim();
      if (v.isEmpty || seen.contains(v)) continue;
      seen.add(v);
      distinct.add(AdminUserDropdownOption(
        value: v,
        label: option.label.trim().isEmpty ? v : option.label,
        isFallback: option.isFallback,
      ));
    }
    return distinct;
  }

  List<DropdownMenuItem<String>> _menuItems(String? normalizedValue) {
    final distinctOptions = <AdminUserDropdownOption>[];
    final seen = <String>{};
    for (final option in options) {
      final optionValue = option.value.trim();
      if (optionValue.isEmpty || seen.contains(optionValue)) {
        continue;
      }
      seen.add(optionValue);
      distinctOptions.add(
        AdminUserDropdownOption(
          value: optionValue,
          label: option.label.trim().isEmpty ? optionValue : option.label,
          isFallback: option.isFallback,
        ),
      );
    }

    if (normalizedValue != null && !seen.contains(normalizedValue)) {
      distinctOptions.insert(
        0,
        AdminUserDropdownOption(
          value: normalizedValue,
          label: '$normalizedValue (current)',
          isFallback: true,
        ),
      );
    }

    return distinctOptions
        .map(
          (option) => DropdownMenuItem<String>(
            value: option.value,
            enabled: !option.isFallback,
            child: Builder(
              builder: (context) => Text(
                option.label,
                overflow: TextOverflow.ellipsis,
                style: OpenVtsTypography.body.copyWith(
                  color: option.isFallback
                      ? Theme.of(context).colorScheme.outline
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        )
        .toList(growable: false);
  }
}

// ---------------------------------------------------------------------------
// Searchable variant — tappable field + bottom-sheet search list
// ---------------------------------------------------------------------------

class _SearchableField extends StatelessWidget {
  const _SearchableField({
    required this.label,
    required this.safeValue,
    required this.options,
    required this.hintText,
    required this.prefixIcon,
    required this.isLoading,
    required this.validator,
    required this.selectedLabel,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String? safeValue;
  final List<AdminUserDropdownOption> options;
  final String? hintText;
  final IconData? prefixIcon;
  final bool isLoading;
  final String? Function(String?)? validator;
  final String? Function(String value)? selectedLabel;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final disabled = isLoading || onChanged == null;

    final selectedOption = safeValue == null
        ? null
        : options.firstWhere(
            (o) => o.value == safeValue,
            orElse: () =>
                AdminUserDropdownOption(value: safeValue!, label: safeValue!),
          );

    return FormField<String>(
      initialValue: safeValue,
      validator: validator,
      builder: (state) {
        return GestureDetector(
          onTap: disabled ? null : () => _openSheet(context),
          child: InputDecorator(
            decoration: InputDecoration(
              errorText: state.errorText,
              hintText: hintText,
              enabled: !disabled,
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(
                      prefixIcon,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              suffixIcon: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: disabled
                          ? Theme.of(context).disabledColor
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
            ),
            isEmpty: safeValue == null,
            child: safeValue == null
                ? const SizedBox.shrink()
                : Text(
                    selectedLabel?.call(safeValue!) ??
                        selectedOption?.label ??
                        safeValue!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: OpenVtsTypography.body.copyWith(
                      color: disabled
                          ? Theme.of(context).disabledColor
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _openSheet(BuildContext context) {
    showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _DropdownSearchSheet(
        label: label,
        options: options,
        currentValue: safeValue,
      ),
    ).then((selected) {
      if (selected != null) onChanged?.call(selected);
    });
  }
}

class _DropdownSearchSheet extends StatefulWidget {
  const _DropdownSearchSheet({
    required this.label,
    required this.options,
    required this.currentValue,
  });

  final String label;
  final List<AdminUserDropdownOption> options;
  final String? currentValue;

  @override
  State<_DropdownSearchSheet> createState() => _DropdownSearchSheetState();
}

class _DropdownSearchSheetState extends State<_DropdownSearchSheet> {
  final _searchController = TextEditingController();
  late List<AdminUserDropdownOption> _filtered;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _filtered = widget.options;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _searchText = query;
      _filtered = q.isEmpty
          ? widget.options
          : widget.options
              .where(
                (o) =>
                    o.label.toLowerCase().contains(q) ||
                    o.value.toLowerCase().contains(q),
              )
              .toList(growable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (ctx, scrollController) {
        return Column(
          children: [
            const SizedBox(height: OpenVtsSpacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.md),
              child: Text(
                'Select ${widget.label}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: OpenVtsSpacing.sm),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: OpenVtsSpacing.md),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: 'Search ${widget.label.toLowerCase()}…',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _searchText.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          tooltip: 'Clear',
                          onPressed: () {
                            _searchController.clear();
                            _onSearch('');
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: OpenVtsSpacing.sm,
                    vertical: OpenVtsSpacing.sm,
                  ),
                ),
              ),
            ),
            const SizedBox(height: OpenVtsSpacing.xs),
            const Divider(height: 1),
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Text(
                        _searchText.trim().isEmpty
                            ? 'No options available'
                            : 'No results for "$_searchText"',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: _filtered.length,
                      itemBuilder: (_, index) {
                        final option = _filtered[index];
                        final isSelected = option.value == widget.currentValue;
                        return ListTile(
                          dense: true,
                          title: Text(
                            option.label,
                            style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                                  color: isSelected
                                      ? Theme.of(ctx).colorScheme.primary
                                      : Theme.of(ctx).colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_rounded,
                                  size: 18,
                                  color: Theme.of(ctx).colorScheme.primary,
                                )
                              : null,
                          onTap: () => Navigator.of(ctx).pop(option.value),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Responsive prefix + number row (used by edit-profile forms)
// ---------------------------------------------------------------------------

/// A responsive prefix + number row used by both edit-profile forms.
///
/// At ≥ 300 logical pixels it places the dropdown and text field side-by-side.
/// On narrower widths they stack vertically. The dropdown uses [selectedLabel]
/// so the closed field shows only the dial code (e.g. +91) while the open menu
/// still shows the full "+91 IN" label.
class AdminUserPrefixPhoneRow extends StatelessWidget {
  const AdminUserPrefixPhoneRow({
    required this.prefixValue,
    required this.prefixOptions,
    required this.onPrefixChanged,
    required this.phoneController,
    required this.phoneValidator,
    this.isLoading = false,
    super.key,
  });

  final String? prefixValue;
  final List<AdminUserDropdownOption> prefixOptions;
  final ValueChanged<String?> onPrefixChanged;
  final TextEditingController phoneController;
  final String? Function(String?)? phoneValidator;
  final bool isLoading;

  static const double _breakpoint = 300;
  static const double _prefixFlex = 0.38;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= _breakpoint;

        final prefixField = AdminUserDropdownField(
          label: 'Mobile Prefix',
          value: prefixValue,
          options: prefixOptions,
          hintText: '+91',
          prefixIcon: Icons.phone_android_rounded,
          isLoading: isLoading,
          validator: requiredDropdown,
          selectedLabel: (v) => v,
          searchable: true,
          onChanged: onPrefixChanged,
        );

        final numberField = OpenVtsTextField(
          label: 'Mobile Number',
          controller: phoneController,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          prefixIcon: Icons.phone_rounded,
          validator: phoneValidator,
        );

        if (wide) {
          final prefixWidth =
              (constraints.maxWidth * _prefixFlex).clamp(90.0, 160.0);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: prefixWidth, child: prefixField),
              const SizedBox(width: OpenVtsSpacing.sm),
              Expanded(child: numberField),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            prefixField,
            const SizedBox(height: OpenVtsSpacing.sm),
            numberField,
          ],
        );
      },
    );
  }
}

String? requiredDropdown(String? value) {
  if (_normalized(value) == null) {
    return 'Required';
  }
  return null;
}

String? _normalized(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }
  return normalized;
}
