class contact {
  final String id;
  final String firstName;
  final String lastName;
  final List<String> classes;
  final int year;
  final bool isComplete;
  final String phoneNumber;
  final String? seatNumber;
  contact(
      {required this.id,
      required this.seatNumber,
      required this.firstName,
      required this.lastName,
      required this.classes,
      required this.year,
      required this.isComplete,
      required this.phoneNumber});

  factory contact.fromJson(
      {required Map<String, dynamic> snap, required String id}) {
    return contact(
      id: id,
      seatNumber: snap["seatNumber"],
      firstName: snap["firstName"],
      lastName: snap["lastName"],
      classes: snap["classes"],
      year: snap["year"],
      isComplete: snap["isComplete"],
      phoneNumber: snap["phoneNumber"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "classes": classes,
        "year": year,
        "isComplete": isComplete,
        "phoneNumber": phoneNumber,
        "seatNumber": seatNumber
      };
}
