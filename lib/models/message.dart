import "package:cloud_firestore/cloud_firestore.dart";

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
  factory Message.fromFirestore(DocumentSnapshot _snap) {
    var _data = _snap.data();
    return Message(
      messageContent: _snap["message"],
      senderID: _snap["senderID"],
      type: _snap["type"],
      timestamp: _snap["timestamp"],
      senderName: _snap["senderName"],
    );
  }
}
