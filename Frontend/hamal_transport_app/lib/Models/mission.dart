import '../features/Contact_card/model/Contact.dart';

class Mission {
  final String id;
  final String location;
  final String description;
  final Contact contact;
  final DateTime time;
  String status; // mutable so UI can update delivery status

  Mission({
    required this.id,
    required this.location,
    required this.description,
    required this.contact,
    required this.time,
    this.status = 'available',
  });

  /// compare Mission.id
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Mission && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
