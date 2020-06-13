// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InviteAdapter extends TypeAdapter<Invite> {
  @override
  final typeId = 0;

  @override
  Invite read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Invite()
      ..description = fields[0] as String
      ..isAdmin = fields[1] as bool
      ..expiration = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Invite obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.isAdmin)
      ..writeByte(2)
      ..write(obj.expiration);
  }
}
