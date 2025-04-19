import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/feed_items_models/file_feed_item.dart';
import 'package:grad_proj/models/feed_items_models/image_feed_item.dart';
import 'package:grad_proj/models/feed_items_models/message_feed_Item.dart';
import 'package:grad_proj/models/feed_items_models/schedule_create_item.dart';
import 'package:grad_proj/models/feed_items_models/schedule_delete_item.dart';
import 'package:grad_proj/models/feed_items_models/schedule_update_item.dart';
import 'package:grad_proj/models/feed_items_models/video_feed_item.dart';

enum feedItemsEnum {
  message,
  image,
  video,
  file,
  sceduleCreate,
  sceduleChange,
  sceduleDelete,
}

abstract class FeedItems {
  final String senderID;
  final Timestamp timestamp;
  final String type;
  final String senderName;
  final String chatID;

  FeedItems(
      {required this.senderID,
      required this.timestamp,
      required this.type,
      required this.chatID,
      required this.senderName});

  Map<String, dynamic> toMap();
  Widget present({required BuildContext context});

  static FeedItems getFeedItemFromSubClass(dynamic item) {
    switch (feedItemsEnum.values[item["type"]]) {
      case feedItemsEnum.message:
        return MessageFeedItem.fromMap(item);
      case feedItemsEnum.image:
        return ImageFeedItem.fromMap(item);
      case feedItemsEnum.video:
        return VideoFeedItem.fromMap(item);
      case feedItemsEnum.file:
        return FileFeedItem.fromMap(item);
      case feedItemsEnum.sceduleCreate:
        return SceduleCreateFeedItem.fromMap(item);
      case feedItemsEnum.sceduleChange:
        return ScheduleUpdateItem.fromMap(item);
      case feedItemsEnum.sceduleDelete:
        return ScheduleDeleteFeedItem.fromMap(item);

      // Add other cases here
      default:
        throw UnimplementedError("Unknown feed item type: ${item["type"]}");
    }
  }
}
