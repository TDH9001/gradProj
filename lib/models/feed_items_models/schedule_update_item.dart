import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/theme/dark_theme_colors.dart';
import 'package:grad_proj/theme/light_theme.dart';
import 'package:grad_proj/widgets/updated_scedule_item.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Schedule Updated",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            "Old Schedule",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        updatedSceduleItem(oldScheduleItem),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            "New Schedule",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        updatedSceduleItem(newScheduleItem),
      ],
    );
  }

  Widget _buildScheduleComparisonRow(BuildContext context, String label, String oldValue, String newValue) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? DarkThemeColors.primary : LightTheme.primary;
    final secondaryColor = isDark ? DarkThemeColors.secondary : LightTheme.secondary;
    final textColor = isDark ? DarkThemeColors.textcolor : LightTheme.textcolor;
    
    bool changed = oldValue != newValue;
    
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
            child: changed
                ? Row(
                    children: [
                      Expanded(
                        child: Text(
                          oldValue,
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: secondaryColor,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 16, color: textColor.withOpacity(0.6)),
                      Expanded(
                        child: Text(
                          newValue,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  )
                : Text(newValue, style: TextStyle(color: textColor)),
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
        "oldScheduleItem": oldScheduleItem.toMap(),
        "newScheduleItem": newScheduleItem.toMap(),
        "type": feedItemsEnum.values.byName(type).index,
        "chatID":chatID
      };
}
