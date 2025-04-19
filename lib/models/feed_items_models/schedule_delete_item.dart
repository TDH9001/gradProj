import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/models/schedule.dart';

class ScheduleDeleteFeedItem extends FeedItems {
  final ScheduleItemClass scheduleItem;
  ScheduleDeleteFeedItem(
      {required super.senderID,
      required super.timestamp,
      required this.scheduleItem,
      required super.senderName})
      : super(type: feedItemsEnum.sceduleDelete.name);
  factory ScheduleDeleteFeedItem.fromMap(Map<String, dynamic> map) {
    if (map.isNotEmpty) {
      return ScheduleDeleteFeedItem(
        scheduleItem: ScheduleItemClass.fromMap(map["sceduleItem"]),
        senderID: map["senderID"],
        timestamp: map["timestamp"],
        senderName: map["senderName"],
      );
    } else {
      return ScheduleDeleteFeedItem(
        scheduleItem: ScheduleItemClass.fromMap(map["sceduleItem"]),
        senderID: "",
        timestamp: Timestamp.now(),
        senderName: "",
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
        "sceduleItem": scheduleItem.toMap(),
        "type": feedItemsEnum.values.byName(type).index
      };
}
