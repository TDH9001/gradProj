// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatSnipitsAdapter extends TypeAdapter<ChatSnipits> {
  @override
  final int typeId = 0;

  @override
  ChatSnipits read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatSnipits(
      id: fields[0] as String,
      Chatid: fields[1] as String,
      LastMessage: fields[2] as String,
      Sendername: fields[3] as String,
      unseenCount: fields[4] as int,
      timestamp: fields[5] as DateTime,
      adminId: (fields[6] as List).cast<String>(),
      type: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChatSnipits obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.Chatid)
      ..writeByte(2)
      ..write(obj.LastMessage)
      ..writeByte(3)
      ..write(obj.Sendername)
      ..writeByte(4)
      ..write(obj.unseenCount)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.adminId)
      ..writeByte(7)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatSnipitsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatDataAdapter extends TypeAdapter<ChatData> {
  @override
  final int typeId = 1;

  @override
  ChatData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatData(
      Chatid: fields[0] as String,
      members: (fields[1] as List).cast<String>(),
      messages: (fields[3] as List).cast<Message>(),
      owners: (fields[2] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.Chatid)
      ..writeByte(1)
      ..write(obj.members)
      ..writeByte(2)
      ..write(obj.owners)
      ..writeByte(3)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
