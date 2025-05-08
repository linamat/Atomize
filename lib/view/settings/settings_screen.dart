import 'package:atomize/controllers/habit_controller.dart';
import 'package:atomize/view/theme/color_palette.dart';
import 'package:atomize/controllers/app_state_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const _SettingsScreenBody();
  }
}

class _SettingsScreenBody extends StatelessWidget {
  const _SettingsScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sections = <Widget>[
      const AppearanceSection(),
      const LanguageSection(),
      const DataSection(),
      const AboutSection(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, i) => sections[i],
      ),
    );
  }
}

class AppearanceSection extends StatelessWidget {
  const AppearanceSection({Key? key}) : super(key: key);

  void _showColorPicker(BuildContext ctx, AppStateController ctl) {
    Color tempColor = ctl.primaryColor;
    final l10n = AppLocalizations.of(ctx)!;

    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.primaryColor, style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 12),
              ColorPicker(
                pickerColor: tempColor,
                onColorChanged: (c) {
                  setState(() => tempColor = c);
                },
                enableAlpha: false,
                pickerAreaHeightPercent: 0.5,
              ),
              const SizedBox(height: 12),
              Container(
                height: 40,
                width: double.infinity,
                color: tempColor,
                alignment: Alignment.center,
                child: Text(
                  '#${tempColor.toARGB32().toRadixString(16).toUpperCase().substring(2)}',
                  style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                        color: tempColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(l10n.cancel),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      ctl.setPrimaryColor(tempColor);
                      Navigator.pop(ctx);
                    },
                    child: Text(l10n.apply),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Consumer<AppStateController>(
        builder: (ctx, ctl, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                value: ctl.isDarkMode,
                onChanged: ctl.setDarkMode,
                title: Text(ctl.isDarkMode ? l10n.lightMode : l10n.darkMode),
                secondary: Icon(ctl.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              ),
              ListTile(
                leading: CircleAvatar(backgroundColor: ctl.primaryColor),
                title: Text(l10n.primaryColor),
                trailing: const Icon(Icons.color_lens),
                onTap: () => _showColorPicker(context, ctl),
              ),
            ],
          );
        },
      ),
    );
  }
}

class LanguageSection extends StatelessWidget {
  const LanguageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Consumer<AppStateController>(
        builder: (ctx, ctl, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
              ),
              RadioListTile<Locale>(
                title: const Text('English'),
                value: const Locale('en'),
                groupValue: ctl.locale,
                onChanged: (locale) {
                  if (locale != null) {
                    ctl.setLocale(locale);
                  }
                },
              ),
              const Divider(height: 1),
              RadioListTile<Locale>(
                title: const Text('Русский'),
                value: const Locale('ru'),
                groupValue: ctl.locale,
                onChanged: (locale) {
                  if (locale != null) {
                    ctl.setLocale(locale);
                  }
                },
              ),
              const Divider(height: 1),
              RadioListTile<Locale>(
                title: const Text('Հայերեն'),
                value: const Locale('hy'),
                groupValue: ctl.locale,
                onChanged: (locale) {
                  if (locale != null) {
                    ctl.setLocale(locale);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class DataSection extends StatelessWidget {
  const DataSection({Key? key}) : super(key: key);

  Future<void> _confirmAndReset(BuildContext ctx) async {
    final l10n = AppLocalizations.of(ctx)!;
    final confirmed = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        title: Text(l10n.resetAllData),
        content: Text(l10n.resetAllDataConfirmation),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: ColorPalette.red),
            child: Text(l10n.reset),
          ),
        ],
      ),
    );

    if (confirmed == true && ctx.mounted) {
      ctx.read<HabitController>().clearAllHabits();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text(l10n.allDataCleared)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.delete_forever, color: ColorPalette.red),
        title: Text(l10n.resetAllData, style: const TextStyle(color: ColorPalette.red)),
        onTap: () => _confirmAndReset(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.info_outline),
        title: Text(l10n.appVersion),
        subtitle: const Text('1.0.0'),
      ),
    );
  }
}
