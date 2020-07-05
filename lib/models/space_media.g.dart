// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_media.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpaceMediaAdapter extends TypeAdapter<SpaceMedia> {
  @override
  final int typeId = 0;

  @override
  SpaceMedia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpaceMedia(
      date: fields[0] as DateTime,
      type: fields[1] as String,
      url: fields[2] as String,
      description: fields[4] as String,
      title: fields[5] as String,
      credits: fields[6] as String,
      hdImageUrl: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SpaceMedia obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.hdImageUrl)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.title)
      ..writeByte(6)
      ..write(obj.credits);
  }
}
