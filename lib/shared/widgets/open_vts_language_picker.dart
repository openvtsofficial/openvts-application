import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/app_preferences_provider.dart';
import '../../l10n/app_localizations.dart';
import '../helpers/toast_helper.dart';

/// Native names keep the picker usable even after choosing an unfamiliar language.
String appLanguageNativeName(Locale locale) => switch (locale.languageCode) {
  'en' => 'English',
  'hi' => 'हिन्दी',
  'ar' => 'العربية',
  'es' => 'Español',
  'fr' => 'Français',
  'pt' => 'Português',
  _ => locale.toLanguageTag(),
};

Future<void> showOpenVtsLanguagePicker(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const _AppLanguagePicker(),
    );

class _AppLanguagePicker extends ConsumerStatefulWidget {
  const _AppLanguagePicker();

  @override
  ConsumerState<_AppLanguagePicker> createState() => _AppLanguagePickerState();
}

class _AppLanguagePickerState extends ConsumerState<_AppLanguagePicker> {
  bool _saving = false;

  Future<void> _select(Locale locale) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(appLocalizationPreferencesProvider.notifier)
          .selectLanguage(locale.languageCode);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ToastHelper.showError(
        AppLocalizations.of(context).failedToUpdate,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(
      appLocalizationPreferencesProvider.select(
        (preferences) => preferences.languageCode,
      ),
    );
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * .8,
      ),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.selectLanguage,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: l10n.close,
                  onPressed: _saving ? null : () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          for (final locale in AppLocalizations.supportedLocales)
            Semantics(
              selected: selected == locale.languageCode,
              child: ListTile(
                key: ValueKey('language-${locale.languageCode}'),
                minTileHeight: 56,
                enabled: !_saving,
                title: Text(appLanguageNativeName(locale)),
                trailing: selected == locale.languageCode
                    ? Icon(
                        Icons.check_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => _select(locale),
              ),
            ),
        ],
      ),
    );
  }
}
