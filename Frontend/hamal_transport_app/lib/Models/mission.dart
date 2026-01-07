import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:hamal_transport_app/Services/routing_service.dart';
import 'contact.dart';
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

  Color get statusColor {
    switch (this) {
      case MissionStatus.available:
        return Colors.orange;
      case MissionStatus.chosen:
        return Colors.blue;
      case MissionStatus.pickedUp:
        return Colors.green;
      case MissionStatus.delivered:
      case MissionStatus.cancelled:
        return Colors.orange;
    }
  }
}

class Mission {
  final String id;
  final Location source;
  final Location destination;
  final String description;
  final Contact sourceContact;
  final Contact destinationContact;
  final DateTime time;
  MissionStatus status; // mutable so UI can update delivery status
  final CarType carType;
  String cancellationReason;
  final List<String> comments;

  Future<RouteInfo?>? _routeInfoFuture;

  Mission({
    required this.id,
    required this.source,
    required this.destination,
    required this.description,
    required this.sourceContact,
    required this.destinationContact,
    required this.time,
    this.status = MissionStatus.available,
    this.cancellationReason = '',
    required this.comments,
    required this.carType,
  });

  Mission.chosen({
    required this.id,
    required this.source,
    required this.destination,
    required this.description,
    required this.sourceContact,
    required this.destinationContact,
    required this.time,
    this.status = MissionStatus.chosen,
    this.cancellationReason = '',
    required this.comments,
    required this.carType,
  });

  /// Calculates route info once per Mission instance and reuses the same Future.
  Future<RouteInfo?> getRouteInfo({String profile = 'car'}) {
    _routeInfoFuture ??= RoutingService.getRouteInfo(
      startLat: source.latitude,
      startLon: source.longitude,
      endLat: destination.latitude,
      endLon: destination.longitude,
      profile: profile,
    );

    return _routeInfoFuture!;
  }

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

    // Parse status.
    CarType carType;
    carType = CarType.values.firstWhere(
      (e) => e.name == json['carType'],
      orElse: () => CarType.private,
    );

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
      sourceContact: Contact.fromJson(
        json['sourceContact'] as Map<String, dynamic>,
      ),
      destinationContact: Contact.fromJson(
        json['destinationContact'] as Map<String, dynamic>,
      ),
      time: time,
      status: status,
      comments: comments,
      carType: carType,
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source.toJson(),
      'destination': destination.toJson(),
      'description': description,
      'sourceContact': sourceContact.toJson(),
      'destinationContact': destinationContact.toJson(),
      'time': time.toIso8601String(),
      'status': status.name,
      'carType': carType.name,
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
