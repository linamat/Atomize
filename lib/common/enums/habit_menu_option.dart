import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum HabitMenuOption {
  edit,
  archive,
  delete,
}

extension HabitMenuOptionExtension on HabitMenuOption {
  String name(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case HabitMenuOption.edit:
        return l10n.edit;
      case HabitMenuOption.archive:
        return l10n.archive;
      case HabitMenuOption.delete:
        return l10n.delete;
    }
  }
}
