import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grad_proj/models/feed_Items.dart';

class MessageFeedItem extends FeedItems {
  final String messageContent;
  MessageFeedItem({
    required super.senderID,
    required super.timestamp,
    required super.senderName,
    required super.chatID,
    required this.messageContent,
  }) : super(type: feedItemsEnum.message.name);

  factory MessageFeedItem.fromMap(Map<String, dynamic> map) {
    if (map.isNotEmpty) {
      return MessageFeedItem(
        senderID: map["senderID"],
        timestamp: map["timestamp"],
        senderName: map["senderName"],
        messageContent: map["messageContent"],
        chatID: map["chatID"],
      );
    } else {
      return MessageFeedItem(
        senderID: "",
        timestamp: Timestamp.now(),
        senderName: "",
        messageContent: "",
        chatID: "",
      );
    }
  }

  @override
  Map<String, dynamic> toMap() => {
        "senderID": senderID,
        "timestamp": timestamp,
        "senderName": senderName,
        "messageContent": messageContent,
        "type": feedItemsEnum.values.byName(type).index,
        "chatID": chatID
      };
  //to get the type corect > switch(map["type"]){case 0: message(map) nad so on
  //AKA > depeding on the type, it selects the right class and type is auto injected

  @override
  Widget present({required BuildContext context}) {
    // TODO: implement present
    throw UnimplementedError();
  }
}
