import 'package:cloud_firestore/cloud_firestore.dart';

enum days { saturday, sunday, monday, tuesday, wednesday, thursday, friday }

enum sceduleType { permanat, temporary, personal }

class ScheduleItemClass {
  final String name;
  final int startTime;
  final int endTime;
  final String creatorName;
  final String creatorId;
  Timestamp? endDate;
  final String location;
  final int day;
  final int type;
  ScheduleItemClass(
      {required this.name,
      required this.startTime,
      required this.endTime,
      required this.creatorName,
      required this.creatorId,
      required this.day,
      required this.location,
      required this.type,
      this.endDate});
}
