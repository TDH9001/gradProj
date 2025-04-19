import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grad_proj/models/feed_Items.dart';

class FileFeedItem extends FeedItems {
  final String messageContent;
  FileFeedItem(
      {required super.senderID,
      required super.timestamp,
      required this.messageContent,
      required super.senderName})
      : super(type: feedItems.file.name);

  factory FileFeedItem.fromMap(Map<String, dynamic> map) {
    if (map.isNotEmpty) {
      return FileFeedItem(
        senderID: map["senderID"],
        timestamp: map["timestamp"],
        senderName: map["senderName"],
        messageContent: map["messageContent"],
      );
    } else {
      return FileFeedItem(
        senderID: "",
        timestamp: Timestamp.now(),
        senderName: "",
        messageContent: "",
      );
    }
  }



  @override
  Widget present({required BuildContext context}) {
    // TODO: implement present
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toMap() => {
        "senderID": senderID,
        "timestamp": timestamp,
        "senderName": senderName,
        "messageContent": messageContent,
        "type": feedItems.values.byName(type).index
      };
}
