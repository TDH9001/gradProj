import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'message.g.dart';  // Add this line

@HiveType(typeId: 2)
class Message extends HiveObject {
  @HiveField(0)
  final String senderID;
  
  @HiveField(1)
  final String senderName;
  
  @HiveField(2)
  final String messageContent;
  
  @HiveField(3)
  final DateTime timestamp;
  
  @HiveField(4)
  final String type;

  Message({
    required this.senderID,
    required this.senderName,
    required this.messageContent,
    required this.timestamp,
    required this.type,
  });

  // Add this factory method
  factory Message.fromFirestore(Map<String, dynamic> data) => Message(
    senderID: data["senderID"] ?? "",
    senderName: data["senderName"] ?? "",
    messageContent: data["message"] ?? "",
    timestamp: (data["timestamp"] as Timestamp).toDate(),
    type: data["type"] ?? "text",
  );

  // Add this method
  Map<String, dynamic> toHiveMap() => {
    'senderID': senderID,
    'senderName': senderName,
    'messageContent': messageContent,
    'timestamp': timestamp,
    'type': type,
  };
}
