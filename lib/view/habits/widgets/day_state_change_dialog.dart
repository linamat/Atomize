import 'package:atomize/models/day_model.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DayStateSelector extends StatelessWidget {
  const DayStateSelector({
    required this.onSelected,
    super.key,
  });

  final Function(DayState) onSelected;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Select Day State"),
      children: DayState.values.map((state) {
        return SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
            onSelected(state);
          },
          child: Row(
            children: [
              CircleAvatar(backgroundColor: state.color(context), radius: 2.w),
              SizedBox(width: 3.w),
              Text(state.label(context)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
