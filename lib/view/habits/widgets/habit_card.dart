import 'package:atomize/view/habits/widgets/day_cell.dart';
import 'package:atomize/view/habits/widgets/day_state_change_dialog.dart';
import 'package:atomize/view/habits/widgets/edit_habit_dialog.dart';
import 'package:atomize/view/habits/widgets/habit_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:atomize/controllers/habit_controller.dart';
import 'package:atomize/models/habit_model.dart';
import 'package:atomize/common/enums/habit_menu_option.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HabitCard extends StatelessWidget {
  const HabitCard({
    required this.habit,
    required this.onUpdate,
    super.key,
  });

  final HabitModel habit;
  final ValueChanged<HabitModel> onUpdate;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
      child: InkWell(
        borderRadius: BorderRadius.circular(3.w),
        onTap: () => _toggleExpanded(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderRow(habit: habit, onUpdate: onUpdate),
              if (habit.isExpanded) ...[
                SizedBox(height: 2.h),
                _DaysGrid(habit: habit, onUpdate: onUpdate),
                if (habit.description != null && habit.description!.isNotEmpty) ...[
                  SizedBox(height: 1.h),
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: .3),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: Text(
                      habit.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14.sp,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _toggleExpanded(BuildContext context) async {
    final service = context.read<HabitController>();
    await service.toggleHabitExpanded(habit.id);
    onUpdate(habit);
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.habit,
    required this.onUpdate,
  });

  final HabitModel habit;
  final ValueChanged<HabitModel> onUpdate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        _ProgressOrDone(habit: habit),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                habit.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                AppLocalizations.of(context)!.goal(habit.daysCount),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        _OptionsMenu(habit: habit, onUpdate: onUpdate),
      ],
    );
  }
}

class _ProgressOrDone extends StatelessWidget {
  const _ProgressOrDone({required this.habit});

  final HabitModel habit;

  @override
  Widget build(BuildContext context) {
    final progress = habit.doneDaysCount / habit.daysCount;
    if (progress >= 1.0) {
      return Container(
        width: 8.w,
        height: 8.w,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          Icons.check,
          size: 5.w,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      );
    }
    return HabitProgressIndicator(habit: habit);
  }
}

class _DaysGrid extends StatelessWidget {
  final HabitModel habit;
  final ValueChanged<HabitModel> onUpdate;

  const _DaysGrid({
    Key? key,
    required this.habit,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final days = habit.daysMap.values.toList();

    return GridView.count(
      crossAxisCount: 7,
      crossAxisSpacing: 2.5.w,
      mainAxisSpacing: 2.5.w,
      childAspectRatio: 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(days.length, (i) {
        final day = days[i];
        return Hero(
          tag: 'day-${habit.id}-${day.id}',
          child: DayCell(
            state: day.state,
            onTap: () => _onCellTap(context, day.id),
          ),
        );
      }),
    );
  }

  void _onCellTap(BuildContext context, String dayId) {
    final service = context.read<HabitController>();
    showDialog(
      context: context,
      builder: (_) => DayStateSelector(
        onSelected: (newState) async {
          await service.updateDayState(
            habitId: habit.id,
            dayId: dayId,
            state: newState,
          );
          onUpdate(habit);
        },
      ),
    );
  }
}

class _OptionsMenu extends StatelessWidget {
  const _OptionsMenu({
    Key? key,
    required this.habit,
    required this.onUpdate,
  }) : super(key: key);

  final HabitModel habit;
  final ValueChanged<HabitModel> onUpdate;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<HabitMenuOption>(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
      onSelected: (opt) => _onSelected(context, opt),
      itemBuilder: (context) => HabitMenuOption.values
          .map((opt) => PopupMenuItem(
                value: opt,
                child: Row(
                  children: [
                    Icon(
                      _getIconForOption(opt),
                      size: 5.w,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 2.w),
                    Text(opt.name(context)),
                  ],
                ),
              ))
          .toList(),
    );
  }

  IconData _getIconForOption(HabitMenuOption option) {
    switch (option) {
      case HabitMenuOption.edit:
        return Icons.edit;
      case HabitMenuOption.archive:
        return Icons.archive;
      case HabitMenuOption.delete:
        return Icons.delete;
    }
  }

  void _onSelected(BuildContext context, HabitMenuOption opt) {
    switch (opt) {
      case HabitMenuOption.edit:
        _showEditDialog(context);
        break;
      case HabitMenuOption.archive:
        _archive(context);
        break;
      case HabitMenuOption.delete:
        _confirmDelete(context);
        break;
    }
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => EditHabitDialog(habit: habit, onUpdate: onUpdate),
    );
  }

  void _archive(BuildContext context) async {
    final service = context.read<HabitController>();
    await service.archiveHabit(habit.id, value: true);
    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.habitArchived),
        action: SnackBarAction(
          label: l10n.undo,
          onPressed: () => service.archiveHabit(habit.id, value: false),
        ),
      ),
    );
    onUpdate(habit);
  }

  void _confirmDelete(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteHabit),
        content: Text(l10n.deleteHabitConfirmation),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () async {
              Navigator.pop(context);
              final service = context.read<HabitController>();
              await service.deleteHabit(habit.id);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.habitDeleted),
                  action: SnackBarAction(
                    label: l10n.undo,
                    onPressed: () => service.addHabit(habit),
                  ),
                ),
              );
              onUpdate(habit);
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
