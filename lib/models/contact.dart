import 'package:cloud_firestore/cloud_firestore.dart';

class contact {
  final String Id;
  final String FirstName;
  final String LastName;
  final Timestamp LastSeet;
  final List<String> Classes;
  final int Year;
  contact(
      {required this.Id,
      required this.FirstName,
      required this.LastName,
      required this.Classes,
      required this.Year,
      required this.LastSeet});

  factory contact.fromFirestore(DocumentSnapshot _snap) {
    return contact(
        Id: _snap.id,
        FirstName: _snap["firstName"],
        LastName: _snap["lastName"],
        Classes: _snap["classes"],
        LastSeet: _snap["lastSeen"],
        Year: _snap["academicYear"]);
  }
}
