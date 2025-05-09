class Contact {
  final String email;
  final String id;
  final String firstName;
  final String lastName;
  final List<String> classes;
  final int year;
  final bool isComplete;
  final String phoneNumber;
  final int? seatNumber;
  Contact(
      {required this.id,
      required this.email,
      required this.seatNumber,
      required this.firstName,
      required this.lastName,
      required this.classes,
      required this.year,
      required this.isComplete,
      required this.phoneNumber});

  factory Contact.fromJson(
      {required Map<String, dynamic> snap, required String id}) {
    return Contact(
      email: snap["Email"],
      id: id,
      seatNumber: snap["seatNumber"],
      firstName: snap["firstName"],
      lastName: snap["lastName"],
      classes: List<String>.from(snap["classes"] ?? []),
      year: snap["academicYear"],
      isComplete: snap["isComplete"],
      phoneNumber: snap["PhoneNumber"] ?? "THERE IS AN ERROR HEREE",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "classes": classes,
        "academicYear": year,
        "isComplete": isComplete,
        "phoneNumber": phoneNumber,
        "seatNumber": seatNumber,
        "Email": email
      };
}
