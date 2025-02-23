import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message.dart';

part 'chats.g.dart'; // Generated file

@HiveType(typeId: 0)
class ChatSnipits extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String Chatid;
  
  @HiveField(2)
  final String LastMessage;
  
  @HiveField(3)
  final String Sendername;
  
  @HiveField(4)
  final int unseenCount;
  
  @HiveField(5)
  final DateTime timestamp; // Changed from Timestamp to DateTime
  
  @HiveField(6)
  final List<String> adminId;
  
  @HiveField(7)
  final String type;

  ChatSnipits({
    required this.id,
    required this.Chatid,
    required this.LastMessage,
    required this.Sendername,
    required this.unseenCount,
    required this.timestamp,
    required this.adminId,
    required this.type,
  });

  factory ChatSnipits.fromFirestore(DocumentSnapshot _snap) {
    return ChatSnipits(
      id: _snap.id,
      Chatid: _snap["chatID"],
      LastMessage: _snap["lastMessage"] ?? "",
      timestamp: (_snap["timestamp"] as Timestamp).toDate(), // Convert to DateTime
      unseenCount: _snap["unseenCount"],
      Sendername: _snap["senderName"],
      type: _snap["type"],
      adminId: (_snap["admins"] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  // Add a method to convert to JSON for Hive
  Map<String, dynamic> toHiveMap() => {
    'id': id,
    'Chatid': Chatid,
    'LastMessage': LastMessage,
    'Sendername': Sendername,
    'unseenCount': unseenCount,
    'timestamp': timestamp,
    'adminId': adminId,
    'type': type,
  };
}

@HiveType(typeId: 1)
class ChatData extends HiveObject {
  @HiveField(0)
  final String Chatid;
  
  @HiveField(1)
  final List<String> members;
  
  @HiveField(2)
  final List<String> owners;
  
  @HiveField(3)
  final List<Message> messages;

  ChatData({
    required this.Chatid,
    required this.members,
    required this.messages,
    required this.owners,
  });

  factory ChatData.fromFirestore(DocumentSnapshot _snap) {
    List<dynamic> rawMessages = _snap["messages"] ?? [];
    
    return ChatData(
      Chatid: _snap.id,
      members: (_snap["members"] as List<dynamic>).map((e) => e.toString()).toList(),
      owners: (_snap["ownerID"] as List<dynamic>).map((e) => e.toString()).toList(),
      messages: rawMessages.map((message) => Message.fromFirestore(message)).toList(),
    );
  }

  // Hive-specific conversion
  Map<String, dynamic> toHiveMap() => {
    'Chatid': Chatid,
    'members': members,
    'owners': owners,
    'messages': messages.map((m) => m.toHiveMap()).toList(),
  };
}
