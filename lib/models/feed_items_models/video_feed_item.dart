import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grad_proj/models/feed_Items.dart';

class VideoFeedItem extends FeedItems {
  final String messagecontent;
  VideoFeedItem(
      {required super.senderID,
      required super.timestamp,
      required this.messagecontent,
      required super.senderName})
      : super(type: feedItems.video.name);

  @override
  FeedItems fromMap(Map<String, dynamic> map) {
    if (map.isNotEmpty) {
      return VideoFeedItem(
        senderID: map["senderID"],
        timestamp: map["timestamp"],
        senderName: map["senderName"],
        messagecontent: map["messageContent"],
      );
    } else {
      return VideoFeedItem(
        senderID: "",
        timestamp: Timestamp.now(),
        senderName: "",
        messagecontent: "",
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
        "messageContent": messagecontent,
        "type": feedItems.values.byName(type).index
      };
}
