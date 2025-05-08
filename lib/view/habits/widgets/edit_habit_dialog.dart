import 'package:atomize/models/habit_model.dart';
import 'package:atomize/common/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EditHabitDialog extends StatefulWidget {
  const EditHabitDialog({
    required this.habit,
    required this.onUpdate,
    super.key,
  });

  final HabitModel habit;
  final void Function(HabitModel updatedHabit) onUpdate;

  @override
  State<EditHabitDialog> createState() => _EditHabitDialogState();
}

class _EditHabitDialogState extends State<EditHabitDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _daysController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _daysController = TextEditingController(text: widget.habit.daysCount.toString());
    _descriptionController = TextEditingController(text: widget.habit.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _daysController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.editHabit),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 3.w,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _decoration(l10n.habitName, l10n.habitName),
                validator: Validators.requiredField(
                  errorMessage: l10n.nameRequired,
                ),
              ),
              TextFormField(
                controller: _daysController,
                decoration: _decoration(l10n.habitGoal, l10n.habitGoal),
                keyboardType: TextInputType.number,
                validator: Validators.positiveInt(
                  errorMessage: l10n.goalMustBePositive,
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: _decoration(l10n.habitDescription, l10n.habitDescription),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(l10n.save),
        ),
      ],
    );
  }

  InputDecoration _decoration(String label, String hint) => InputDecoration(labelText: label, hintText: hint);

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    final name = _nameController.text.trim();
    final daysCount = int.parse(_daysController.text.trim());
    final description = _descriptionController.text.trim();

    widget.habit.name = name;
    widget.habit.daysCount = daysCount;
    widget.habit.description = description;

    widget.onUpdate(widget.habit);
    Navigator.of(context).pop();
  }
}
