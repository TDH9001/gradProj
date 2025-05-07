import "package:cloud_firestore/cloud_firestore.dart";
import "package:grad_proj/services/DB-service.dart";

// enum messageType { Text, image, file }

class Message {
  final String messageContent;
  final String senderID;
  final Timestamp timestamp;
  final String type;
  final String senderName;
  Message(
      {required this.senderID,
      required this.messageContent,
      required this.timestamp,
      required this.type,
      required this.senderName});
  factory Message.fromFireBase(Map<String, dynamic> _snap) {
    // used when dealing withFireabse > as they can translate timemstamps
    return Message(
      messageContent: _snap["message"],
      senderID: _snap["senderID"],
      type: _snap["type"] is int
          ? MessageType.values[_snap["type"]].name
          : _snap["type"],
      timestamp: _snap["timestamp"],
      senderName: _snap["senderName"],
    );
  }
  factory Message.fromJson(Map<String, dynamic> json) {
    //usd when dealing with hive as hey can nto deal with timestamp
    return Message(
      messageContent: json["message"],
      senderID: json["senderID"],
      type: json["type"] is int
          ? MessageType.values[json["type"]].name
          : json["type"],
      timestamp: json["timestamp"] is DateTime
          ? Timestamp.fromDate(json["timestamp"])
          : json["timestamp"],
      senderName: json["senderName"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "senderID": senderID,
      "timestamp": timestamp.toDate(),
      "senderName": senderName,
      "message": messageContent,
      "type": MessageType.values.byName(type).index,
    };
  }

  @override
  String toString() {
    return 'Message{messageContent: $messageContent, senderID: $senderID, timestamp: $timestamp, type: $type, senderName: $senderName}';
  }
}
