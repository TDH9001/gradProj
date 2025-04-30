import 'dart:math' as MainAxisSize;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/services/media_service.dart';

Widget chatMessageBubble(
    {required String message,
    required bool isOurs,
    required Timestamp ts,
    required String senderName}) {
  var _numMap = {
    1: "jan",
    2: "feb",
    3: "mar",
    4: 'apr',
    5: "may",
    6: "jun",
    7: "jul",
    8: "aug",
    9: "sep",
    10: "oct",
    11: "nov",
    12: "dec"
  };
  var _weekmap = {
    6: "saturday",
    7: 'sunday',
    1: "monday",
    2: "tuesday",
    3: "wednesday",
    4: "thursday",
    5: "friday"
  };
  List<Color> colorScheme = isOurs
      ? [Color(0xFFA3BFE0), Color(0xFF769BC6)]
      : [Color(0xFF769BC6), Color(0xFFA3BFE0)];
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
            colors: colorScheme,
            stops: [0.40, 0.70],
            begin: isOurs ? Alignment.bottomLeft : Alignment.bottomRight,
            end: isOurs ? Alignment.topRight : Alignment.topLeft)),
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
        Text(message),
        // SizedBox(
        //   height: 15,
        // ),
        Text(
          "${_weekmap[ts.toDate().weekday]} ${_numMap[ts.toDate().month]} ${ts.toDate().day} , ${ts.toDate().hour % 12}: ${ts.toDate().minute % 60} ${ts.toDate().hour < 12 ? "pm" : "am"}        ",
          style: TextStyle(fontSize: 16),
        )
      ],
    ),
  );
}
