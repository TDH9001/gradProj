import 'dart:math' as MainAxisSize;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:linkfy_text/linkfy_text.dart';

Widget chatMessageBubble(
    {required String message,
    required bool isOurs,
    required Timestamp ts,
    required String senderName,
    required bool isImportant}) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: isImportant ? Color(0xFFE7CD78) : Colors.grey.shade400),

    padding: EdgeInsets.symmetric(horizontal: 15),
    // height:
    //     _height * 0.13 + ((message.length * 3.5 + senderName.length) / 10),
    width: MediaService.instance.getWidth() * 0.80,
    child: Column(
      //mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment:
          isOurs ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(senderName),
        SizedBox(
          height: 5,
        ),
        LinkifyText(
          message,
        ),
        // SizedBox(
        //   height: 15,
        // ),
        Text(
          " ${ts.toDate().hour % 12}: ${ts.toDate().minute % 60} ${ts.toDate().hour < 12 ? "pm" : "am"}        ",
          style: TextStyle(fontSize: 16),
        )
      ],
    ),
  );
}
