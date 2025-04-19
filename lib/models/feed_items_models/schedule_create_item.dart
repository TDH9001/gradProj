import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/models/schedule.dart';

class SceduleCreateFeedItem extends FeedItems {
  final ScheduleItemClass scheduleItem;
  @override
  SceduleCreateFeedItem(
      {required super.senderID,
      required super.chatID,
      required this.scheduleItem,
      required super.timestamp,
      required super.senderName})
      : super(type: feedItemsEnum.sceduleCreate.name);
  factory SceduleCreateFeedItem.fromMap(Map<String, dynamic> map) {
    if (map.isNotEmpty) {
      return SceduleCreateFeedItem(
        scheduleItem: ScheduleItemClass.fromMap(map["sceduleItem"]),
        senderID: map["senderID"],
        timestamp: map["timestamp"],
        senderName: map["senderName"],
        chatID: map["chatID"],
      );
    } else {
      return SceduleCreateFeedItem(
        scheduleItem: ScheduleItemClass.fromMap(map["sceduleItem"]),
        senderID: "",
        timestamp: Timestamp.now(),
        senderName: "",
        chatID: "",
      );
    }
  }

  @override
  Widget present({required BuildContext context}) {
    return Center(
      child: Text("a new scedule made"),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        "senderID": senderID,
        "timestamp": timestamp,
        "senderName": senderName,
        "sceduleItem": scheduleItem.toMap(),
        "type": feedItemsEnum.values.byName(type).index,
        "chatID": chatID
      };
}
