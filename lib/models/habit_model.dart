import 'package:atomize/models/day_model.dart';
import 'package:hive/hive.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class HabitModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int daysCount;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  int order;

  @HiveField(5)
  bool isArchived;

  @HiveField(6)
  bool isExpanded;

  @HiveField(7)
  Map<String, DayModel> daysMap;

  @HiveField(8)
  String? description;

  HabitModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.order,
    this.isArchived = false,
    this.isExpanded = true,
    this.daysCount = 0,
    this.description,
    Map<String, DayModel>? daysMap,
  }) : daysMap = daysMap ?? {};

  int get doneDaysCount {
    return daysMap.values.where((day) => day.state == DayState.done).length;
  }
}
