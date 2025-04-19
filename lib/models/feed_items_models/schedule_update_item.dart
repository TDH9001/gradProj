import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/models/schedule.dart';

class ScheduleUpdateItem extends FeedItems {
  final ScheduleItemClass newScheduleItem;
  final ScheduleItemClass oldScheduleItem;
  ScheduleUpdateItem(
      {required super.senderID,
      required super.timestamp,
      required this.newScheduleItem,
      required this.oldScheduleItem,
      required super.senderName})
      : super(type: feedItems.sceduleChange.name);
      factory ScheduleUpdateItem.fromMap(Map<String, dynamic> map) {
    if (map.isNotEmpty) {
      return ScheduleUpdateItem(
        newScheduleItem: ScheduleItemClass.fromMap(map["newScheduleItem"]),
        oldScheduleItem: ScheduleItemClass.fromMap(map["oldScheduleItem"]),
        senderID: map["senderID"],
        timestamp: map["timestamp"],
        senderName: map["senderName"],
      );
    } else {
      return ScheduleUpdateItem(
        newScheduleItem: ScheduleItemClass.fromMap(map["newScheduleItem"]),
        oldScheduleItem: ScheduleItemClass.fromMap(map["oldScheduleItem"]),
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
        "oldScheduleItem": oldScheduleItem.toMap(),
        "newScheduleItem": newScheduleItem.toMap(),
        "type": feedItems.values.byName(type).index
      };
}
