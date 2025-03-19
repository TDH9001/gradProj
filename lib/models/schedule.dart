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
  factory ScheduleItemClass.fromFirestore(Map<String, dynamic> _snap) {
    // var _data = _snap.data();
    return ScheduleItemClass(
        name: _snap["name"],
        startTime: _snap["startTime"],
        endTime: _snap["endTime"],
        creatorName: _snap["creatorName"],
        creatorId: _snap["creatorId"],
        day: _snap["day"], //days.values.byName(_snap["day"]).index,
        type: _snap["type"], //sceduleType.values.byName(_snap["type"]).index,
        location: _snap["location"],
        endDate: _snap["endDate"] ?? null);
  }
  
}
