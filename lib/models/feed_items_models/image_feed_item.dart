import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grad_proj/models/feed_Items.dart';

class ImageFeedItem extends FeedItems {
  final String messageContent;
  ImageFeedItem(
      {required super.senderID,
      required super.timestamp,
      required super.senderName,
      required this.messageContent})
      : super(type: feedItemsEnum.image.name);
  factory ImageFeedItem.fromMap(Map<String, dynamic> map) {
    if (map.isNotEmpty) {
      return ImageFeedItem(
        senderID: map["senderID"],
        timestamp: map["timestamp"],
        senderName: map["senderName"],
        messageContent: map["messageContent"],
      );
    } else {
      return ImageFeedItem(
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
        "type": feedItemsEnum.values.byName(type).index
      };
}
