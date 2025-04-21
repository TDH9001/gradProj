import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/models/feed_items_models/message_feed_Item.dart';
import 'package:grad_proj/models/feed_items_models/image_feed_item.dart';
import 'package:grad_proj/models/feed_items_models/file_feed_item.dart';
import 'package:grad_proj/models/feed_items_models/video_feed_item.dart';
import 'package:grad_proj/models/feed_items_models/schedule_create_item.dart';
import 'package:grad_proj/models/feed_items_models/schedule_update_item.dart';
import 'package:grad_proj/models/feed_items_models/schedule_delete_item.dart';
import 'package:grad_proj/models/schedule.dart';

class FeedTestScreen extends StatelessWidget {
  const FeedTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<FeedItems> sampleFeedItems = [
      MessageFeedItem(
        senderID: "user123",
        timestamp: Timestamp.now(),
        senderName: "Ahmed",
        chatID: "chat123",
        messageContent: "testing the message feed item ui askdnjaskndkasnkndkasndn",
      ),
      ImageFeedItem(
        senderID: "user456",
        timestamp: Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 2))),
        senderName: "Saqr",
        chatID: "chat456",
        messageContent: "https://picsum.photos/500/300",
      ),
      FileFeedItem(
        senderID: "user789",
        timestamp: Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1))),
        senderName: "Mohamed",
        chatID: "chat789",
        messageContent: "lecture_notes.pdf",
      ),
      VideoFeedItem(
        senderID: "user321",
        timestamp: Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 8))),
        senderName: "Ali",
        chatID: "chat321",
        messagecontent: "https://example.com/sample_video.mp4",
      ),
      SceduleCreateFeedItem(
        senderID: "user101",
        timestamp: Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 5))),
        senderName: "Mahmoud",
        chatID: "chat101",
        scheduleItem: ScheduleItemClass(
          name: "Mobile Development",
          startTime: 1000,
          endTime: 1200,
          creatorName: "Dr. Wael",
          creatorId: "prof123",
          day: days.monday.index,
          location: "Room 305",
          type: sceduleType.permanat.index,
        ),
      ),
      ScheduleUpdateItem(
        senderID: "user202",
        timestamp: Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 3))),
        senderName: "Sayed",
        chatID: "chat202",
        oldScheduleItem: ScheduleItemClass(
          name: "Cyper Security",
          startTime: 1400,
          endTime: 1600,
          creatorName: "Dr. Dieaa",
          creatorId: "prof456",
          day: days.wednesday.index,
          location: "Room 201",
          type: sceduleType.permanat.index,
        ),
        newScheduleItem: ScheduleItemClass(
          name: "Web Development",
          startTime: 1500,
          endTime: 1700,
          creatorName: "Dr. Mohamed",
          creatorId: "prof456",
          day: days.thursday.index,
          location: "Room 302",
          type: sceduleType.permanat.index,
        ),
      ),
      ScheduleDeleteFeedItem(
        senderID: "user303",
        timestamp: Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 1))),
        senderName: "XYZ",
        chatID: "chat303",
        scheduleItem: ScheduleItemClass(
          name: "Data Structures",
          startTime: 0900,
          endTime: 1100,
          creatorName: "Dr. Wael",
          creatorId: "prof789",
          day: days.friday.index,
          location: "Room 405",
          type: sceduleType.permanat.index,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Feed Items Test"),
      ),
      body: ListView.builder(
        itemCount: sampleFeedItems.length,
        itemBuilder: (context, index) {
          return sampleFeedItems[index].present(context: context);
        },
      ),
    );
  }
}