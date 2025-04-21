import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grad_proj/models/feed_Items.dart';

class VideoFeedItem extends FeedItems {
  final String messagecontent;
  VideoFeedItem(
      {required super.senderID,
      required super.chatID,
      required super.timestamp,
      required this.messagecontent,
      required super.senderName})
      : super(type: feedItemsEnum.video.name);
  factory VideoFeedItem.fromMap(Map<String, dynamic> map) {
    if (map.isNotEmpty) {
      return VideoFeedItem(
        senderID: map["senderID"],
        timestamp: map["timestamp"],
        senderName: map["senderName"],
        messagecontent: map["messageContent"],
        chatID: map["chatID"],
      );
    } else {
      return VideoFeedItem(
        senderID: "",
        timestamp: Timestamp.now(),
        senderName: "",
        messagecontent: "",
        chatID: "",
      );
    }
  }

  @override
  Widget present({required BuildContext context}) {
    // TODO: implement present
    return Text("Message");
  }

  @override
  Map<String, dynamic> toMap() => {
        "senderID": senderID,
        "timestamp": timestamp,
        "senderName": senderName,
        "messageContent": messagecontent,
        "type": feedItemsEnum.values.byName(type).index,
        "chatID": chatID
      };
}
