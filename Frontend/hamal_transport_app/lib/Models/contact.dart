class Contact {
  final String fullName;
  final String phoneNumber;

  Contact({required this.fullName, required this.phoneNumber});

  // JSON to object constructor
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {'fullName': fullName, 'phoneNumber': phoneNumber};
  }
}
