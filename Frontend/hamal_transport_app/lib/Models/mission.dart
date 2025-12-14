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

  /// compare Mission.id
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Mission && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
