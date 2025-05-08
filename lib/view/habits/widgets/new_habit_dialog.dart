import 'package:atomize/models/habit_model.dart';
import 'package:atomize/common/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';

class NewHabitDialogContent extends StatefulWidget {
  const NewHabitDialogContent({required this.nextOrder, required this.onCreate, super.key});

  final int nextOrder;
  final void Function(HabitModel) onCreate;

  @override
  State<NewHabitDialogContent> createState() => NewHabitDialogContentState();
}

class NewHabitDialogContentState extends State<NewHabitDialogContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _daysController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _uuid = const Uuid();

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
      title: Text(l10n.newHabit),
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
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final name = _nameController.text.trim();
    final daysCount = int.parse(_daysController.text.trim());
    final description = _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim();

    final habit = HabitModel(
      id: _uuid.v4(),
      name: name,
      createdAt: DateTime.now(),
      order: widget.nextOrder,
      daysCount: daysCount,
      description: description,
    );

    widget.onCreate(habit);
    Navigator.of(context).pop();
  }
}
