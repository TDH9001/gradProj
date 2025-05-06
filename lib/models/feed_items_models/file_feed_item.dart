import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../screen/theme/dark_theme_colors.dart';
import '../../screen/theme/light_theme.dart';
class FileFeedItem extends FeedItems {
  final String messageContent;
  FileFeedItem(
      {required super.senderID,
      required super.timestamp,
      required super.chatID,
      required this.messageContent,
      required super.senderName})
      : super(type: feedItemsEnum.file.name);

  factory FileFeedItem.fromMap(Map<String, dynamic> map) {
    if (map.isNotEmpty) {
      return FileFeedItem(
        senderID: map["senderID"],
        timestamp: map["timestamp"],
        senderName: map["senderName"],
        messageContent: map["messageContent"],
        chatID: map["chatID"],
      );
    } else {
      return FileFeedItem(
        senderID: "",
        timestamp: Timestamp.now(),
        senderName: "",
        messageContent: "",
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
    
    // Determine file type icon
    IconData fileIcon = Icons.insert_drive_file;
    String fileType = "File";
    
    if (messageContent.toLowerCase().endsWith('.pdf')) {
      fileIcon = Icons.picture_as_pdf;
      fileType = "PDF";
    } else if (messageContent.toLowerCase().endsWith('.doc') || 
               messageContent.toLowerCase().endsWith('.docx')) {
      fileIcon = Icons.description;
      fileType = "Document";
    } else if (messageContent.toLowerCase().endsWith('.xls') || 
               messageContent.toLowerCase().endsWith('.xlsx')) {
      fileIcon = Icons.table_chart;
      fileType = "Spreadsheet";
    } else if (messageContent.toLowerCase().endsWith('.ppt') || 
               messageContent.toLowerCase().endsWith('.pptx')) {
      fileIcon = Icons.slideshow;
      fileType = "Presentation";
    } else if (messageContent.toLowerCase().endsWith('.zip') || 
               messageContent.toLowerCase().endsWith('.rar')) {
      fileIcon = Icons.folder_zip;
      fileType = "Archive";
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
                      "Shared a file • ${timeago.format(timestamp.toDate())}",
                      style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12),
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
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(fileIcon, color: primaryColor, size: 32),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          messageContent.split('/').last,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          fileType,
                          style: TextStyle(color: textColor.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.download, color: primaryColor),
                    onPressed: () {
                      // Download functionality would go here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Download started")),
                      );
                    },
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
        "messageContent": messageContent,
        "type": feedItemsEnum.values.byName(type).index,
        "chatID":chatID
      };
}
