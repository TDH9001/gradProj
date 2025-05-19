import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../screen/theme/dark_theme_colors.dart';
import '../../screen/theme/light_theme.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? DarkThemeColors.primary : LightTheme.primary;
    final secondaryColor = isDark ? DarkThemeColors.secondary : LightTheme.secondary;
    final backgroundColor = isDark ? DarkThemeColors.background : LightTheme.background;
    final textColor = isDark ? DarkThemeColors.textcolor : LightTheme.textcolor;
    final errorColor = Colors.red.shade300;

    // Get day name from enum
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
                  backgroundColor: errorColor.withOpacity(0.3),
                  child: Icon(Icons.event_busy, color: errorColor),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ScheduleDeleteFeedItem.schedule_deleted'.tr(),
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
                color: errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: errorColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   'ScheduleDeleteFeedItem.deleted_schedule_details'.tr(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 14,
                      color: textColor
                    ),
                  ),
                  Divider(color: errorColor.withOpacity(0.3)),
                  _buildScheduleDetailRow(context, 'ScheduleDeleteFeedItem.course'.tr(), scheduleItem.name),
                  _buildScheduleDetailRow(context, 'ScheduleDeleteFeedItem.day'.tr(), getDayName(scheduleItem.day)),
                  _buildScheduleDetailRow(context, 'ScheduleDeleteFeedItem.time'.tr(), "${formatTime(scheduleItem.startTime)} - ${formatTime(scheduleItem.endTime)}"),
                  _buildScheduleDetailRow(context, 'ScheduleDeleteFeedItem.location'.tr(), scheduleItem.location),
                ],
              ),
            ),
          ],
        ),
      ),
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
