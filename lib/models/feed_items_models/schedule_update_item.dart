import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../screen/theme/dark_theme_colors.dart';
import '../../screen/theme/light_theme.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? DarkThemeColors.secondary : LightTheme.primary;
    final secondaryColor = isDark ? DarkThemeColors.secondary : LightTheme.secondary;
    final backgroundColor = isDark ? DarkThemeColors.background : LightTheme.background;
    final textColor = isDark ? DarkThemeColors.textcolor : LightTheme.textcolor;

    // Get day names from enum
    String getDayName(int dayIndex) {
      return days.values[dayIndex].name;
    }

    // Format time from integer (e.g., 1430 -> "14:30")
    String formatTime(int time) {
      String timeStr = time.toString().padLeft(4, '0');
      return "${timeStr.substring(0, 2)}:${timeStr.substring(2, 4)}";
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: secondaryColor.withOpacity(0.3),
                  child: Icon(Icons.update, color: primaryColor),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Schedule Updated",
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 16,
                        color: textColor
                      ),
                    ),
                    Text(
                      "$senderName • ${timeago.format(timestamp.toDate())}",
                      style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: secondaryColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Updated Schedule",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 14,
                      color: textColor
                    ),
                  ),
                  Divider(color: secondaryColor.withOpacity(0.3)),
                  _buildScheduleComparisonRow(context, "Course", oldScheduleItem.name, newScheduleItem.name),
                  _buildScheduleComparisonRow(context, "Day", getDayName(oldScheduleItem.day), getDayName(newScheduleItem.day)),
                  _buildScheduleComparisonRow(context, "Time", "${formatTime(oldScheduleItem.startTime)} - ${formatTime(oldScheduleItem.endTime)}", 
                                                     "${formatTime(newScheduleItem.startTime)} - ${formatTime(newScheduleItem.endTime)}"),
                  _buildScheduleComparisonRow(context, "Location", oldScheduleItem.location, newScheduleItem.location),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleComparisonRow(BuildContext context, String label, String oldValue, String newValue) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? DarkThemeColors.secondary : LightTheme.primary;
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
                            color: Colors.white,
                            //secondaryColor
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
