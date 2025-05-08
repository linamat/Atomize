import 'package:atomize/view/settings/settings_screen.dart';
import 'package:atomize/view/habits/widgets/archived_habits_screen.dart';
import 'package:atomize/view/habits/widgets/empty_state_content.dart';
import 'package:atomize/view/habits/widgets/habit_card.dart';
import 'package:atomize/view/habits/widgets/new_habit_dialog.dart';
import 'package:atomize/models/habit_model.dart';
import 'package:atomize/controllers/habit_controller.dart';
import 'package:atomize/view/theme/color_palette.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitController = Provider.of<HabitController>(context);
    final habits = habitController.habits;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.habitTracker),
        actions: [
          IconButton(
            icon: const Icon(Icons.archive),
            tooltip: l10n.archivedHabits,
            onPressed: () => _onArchiveIconTap(context),
          ),
          IconButton(
            onPressed: () => _onSettingIconTap(context),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: habits.isEmpty
          ? const EmptyStateContent()
          : ReorderableListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
              itemCount: habits.length,
              proxyDecorator: (child, index, animation) => child,
              onReorder: (oldIndex, newIndex) async {
                if (newIndex > oldIndex) newIndex--;

                await habitController.reorderHabits(oldIndex, newIndex);
              },
              itemBuilder: (context, index) {
                final habit = habits[index];
                return Padding(
                  key: ValueKey(habit.id),
                  padding: EdgeInsets.only(bottom: 1.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(3.w)),
                    child: Dismissible(
                      key: ValueKey('${habit.id}-swipe'),
                      background: _buildSwipeBackground(
                        alignment: Alignment.centerLeft,
                        icon: Icons.archive,
                        color: colorScheme.primaryContainer,
                      ),
                      secondaryBackground: _buildSwipeBackground(
                        alignment: Alignment.centerRight,
                        icon: Icons.delete,
                        color: colorScheme.errorContainer,
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          await habitController.archiveHabit(habit.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(AppLocalizations.of(context)!.habitArchived)),
                            );
                          }
                          return true;
                        } else {
                          _confirmDelete(context, habitController, habit);
                          return false;
                        }
                      },
                      child: HabitCard(
                        habit: habit,
                        onUpdate: (updatedHabit) async {
                          await habitController.updateHabit(updatedHabit);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddNewHabit(
          context,
          habitController: habitController,
          nextOrder: habits.length,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSwipeBackground({
    required Alignment alignment,
    required IconData icon,
    required Color color,
  }) =>
      Container(
        alignment: alignment,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(3.w)),
        ),
        child: Icon(icon, color: ColorPalette.lightGrey),
      );

  void _onArchiveIconTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ArchivedHabitsScreen()),
    );
  }

  void _onSettingIconTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  void _onAddNewHabit(
    BuildContext context, {
    required HabitController habitController,
    required int nextOrder,
  }) {
    showDialog(
      context: context,
      builder: (_) => NewHabitDialogContent(
        nextOrder: nextOrder,
        onCreate: (habit) {
          habitController.addHabit(habit);
        },
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    HabitController habitController,
    HabitModel habit,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteHabit),
        content: Text(l10n.deleteHabitConfirmation),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await habitController.deleteHabit(habit.id);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.habitDeleted)));
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
