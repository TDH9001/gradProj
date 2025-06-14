import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/models/message.dart';
import 'package:grad_proj/screen/chats/chat_page_widgets/caht_mesage_widgets/voice_chat_bubble.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../screen/theme/dark_theme_colors.dart';
import '../../screen/theme/light_theme.dart';

class VoiceFeedItem extends FeedItems {
  final String messageContent;
  VoiceFeedItem({
    required super.senderID,
    required super.timestamp,
    required super.senderName,
    required super.chatID,
    required this.messageContent,
  }) : super(type: feedItemsEnum.voice.name);

  factory VoiceFeedItem.fromMap(Map<String, dynamic> map) {
    if (map.isNotEmpty) {
      return VoiceFeedItem(
        senderID: map["senderID"],
        timestamp: map["timestamp"],
        senderName: map["senderName"],
        messageContent: map["messageContent"],
        chatID: map["chatID"],
      );
    } else {
      return VoiceFeedItem(
        senderID: "",
        timestamp: Timestamp.now(),
        senderName: "",
        messageContent: "",
        chatID: "",
      );
    }
  }

  @override
  Map<String, dynamic> toMap() => {
        "senderID": senderID,
        "timestamp": timestamp,
        "senderName": senderName,
        "messageContent": messageContent,
        "type": feedItemsEnum.values.byName(type).index,
        "chatID": chatID
      };
  //to get the type corect > switch(map["type"]){case 0: message(map) nad so on
  //AKA > depeding on the type, it selects the right class and type is auto injected

  @override
  Widget present({required BuildContext context}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor =
        isDark ? DarkThemeColors.secondary : LightTheme.primary;
    final secondaryColor =
        isDark ? DarkThemeColors.secondary : LightTheme.secondary;
    final backgroundColor =
        isDark ? DarkThemeColors.background : LightTheme.background;
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
                          color: textColor),
                    ),
                    Text(
                      "Recorder a message • ${timeago.format(timestamp.toDate())}",
                      style: TextStyle(
                          color: textColor.withOpacity(0.6), fontSize: 12),
                    ),
                    Text(
                      "From : $chatID",
                      style: TextStyle(
                          color: textColor.withOpacity(0.6), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: secondaryColor.withOpacity(0.3)),
              ),
              child: VoiceBubble(
                  admins: [],
                  chatID: chatID,
                  message: Message(
                      senderID: senderID,
                      messageContent: messageContent,
                      timestamp: timestamp,
                      type: type,
                      senderName: senderName,
                      isImportant: true)),
            ),
          ],
        ),
      ),
    );
  }
}
