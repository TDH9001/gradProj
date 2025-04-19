import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/models/schedule.dart';

class ScheduleUpdateItem extends FeedItems {
  final ScheduleItemClass newScheduleItem;
  final ScheduleItemClass oldScheduleItem;
  ScheduleUpdateItem(
      {required super.senderID,
      required super.timestamp,
      required super.chatID,
      required this.newScheduleItem,
      required this.oldScheduleItem,
      required super.senderName})
      : super(type: feedItemsEnum.sceduleChange.name);
  factory ScheduleUpdateItem.fromMap(Map<String, dynamic> map) {
    if (map.isNotEmpty) {
      return ScheduleUpdateItem(
        newScheduleItem: ScheduleItemClass.fromMap(map["newScheduleItem"]),
        oldScheduleItem: ScheduleItemClass.fromMap(map["oldScheduleItem"]),
        senderID: map["senderID"],
        timestamp: map["timestamp"],
        senderName: map["senderName"],
        chatID: map["chatID"],
      );
    } else {
      return ScheduleUpdateItem(
        newScheduleItem: ScheduleItemClass.fromMap(map["newScheduleItem"]),
        oldScheduleItem: ScheduleItemClass.fromMap(map["oldScheduleItem"]),
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
      child: Text("a scedule updated"),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        "senderID": senderID,
        "timestamp": timestamp,
        "senderName": senderName,
        "oldScheduleItem": oldScheduleItem.toMap(),
        "newScheduleItem": newScheduleItem.toMap(),
        "type": feedItemsEnum.values.byName(type).index,
        "chatID":chatID
      };
}
