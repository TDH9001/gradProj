import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'contact.g.dart'; // Hive generated file

@HiveType(typeId: 0) // Unique type ID for Hive
class Contact {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String firstName;
  
  @HiveField(2)
  final String lastName;
  
  @HiveField(3)
  final List<String> classes;
  
  @HiveField(4)
  final int year;
  
  @HiveField(5)
  final bool isComplete;
  
  @HiveField(6)
  final String phoneNumber;

  Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.classes,
    required this.year,
    required this.isComplete,
    required this.phoneNumber,
  });

  // Add this factory method if needed for Firestore
  factory Contact.fromFirestore(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return Contact(
      id: snap.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      classes: (data['classes'] as List<dynamic>).map((e) => e.toString()).toList(),
      year: data['academicYear'] ?? 0,
      isComplete: data['isComplete'] ?? false,
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }
}
