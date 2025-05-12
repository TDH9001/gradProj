import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grad_proj/services/DB-service.dart';
import '../models/message.dart';
import 'dart:developer' as dev;

enum ChatAccesabilityEnum { admin_only, allow_Leaders, allow_All }

class ChatSnipits {
  final String id;
  final List<String> leaders;
  final String chatId;
  final String lastMessage;
  final String senderName;
  final int unseenCount;
  final Timestamp timestamp;
  final List<String> adminId;
  final String type;
  final String chatAccesability;

  ChatSnipits(
      {required this.id,
      required this.leaders,
      required this.chatAccesability,
      required this.chatId,
      required this.lastMessage,
      required this.senderName,
      required this.unseenCount,
      required this.timestamp,
      required this.adminId,
      required this.type});

  factory ChatSnipits.fromFirestore(DocumentSnapshot _snap) {
    return ChatSnipits(
      leaders:
          (_snap["leaders"] as List<dynamic>).map((e) => e.toString()).toList(),
      chatAccesability:
          ChatAccesabilityEnum.values[_snap["ChatAccesability"]].name,
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
  final List<String> leaders;
  final List<String> members;
  final List<String> owners;
  final List<Message> messages;
  final String chatAccesability;

  ChatData(
      {required this.chatid,
      required this.leaders,
      required this.chatAccesability,
      required this.members,
      required this.messages,
      required this.owners});
  factory ChatData.fromFirestore(DocumentSnapshot _snap) {
    var _data = _snap.data() as Map<String, dynamic>?;
    if (_data == null) {
      dev.log("message document is empoty");
      return ChatData(
          chatAccesability: ChatAccesabilityEnum.admin_only.name,
          chatid: _snap.id,
          leaders: [],
          members: [],
          messages: [],
          owners: []);
    }

    final bool isImportant = _data!.containsKey("isImportant");

    List<dynamic> rawMessages = _snap["messages"] ?? [];

    List<Message> MessageDataCurr = rawMessages.map((message) {
      final dt = message as Map<String, dynamic>;
      // return Message.fromJson(message);

      return Message(
        isImportant:
            dt.containsKey("IsImportant") ? message["IsImportant"] : false,
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
            isImportant: _m.isImportant,
            senderID: _m.senderID,
            senderName: _m.senderName,
            messageContent: _m.messageContent,
            timestamp: _m.timestamp,
            type: _m.type);
      }).toList();
    } else {
      MessageDataCurr = <Message>[
        Message(
            isImportant: false,
            messageContent: "there is no chat data here",
            senderID: "",
            senderName: "",
            timestamp: Timestamp.now(),
            type: "text")
      ];
    }

    return ChatData(
      leaders:
          (_snap["leaders"] as List<dynamic>).map((e) => e.toString()).toList(),
      chatAccesability: _snap["ChatAccesability"] is int
          ? ChatAccesabilityEnum.values[_snap["ChatAccesability"]].name ??
              ChatAccesabilityEnum.admin_only.name
          : _snap["CahtAccesability"],
      chatid: _snap.id,
      members:
          (_snap["members"] as List<dynamic>).map((e) => e.toString()).toList(),
      owners:
          (_snap["ownerID"] as List<dynamic>).map((e) => e.toString()).toList(),
      messages: MessageDataCurr,
    );
  }
}
