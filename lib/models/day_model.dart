import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'day_model.g.dart';

@HiveType(typeId: 1)
enum DayState {
  @HiveField(0)
  none,
  @HiveField(1)
  done,
  @HiveField(2)
  failed,
  @HiveField(3)
  skipped;

  Color color(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (this) {
      case DayState.done:
        return colorScheme.primary;
      case DayState.failed:
        return colorScheme.error;
      case DayState.none:
        return colorScheme.surfaceContainerHighest;
      case DayState.skipped:
        return colorScheme.surface;
    }
  }

  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case DayState.none:
        return l10n.dayStateNone;
      case DayState.done:
        return l10n.dayStateDone;
      case DayState.failed:
        return l10n.dayStateFailed;
      case DayState.skipped:
        return l10n.dayStateSkipped;
    }
  }
}

@HiveType(typeId: 2)
class DayModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DayState state;

  @HiveField(2)
  DateTime? date;

  @HiveField(3)
  String? note;

  DayModel({
    required this.id,
    this.state = DayState.none,
    this.date,
    this.note,
  });
}
