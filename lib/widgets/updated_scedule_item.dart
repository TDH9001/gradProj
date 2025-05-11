import 'package:flutter/material.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../providers/theme_provider.dart';

Widget updatedSceduleItem(ScheduleItemClass scl) {
  LinearGradient getGradient(int type) {
    switch (type) {
      case 1:
        return const LinearGradient(
          colors: [Color(0xff2E5077), Color(0xff769BC6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return const LinearGradient(
          colors: [Color(0xFFD9534F), Color(0xFFFA8072)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF5CB85C), Color(0xFF8BC34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData getIcon(int type) {
    switch (type) {
      case 1:
        return Icons.school;
      case 2:
        return Icons.warning_amber_rounded;
      default:
        return Icons.check_circle_outline;
    }
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: Container(
      decoration: BoxDecoration(
        gradient: getGradient(scl.type),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      getIcon(scl.type),
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      scl.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  scl.location,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                Text(
                  scl.creatorName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${(scl.startTime / 100).floor() % 12}:${scl.startTime % 100} ${scl.startTime / 100 > 12 ? "PM" : "AM"} - ${(scl.endTime / 100).floor() % 12}:${scl.endTime % 100} ${scl.endTime / 100 > 12 ? "PM" : "AM"}",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  days.values[scl.day].name,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                scl.endDate != null
                    ? Text(
                  timeago.format(scl.endDate!.toDate(),
                      allowFromNow: true),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                )
                    : const SizedBox()
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
