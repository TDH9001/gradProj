import 'package:cloud_firestore/cloud_firestore.dart';

enum AnnouncmentType {
  sceduleChange,
  announcment,
  image_announcment,
  scedule_added,
  def,
}

class Feed {
  final AnnouncmentType type;
  final String senderName;
  final Timestamp timestamp;
  final String senderID;
  final String group;
  final Map content;
  Feed(
      {required this.type,
      required this.content,
      required this.group,
      required this.senderID,
      required this.senderName,
      required this.timestamp});

        factory Feed.fromFirestore(DocumentSnapshot _snap) {
    var _data = _snap.data();
    return Feed(
      senderID: _snap.id,
      group: _snap["group"],
      timestamp: _snap["timestamp"],
      content: _snap["FeedContent"],
      senderName: _snap["senderName"],
      type: _snap["type"],
    
    );
  }
}
