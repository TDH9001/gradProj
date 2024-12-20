import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class ChatSnipits {
  final String id;
  final String Chatid;
  final String LastMessage;
  final String Sendername;
  final int unseenCount;
  final Timestamp timestamp;
  final List<String> adminId;

  ChatSnipits(
      {required this.id,
      required this.Chatid,
      required this.LastMessage,
      required this.Sendername,
      required this.unseenCount,
      required this.timestamp,
      required this.adminId});

  factory ChatSnipits.fromFirestore(DocumentSnapshot _snap) {
    var _data = _snap.data();
    return ChatSnipits(
      id: _snap.id,
      Chatid: _snap["chatID"],
      LastMessage: _snap["lastMessage"] ?? "",
      timestamp: _snap["timestamp"],
      unseenCount: _snap["unseenCount"],
      Sendername: _snap["senderName"],
      adminId:
          (_snap["admins"] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }
}

class ChatData {
  final String Chatid;
  final List<String> members;
  final List<String> owners;
  final List<Message> messages;
  ChatData(
      {required this.Chatid,
      required this.members,
      required this.messages,
      required this.owners});
  factory ChatData.fromFirestore(DocumentSnapshot _snap) {
    var _data = _snap.data();

    List<dynamic> rawMessages = _snap["messages"] ?? [];

    List<Message> MessageDataCurr = rawMessages.map((message) {
      messageType ms =
          message["type"] == "text" ? messageType.Text : messageType.image;
      // messageType ms = messageType.Text;
      // switch (message["type"]) {
      //   case "text":
      //     ms = messageType.Text;
      //     break;
      //   case "image":
      //     ms = messageType.image;
      //     break;
      //   case "file":
      //     ms = messageType.file;
      //     break;
      //   default:
      // }

      return Message(
        senderID: message["senderID"] ?? "",
        senderName: message["senderName"] ?? "",
        messageContent: message["message"] ?? "",
        timestamp: message["timestamp"],
        type: ms,
      );
    }).toList();
    //messageType

    if (!MessageDataCurr.isEmpty || MessageDataCurr != null) {
      MessageDataCurr = MessageDataCurr.map((_m) {
        var MessageType =
            _m.type == "text" ? messageType.Text : messageType.image;
        //handle files being sent
        return Message(
            senderID: _m.senderID,
            senderName: _m.senderName,
            messageContent: _m.messageContent,
            timestamp: _m.timestamp,
            type: MessageType);
      }).toList();
    } else {
      MessageDataCurr = <Message>[
        Message(
            messageContent: "there is no chat data here",
            senderID: "",
            senderName: "",
            timestamp: Timestamp.now(),
            type: messageType.Text)
      ];
    }

    return ChatData(
      Chatid: _snap.id,
      members:
          (_snap["members"] as List<dynamic>).map((e) => e.toString()).toList(),
      owners:
          (_snap["ownerID"] as List<dynamic>).map((e) => e.toString()).toList(),
      messages: MessageDataCurr,
    );
  }
}
