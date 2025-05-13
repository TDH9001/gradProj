import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grad_proj/models/feed_Items.dart';
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

    return VoiceBubble(
        AudioAdress: messageContent,
        isOurs: false,
        ts: timestamp,
        senderName: senderName,
        isImportant: false);
  }
}
