class Mission {
  final String id;
  final String location;
  final String description;
  final String contact;
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
}
