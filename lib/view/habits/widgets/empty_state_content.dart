import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyStateContent extends StatelessWidget {
  const EmptyStateContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_task,
              size: 20.w,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            SizedBox(height: 2.w),
            Text(l10n.noHabitsYet, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              l10n.createFirstHabit,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
