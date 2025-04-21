import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/models/feed_items_models/message_feed_Item.dart';
import 'package:grad_proj/models/feed_items_models/image_feed_item.dart';
import 'package:grad_proj/models/feed_items_models/file_feed_item.dart';
import 'package:grad_proj/models/feed_items_models/schedule_create_item.dart';
import 'package:grad_proj/models/schedule.dart';


class FeedTestScreen extends StatelessWidget {
  const FeedTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create sample feed items
    List<FeedItems> sampleFeedItems = [
      MessageFeedItem(
        senderID: "user123",
        timestamp: Timestamp.now(),
        senderName: "John Doe",
        chatID: "chat123",
        messageContent: "This is a sample message to test the message feed item UI.",
      ),
      ImageFeedItem(
        senderID: "user456",
        timestamp: Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 2))),
        senderName: "Jane Smith",
        chatID: "chat456",
        messageContent: "https://picsum.photos/500/300", // Sample image URL
      ),
      FileFeedItem(
        senderID: "user789",
        timestamp: Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1))),
        senderName: "Alex Johnson",
        chatID: "chat789",
        messageContent: "lecture_notes.pdf",
      ),
      SceduleCreateFeedItem(
        senderID: "user101",
        timestamp: Timestamp.fromDate(DateTime.now().subtract(Duration(hours: 5))),
        senderName: "Professor Williams",
        chatID: "chat101",
        scheduleItem: ScheduleItemClass(
          name: "Mobile Development",  // Changed from courseName to name
          startTime: 1000,  // Changed from string to int (10:00 AM in 24hr format)
          endTime: 1200,    // Changed from string to int (12:00 PM in 24hr format)
          creatorName: "Dr. Williams",  // Changed from professorName to creatorName
          creatorId: "prof123",  // Added required parameter
          day: days.monday.index,  // Changed from string to enum index
          location: "Room 305",
          type: sceduleType.permanat.index,  // Added required parameter
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