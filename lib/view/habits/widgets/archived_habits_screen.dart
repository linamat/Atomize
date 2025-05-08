import 'package:atomize/view/habits/widgets/habit_progress_indicator.dart';
import 'package:atomize/models/habit_model.dart';
import 'package:atomize/view/theme/color_palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:atomize/controllers/habit_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ArchivedHabitsScreen extends StatelessWidget {
  const ArchivedHabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final archivedHabits = context.select<HabitController, List<HabitModel>>((s) => s.archivedHabits);
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.archivedHabits,
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
      body: archivedHabits.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.archive_outlined,
                    size: 20.w,
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    l10n.noArchivedHabits,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      l10n.archiveDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: archivedHabits.length,
              itemBuilder: (ctx, i) {
                final habit = archivedHabits[i];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2.h),
                    child: Dismissible(
                      key: ValueKey(habit.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(2.h),
                        ),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: const Icon(
                          Icons.unarchive,
                          color: ColorPalette.lightGrey,
                        ),
                      ),
                      onDismissed: (_) {
                        final service = context.read<HabitController>();
                        service.unarchiveHabit(habit.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.habitUnarchived(habit.name),
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            action: SnackBarAction(
                              label: l10n.undo,
                              onPressed: () => service.archiveHabit(habit.id),
                            ),
                          ),
                        );
                      },
                      child: _HabitTile(habit: habit),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _HabitTile extends StatelessWidget {
  final HabitModel habit;

  const _HabitTile({required this.habit});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.h),
      ),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: Row(
          children: [
            HabitProgressIndicator(habit: habit),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    l10n.goal(habit.daysCount),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  if (habit.description?.isNotEmpty == true)
                    Text(
                      habit.description!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.unarchive,
                size: 20.sp,
                color: colorScheme.primary,
              ),
              tooltip: l10n.unarchive,
              onPressed: () async {
                final service = context.read<HabitController>();
                await service.unarchiveHabit(habit.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.habitUnarchived(habit.name),
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      action: SnackBarAction(
                        label: l10n.undo,
                        onPressed: () => service.archiveHabit(habit.id),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
