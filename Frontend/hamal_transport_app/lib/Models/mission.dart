import 'package:flutter/widgets.dart';
import '../features/Contact_card/model/contact.dart';
import '../l10n/app_localizations.dart';
import 'location.dart';

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
  final Location source;
  final Location destination;
  final String description;
  final Contact contact;
  final DateTime time;
  MissionStatus status; // mutable so UI can update delivery status
  String cancellationReason;
  final List<String> comments;

  Mission({
    required this.id,
    required this.source,
    required this.destination,
    required this.description,
    required this.contact,
    required this.time,
    this.status = MissionStatus.available,
    this.cancellationReason = '',
    required this.comments,
  });

  Mission.chosen({
    required this.id,
    required this.source,
    required this.destination,
    required this.description,
    required this.contact,
    required this.time,
    this.status = MissionStatus.chosen,
    this.cancellationReason = '',
    required this.comments,
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

    // Parse comments (null-safe)
    final List<String> comments =
        (json['comments'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return Mission(
      id: json['id'] as String,
      source: Location.fromJson(json['source'] as Map<String, dynamic>),
      destination: Location.fromJson(
        json['destination'] as Map<String, dynamic>,
      ),
      description: json['description'] as String,
      contact: Contact.fromJson(json['contact'] as Map<String, dynamic>),
      time: time,
      status: status,
      comments: comments,
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source.toJson(),
      'destination': destination.toJson(),
      'description': description,
      'contact': contact.toJson(),
      'time': time.toIso8601String(),
      'status': status.name,
      'comments': comments,
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
