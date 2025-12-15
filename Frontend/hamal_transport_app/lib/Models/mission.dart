import 'package:flutter/widgets.dart';
import '../features/Contact_card/model/contact.dart';
import '../l10n/app_localizations.dart';

enum MissionStatus {
  chosen,
  pickedUp,
  delivered,
  cancelled,
  available;

  String displayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case MissionStatus.chosen:
        return l10n.chosen;
      case MissionStatus.pickedUp:
        return l10n.pickedUp;
      case MissionStatus.delivered:
        return l10n.delivered;
      case MissionStatus.cancelled:
        return l10n.cancelled;
      case MissionStatus.available:
        return l10n.available;
    }
  }
}

class Mission {
  final String id;
  final String location;
  final String description;
  final Contact contact;
  final DateTime time;
  MissionStatus status; // mutable so UI can update delivery status

  Mission({
    required this.id,
    required this.location,
    required this.description,
    required this.contact,
    required this.time,
    this.status = MissionStatus.available,
  });

  Mission.chosen({
    required this.id,
    required this.location,
    required this.description,
    required this.contact,
    required this.time,
    this.status = MissionStatus.chosen,
  });

  // JSON to object constructor
  factory Mission.fromJson(Map<String, dynamic> json) {
    // Parse status.
    MissionStatus status = MissionStatus.available;
    if (json['status'] != null) {
      status = MissionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MissionStatus.available,
      );
    }

    // Parse time.
    DateTime time = DateTime.now();
    if (json['time'] != null) {
      time = DateTime.parse(json['time'] as String);
    }

    return Mission(
      id: json['id'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      contact: Contact.fromJson(json['contact'] as Map<String, dynamic>),
      time: time,
      status: status,
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'description': description,
      'contact': contact.toJson(),
      'time': time.toIso8601String(),
      'status': status.name,
    };
  }

  /// compare Mission.id
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Mission && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
