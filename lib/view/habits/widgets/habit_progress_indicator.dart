import 'package:atomize/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HabitProgressIndicator extends StatelessWidget {
  const HabitProgressIndicator({
    required this.habit,
    super.key,
  });

  final HabitModel habit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = habit.doneDaysCount / habit.daysCount;
    final percentage = (progress * 100).toInt();

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 10.w,
          height: 10.w,
          child: CircularProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            color: theme.colorScheme.primary,
            strokeWidth: 1.w,
          ),
        ),
        Text(
          '$percentage%',
          style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
      ],
    );
  }
}
