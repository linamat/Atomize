import 'package:atomize/models/day_model.dart';
import 'package:atomize/models/habit_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class HabitController extends ChangeNotifier {
  static const String _boxName = 'habits';

  late Box<HabitModel> _habitsBox;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  final _uuid = const Uuid();

  Future<void> init() async {
    _habitsBox = await Hive.openBox<HabitModel>(_boxName);
    _isInitialized = true;
    notifyListeners();
  }

  List<HabitModel> get habits {
    if (!_isInitialized) return [];

    final habitList = _habitsBox.values.where((habit) => !habit.isArchived).toList();
    habitList.sort((a, b) => a.order.compareTo(b.order));

    return habitList;
  }

  List<HabitModel> get archivedHabits {
    if (!_isInitialized) return [];

    final habitList = _habitsBox.values.where((habit) => habit.isArchived).toList();
    habitList.sort((a, b) => a.order.compareTo(b.order));

    return habitList;
  }

  Future<void> reorderHabits(int oldIndex, int newIndex) async {
    if (!_isInitialized) return;
    final list = _habitsBox.values.where((h) => !h.isArchived).toList()..sort((a, b) => a.order.compareTo(b.order));

    if (newIndex > oldIndex) newIndex--;

    final moved = list.removeAt(oldIndex);
    list.insert(newIndex, moved);

    for (var i = 0; i < list.length; i++) {
      final h = list[i];
      h.order = i;
      await h.save();
    }

    notifyListeners();
  }

  Future<void> addHabit(HabitModel habit) async {
    habit.daysMap = _createDaysMap(
      count: habit.daysCount,
      startDate: DateTime.now(),
    );

    await _habitsBox.put(habit.id, habit);
    notifyListeners();
  }

  Future<void> updateHabit(HabitModel habit) async {
    final existingHabit = _habitsBox.get(habit.id);

    if (existingHabit == null) {
      await addHabit(habit);
      return;
    }

    habit.daysMap = _updatedDaysMap(
      previousMap: existingHabit.daysMap,
      startDate: existingHabit.createdAt,
      newCount: habit.daysCount,
    );

    await _habitsBox.put(habit.id, habit);
    notifyListeners();
  }

  Future<void> deleteHabit(String id) async {
    await _habitsBox.delete(id);
    notifyListeners();
  }

  Future<void> clearAllHabits() async {
    await _habitsBox.clear();
    notifyListeners();
  }

  Future<void> toggleHabitExpanded(String id) async {
    final habit = _habitsBox.get(id);

    if (habit == null) return;

    habit.isExpanded = !habit.isExpanded;
    await _habitsBox.put(id, habit);

    notifyListeners();
  }

  Future<void> archiveHabit(String id, {bool value = true}) async {
    final habit = _habitsBox.get(id);

    if (habit == null) return;

    habit.isArchived = value;
    await _habitsBox.put(id, habit);

    notifyListeners();
  }

  Future<void> unarchiveHabit(String id) => archiveHabit(id, value: false);

  Future<void> updateDayState({
    required String habitId,
    required String dayId,
    required DayState state,
  }) async {
    final habit = _habitsBox.get(habitId);

    if (habit == null) return;

    final day = habit.daysMap[dayId];

    if (day == null) return;

    day.state = state;
    await _habitsBox.put(habitId, habit);
    notifyListeners();
  }

  Map<String, DayModel> _createDaysMap({
    required int count,
    required DateTime startDate,
  }) {
    final map = <String, DayModel>{};

    for (var i = 0; i < count; i++) {
      final id = _uuid.v4();
      final date = startDate.add(Duration(days: i));

      map[id] = DayModel(id: id, date: date);
    }

    return map;
  }

  Map<String, DayModel> _updatedDaysMap({
    required Map<String, DayModel> previousMap,
    required DateTime startDate,
    required int newCount,
  }) {
    final result = Map<String, DayModel>.from(previousMap);
    final oldCount = previousMap.length;

    if (newCount > oldCount) {
      final toAdd = newCount - oldCount;

      for (var offset = 0; offset < toAdd; offset++) {
        final id = _uuid.v4();
        final date = startDate.add(Duration(days: oldCount + offset));

        result[id] = DayModel(id: id, date: date);
      }
    } else if (newCount < oldCount) {
      result.removeWhere((key, day) {
        final index = day.date!.difference(startDate).inDays;

        return index >= newCount;
      });
    }

    return result;
  }
}
