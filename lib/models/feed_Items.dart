import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum feedItems {
  message,
  image,
  video,
  file,
  sceduleCreate,
  sceduleChange,
  sceduleDelete,
}

abstract class FeedItems {
  final String senderID;
  final Timestamp timestamp;
  final String type;
  final String senderName;

  FeedItems(
      {required this.senderID,
      required this.timestamp,
      required this.type,
      required this.senderName});

  Map<String, dynamic> toMap();
  Widget present({required BuildContext context});

  
}
