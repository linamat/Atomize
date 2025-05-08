// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayModelAdapter extends TypeAdapter<DayModel> {
  @override
  final int typeId = 2;

  @override
  DayModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayModel(
      id: fields[0] as String,
      state: fields[1] as DayState,
      date: fields[2] as DateTime?,
      note: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DayModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.state)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DayModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class DayStateAdapter extends TypeAdapter<DayState> {
  @override
  final int typeId = 1;

  @override
  DayState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DayState.none;
      case 1:
        return DayState.done;
      case 2:
        return DayState.failed;
      case 3:
        return DayState.skipped;
      default:
        return DayState.none;
    }
  }

  @override
  void write(BinaryWriter writer, DayState obj) {
    switch (obj) {
      case DayState.none:
        writer.writeByte(0);
        break;
      case DayState.done:
        writer.writeByte(1);
        break;
      case DayState.failed:
        writer.writeByte(2);
        break;
      case DayState.skipped:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DayStateAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
