# Services

This document explains the various services used in the Hamal Transport App, their implementation details, and the technologies they leverage.

## AuthenticationService
- **Path**: [authentication_service.dart](../../Frontend/hamal_transport_app/lib/Services/authentication_service.dart)
- **Purpose**: Manages user authentication, profile retrieval, and session persistence.
- **Frameworks/Hardware**:
    - **Firebase Auth**: For secure email/password authentication.
    - **Firebase Realtime Database**: Stores and retrieves extended user profile information.
    - **Shared Preferences**: Persists the "Remember Me" setting locally.

## LocationService
- **Path**: [location_service.dart](../../Frontend/hamal_transport_app/lib/Services/location_service.dart)
- **Purpose**: Tracks the user's real-time geographic location.
- **Frameworks/Hardware**:
    - **Geolocator**: Interfaces with the device's GPS and location hardware.
    - **Stream**: Provides a broadcast stream of location updates (`Position`).

## MissionsRepository
- **Path**: [missions_repository.dart](../../Frontend/hamal_transport_app/lib/Services/missions_repository.dart)
- **Purpose**: Acts as a central data store for all missions, providing filtering and status update logic.
- **Frameworks/Hardware**:
    - **ChangeNotifier**: Allows UI components to listen for data changes.

## RoutingService
- **Path**: [routing_service.dart](../../Frontend/hamal_transport_app/lib/Services/routing_service.dart)
- **Purpose**: Calculates optimal routes and travel times between geographic points.
- **Frameworks/Hardware**:
    - **HTTP**: Makes requests to the **OpenStreetMap (OSRM)** API.
    - **OSRM API**: External backend service for routing logic.

## AppPreferencesService
- **Path**: [app_preferences_service.dart](../../Frontend/hamal_transport_app/lib/Services/app_preferences_service.dart)
- **Purpose**: Manages application-level settings like theme (dark mode) and language.
- **Frameworks/Hardware**:
    - **Shared Preferences**: Stores user preferences locally on the device.
