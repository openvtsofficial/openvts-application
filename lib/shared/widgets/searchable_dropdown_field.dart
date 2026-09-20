import 'package:flutter/material.dart';

import '../../core/theme/open_vts_spacing.dart';

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
/// Tapping opens a menu that drops down from the field, containing a live
/// search bar at the top and a scrollable list of items below it.
class SearchableDropdownField<T> extends FormField<T> {
  SearchableDropdownField({
    required String label,
    required List<SearchableDropdownItem<T>> items,
    required ValueChanged<T?> onChanged,
    super.initialValue,
    super.validator,
    super.enabled = true,
    String hintText = 'Select',
    String searchHint = 'Search…',
    super.key,
  }) : super(
          builder: (field) {
            final selectedLabel = items
                .where((i) => i.value == field.value)
                .map((i) => i.label)
                .firstOrNull;

            return _SearchableDropdownTile<T>(
              label: label,
              hintText: hintText,
              searchHint: searchHint,
              selectedLabel: selectedLabel,
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
  final _key = GlobalKey();
  bool _open = false;

  Future<void> _openDropdown() async {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero, ancestor: overlay);
    final size = box.size;

    setState(() => _open = true);

    final result = await showMenu<T>(
      context: context,
      // Position menu directly below the field.
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        overlay.size.width - offset.dx - size.width,
        0,
      ),
      constraints: BoxConstraints(
        minWidth: size.width,
        maxWidth: size.width,
        maxHeight: 320,
      ),
      items: [
        PopupMenuItem<T>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: _SearchMenuContent<T>(
            searchHint: widget.searchHint,
            items: widget.items,
            onSelected: (v) => Navigator.of(context).pop(v),
          ),
        ),
      ],
    );

    if (!mounted) return;
    setState(() => _open = false);
    if (result != null) {
      widget.onSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final disabledColor = theme.disabledColor;

    return GestureDetector(
      key: _key,
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
    );
  }
}

/// The content rendered inside the popup menu — a search field + filtered list.
class _SearchMenuContent<T> extends StatefulWidget {
  const _SearchMenuContent({
    required this.searchHint,
    required this.items,
    required this.onSelected,
    super.key,
  });

  final String searchHint;
  final List<SearchableDropdownItem<T>> items;
  final ValueChanged<T> onSelected;

  @override
  State<_SearchMenuContent<T>> createState() => _SearchMenuContentState<T>();
}

class _SearchMenuContentState<T> extends State<_SearchMenuContent<T>> {
  final _controller = TextEditingController();
  late List<SearchableDropdownItem<T>> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    _controller.addListener(_onQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQuery() {
    final q = _controller.text.trim().toLowerCase();
    setState(() {
      _filtered =
          widget.items.where((i) => i.matchesQuery(q)).toList(growable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Fill the constrained width of the PopupMenuItem.
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              OpenVtsSpacing.sm,
              OpenVtsSpacing.sm,
              OpenVtsSpacing.sm,
              OpenVtsSpacing.xs,
            ),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (_, val, __) => val.text.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: _controller.clear,
                        ),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: OpenVtsSpacing.sm,
                  vertical: OpenVtsSpacing.sm,
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          if (_filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.all(OpenVtsSpacing.md),
              child: Text(
                'No results',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
            )
          else
            // Constrained scrollable list — maxHeight is set on the menu.
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _filtered
                      .map(
                        (item) => ListTile(
                          dense: true,
                          title: Text(item.label),
                          subtitle: item.subtitle != null
                              ? Text(
                                  item.subtitle!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : null,
                          onTap: () => widget.onSelected(item.value),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
