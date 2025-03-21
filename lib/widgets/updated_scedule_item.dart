import 'package:flutter/material.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget updatedSceduleItem(ScheduleItemClass scl) {
//  final ScheduleItemClass scl;
  // print(scl.endDate.toString());
  // if (scl.type == 2) {
  //   print(scl.endDate!.toDate());
  // }
  // print("////////////////////////");

  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Container(
      decoration: BoxDecoration(
        color: scl.type == 1
            ? const Color(0xff769BC6)
            : scl.type == 2
                ? Colors.red
                : Colors.lightGreen,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scl.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  scl.location,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                Text(
                  scl.creatorName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "${(scl.startTime / 100).floor() % 12}:${scl.startTime % 100} ${scl.startTime / 100 > 12 ? "PM" : "AM"} - ${(scl.endTime / 100).floor() % 12}:${scl.endTime % 100} ${scl.endTime / 100 > 12 ? "PM" : "AM"}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${days.values[scl.day].name}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                scl.endDate != null
                    ? Text(
                        //needs to be made correct
                        timeago.format(scl.endDate!.toDate(),
                            allowFromNow: true),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
