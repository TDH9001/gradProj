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
  factory ScheduleItemClass.fromMap(Map<String, dynamic> _snap) {
    // var _data = _snap.data();
    if (_snap.isNotEmpty) {
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
    } else {
      return ScheduleItemClass(
          name: "",
          startTime: 0,
          endTime: 0,
          creatorName: "",
          creatorId: "",
          day: 0,
          type: 0,
          location: "",
          endDate: null);
    }
  }

  Map<String, dynamic> toMap() => {
        "name": name,
        "startTime": startTime,
        "endTime": endTime,
        "creatorName": creatorName,
        "creatorId": creatorId,
        "day": day, //days.values.byName(day).name,
        "type": type, //sceduleType.values.byName(type).name,
        "location": location,
        "endDate": endDate ?? null
      };
}
