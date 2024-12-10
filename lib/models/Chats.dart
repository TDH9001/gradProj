import 'package:cloud_firestore/cloud_firestore.dart';

class ChatSnipits {
  final String id;
  final String Chatid;
  final String LastMessage;
  final String Sendername;
  final int unseenCount;
  final Timestamp timestamp;

  ChatSnipits(
      {required this.id,
      required this.Chatid,
      required this.LastMessage,
      required this.Sendername,
      required this.unseenCount,
      required this.timestamp});

  factory ChatSnipits.fromFirestore(DocumentSnapshot _snap) {
    var _data = _snap.data();
    return ChatSnipits(
        id: _snap.id,
        Chatid: _snap["chatID"],
        LastMessage: _snap["lastMessage"] ?? "",
        timestamp: _snap["timestamp"],
        unseenCount: _snap["unseenCount"],
        Sendername: _snap["senderName"]);
  }
}
