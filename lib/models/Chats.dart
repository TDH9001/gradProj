import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_proj/services/DB-service.dart';
import '../models/message.dart';

class ChatSnipits {
  final String id;
  final String chatId;
  final String lastMessage;
  final String senderName;
  final int unseenCount;
  final Timestamp timestamp;
  final List<String> adminId;
  final String type;

  ChatSnipits(
      {required this.id,
      required this.chatId,
      required this.lastMessage,
      required this.senderName,
      required this.unseenCount,
      required this.timestamp,
      required this.adminId,
      required this.type});

  factory ChatSnipits.fromFirestore(DocumentSnapshot _snap) {
    var _data = _snap.data();
    return ChatSnipits(
      id: _snap.id,
      chatId: _snap["chatID"],
      lastMessage: _snap["lastMessage"] ?? "",
      timestamp: _snap["timestamp"],
      unseenCount: _snap["unseenCount"],
      senderName: _snap["senderName"],
      type: _snap["type"] is int
          ? MessageType.values[_snap["type"]].name
          : _snap["type"],
      adminId:
          (_snap["admins"] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }
}

class ChatData {
  final String chatid;
  final List<String> members;
  final List<String> owners;
  final List<Message> messages;
  ChatData(
      {required this.chatid,
      required this.members,
      required this.messages,
      required this.owners});
  factory ChatData.fromFirestore(DocumentSnapshot _snap) {
    var _data = _snap.data();

    List<dynamic> rawMessages = _snap["messages"] ?? [];

    List<Message> MessageDataCurr = rawMessages.map((message) {
      return Message(
        senderID: message["senderID"] ?? "",
        senderName: message["senderName"] ?? "",
        messageContent: message["message"] ?? "",
        timestamp: message["timestamp"],
        type: message["type"] is int
            ? MessageType.values[message["type"]].name
            : message["type"] ?? "text",
      );
    }).toList();
    //messageType

    if (!MessageDataCurr.isEmpty || MessageDataCurr != null) {
      MessageDataCurr = MessageDataCurr.map((_m) {
        //handle files being sent
        return Message(
            senderID: _m.senderID,
            senderName: _m.senderName,
            messageContent: _m.messageContent,
            timestamp: _m.timestamp,
            type: _m.type);
      }).toList();
    } else {
      MessageDataCurr = <Message>[
        Message(
            messageContent: "there is no chat data here",
            senderID: "",
            senderName: "",
            timestamp: Timestamp.now(),
            type: "text")
      ];
    }

    return ChatData(
      chatid: _snap.id,
      members:
          (_snap["members"] as List<dynamic>).map((e) => e.toString()).toList(),
      owners:
          (_snap["ownerID"] as List<dynamic>).map((e) => e.toString()).toList(),
      messages: MessageDataCurr,
    );
  }
}
