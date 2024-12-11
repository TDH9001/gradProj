import 'package:cloud_firestore/cloud_firestore.dart';

class contact {
  final String Id;
  final String FirstName;
  final String LastName;
  // final Timestamp LastSeet;
  final List<String> Classes;
  final int Year;
  final bool isComplete;
  final String phoneNumber;
  contact(
      {required this.Id,
      required this.FirstName,
      required this.LastName,
      required this.Classes,
      required this.Year,
      // required this.LastSeet,
      required this.isComplete,
      required this.phoneNumber});

  factory contact.fromFirestore(DocumentSnapshot _snap) {
    return contact(
        Id: _snap.id,
        FirstName: _snap["firstName"],
        LastName: _snap["lastName"],
        Classes: (_snap["classes"] as List<dynamic>)
            .map((e) => e.toString())
            .toList(),
        // LastSeet: _snap["lastSeen"],
        Year: _snap["academicYear"],
        isComplete: _snap["isComplete"],
        phoneNumber: _snap["PhoneNumber"]);
  }
}
