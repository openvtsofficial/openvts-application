import 'package:flutter/material.dart';

import '../helpers/widget_localizations.dart';
import 'open_vts_searchable_dropdown.dart';

class SearchableDropdownItem<T> {
  const SearchableDropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.searchTerms = const <String>[],
  });

  final T value;
  final String label;

  /// Optional second line shown in the dropdown list tile.
  final String? subtitle;

  /// Extra strings searched alongside [label] (e.g. email, username).
  /// Not displayed — used only for filtering.
  final List<String> searchTerms;

  bool matchesQuery(String q) {
    if (q.isEmpty) return true;
    if (label.toLowerCase().contains(q)) return true;
    if (subtitle != null && subtitle!.toLowerCase().contains(q)) return true;
    return searchTerms.any((t) => t.toLowerCase().contains(q));
  }
}

/// A [FormField] that looks like a standard outlined dropdown field.
/// Uses the same accessible, keyboard-safe sheet as other mobile pickers.
class SearchableDropdownField<T> extends FormField<T> {
  SearchableDropdownField({
    required String label,
    required List<SearchableDropdownItem<T>> items,
    required ValueChanged<T?> onChanged,
    super.initialValue,
    super.validator,
    super.enabled = true,
    String? hintText,
    String? searchHint,
    super.key,
  }) : super(
         builder: (field) {
           final selectedLabel = items
               .where((i) => i.value == field.value)
               .map((i) => i.label)
               .firstOrNull;

           return _SearchableDropdownTile<T>(
             label: label,
             hintText: hintText ?? field.context.widgetL10n.select,
             searchHint: searchHint ?? field.context.widgetL10n.search,
             selectedLabel: selectedLabel,
             selectedValue: field.value,
             items: items,
             enabled: enabled,
             errorText: field.errorText,
             onSelected: (v) {
               field.didChange(v);
               onChanged(v);
             },
           );
         },
       );
}

class _SearchableDropdownTile<T> extends StatefulWidget {
  const _SearchableDropdownTile({
    required this.label,
    required this.hintText,
    required this.searchHint,
    required this.selectedLabel,
    required this.selectedValue,
    required this.items,
    required this.enabled,
    required this.onSelected,
    this.errorText,
    super.key,
  });

  final String label;
  final String hintText;
  final String searchHint;
  final String? selectedLabel;
  final T? selectedValue;
  final List<SearchableDropdownItem<T>> items;
  final bool enabled;
  final String? errorText;
  final ValueChanged<T?> onSelected;

  @override
  State<_SearchableDropdownTile<T>> createState() =>
      _SearchableDropdownTileState<T>();
}

class _SearchableDropdownTileState<T>
    extends State<_SearchableDropdownTile<T>> {
  bool _open = false;

  Future<void> _openDropdown() async {
    if (_open || !widget.enabled) return;
    setState(() => _open = true);
    final previousValue = widget.selectedValue;
    final result = await showOpenVtsDropdownPicker<T>(
      context: context,
      title: widget.label,
      selectedValue: widget.selectedValue,
      searchHintText: widget.searchHint,
      options: [
        for (final item in widget.items)
          OpenVtsDropdownOption<T>(
            value: item.value,
            label: item.label,
            subtitle: item.subtitle,
            searchText: item.searchTerms.join(' '),
          ),
      ],
    );
    if (!mounted) return;
    setState(() => _open = false);
    if (result == null ||
        !widget.enabled ||
        widget.selectedValue != previousValue) {
      return;
    }
    if (!result.cleared &&
        !widget.items.any((item) => item.value == result.option?.value)) {
      return;
    }
    widget.onSelected(result.cleared ? null : result.option?.value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabledColor = theme.disabledColor;

    return Semantics(
      button: true,
      enabled: widget.enabled,
      label: widget.label,
      value: widget.selectedLabel,
      child: InkWell(
        onTap: widget.enabled ? _openDropdown : null,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
            errorText: widget.errorText,
            enabled: widget.enabled,
            suffixIcon: AnimatedRotation(
              turns: _open ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.arrow_drop_down,
                color: widget.enabled ? null : disabledColor,
              ),
            ),
          ),
          isFocused: _open,
          isEmpty: false,
          child: Text(
            widget.selectedLabel ?? widget.hintText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: widget.enabled
                  ? (widget.selectedLabel == null
                        ? theme.hintColor
                        : theme.colorScheme.onSurface)
                  : disabledColor,
            ),
          ),
        ),
      ),
    );
  }
}
