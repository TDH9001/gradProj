import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../screen/theme/dark_theme_colors.dart';
import '../../screen/theme/light_theme.dart';

class VideoFeedItem extends FeedItems {
  final String messagecontent;
  VideoFeedItem(
      {required super.senderID,
      required super.chatID,
      required super.timestamp,
      required this.messagecontent,
      required super.senderName})
      : super(type: feedItemsEnum.video.name);
  factory VideoFeedItem.fromMap(Map<String, dynamic> map) {
    if (map.isNotEmpty) {
      return VideoFeedItem(
        senderID: map["senderID"],
        timestamp: map["timestamp"],
        senderName: map["senderName"],
        messagecontent: map["messageContent"],
        chatID: map["chatID"],
      );
    } else {
      return VideoFeedItem(
        senderID: "",
        timestamp: Timestamp.now(),
        senderName: "",
        messagecontent: "",
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
                  child: Text(
                    senderName.isNotEmpty ? senderName[0].toUpperCase() : "?",
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      senderName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 16,
                        color: textColor
                      ),
                    ),
                    Text(
                      "Shared a video • ${timeago.format(timestamp.toDate())}",
                      style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Video thumbnail would go here in a real implementation
                  Container(
                    color: Color(0xFF323232).withOpacity(0.8),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Icon(
                    Icons.play_circle_fill,
                    size: 60,
                    color: backgroundColor.withOpacity(0.8),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Video",
                        style: TextStyle(color: backgroundColor, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        "senderID": senderID,
        "timestamp": timestamp,
        "senderName": senderName,
        "messageContent": messagecontent,
        "type": feedItemsEnum.values.byName(type).index,
        "chatID": chatID
      };
}
