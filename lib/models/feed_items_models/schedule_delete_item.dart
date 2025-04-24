import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/theme/dark_theme_colors.dart';
import 'package:grad_proj/theme/light_theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:grad_proj/widgets/updated_scedule_item.dart';

class ScheduleDeleteFeedItem extends FeedItems {
  final ScheduleItemClass scheduleItem;
  ScheduleDeleteFeedItem(
      {required super.senderID,
      required super.timestamp,
      required super.chatID,
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
        chatID: map["chatID"],
      );
    } else {
      return ScheduleDeleteFeedItem(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Schedule Deleted",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.red,
            ),
          ),
        ),
        updatedSceduleItem(scheduleItem),
      ],
    );
  }

  Widget _buildScheduleDetailRow(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? DarkThemeColors.textcolor : LightTheme.textcolor;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: textColor
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: textColor,
                decoration: TextDecoration.lineThrough,
                decorationColor: Colors.red.shade300,
              ),
            ),
          ),
        ],
      ),
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
