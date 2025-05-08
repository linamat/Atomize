import 'package:atomize/models/day_model.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DayCell extends StatelessWidget {
  const DayCell({
    required this.state,
    required this.onTap,
    super.key,
  });

  final DayState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bgColor = state.color(context);
    final border = state == DayState.skipped ? Border.all(color: cs.outline, width: 0.5.w) : null;

    final content = () {
      if (state == DayState.skipped) {
        return Icon(Icons.skip_next, size: 3.w, color: cs.outline);
      }
    }();

    return Semantics(
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(2.w),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 8.w,
            height: 8.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(2.w),
              border: border,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
