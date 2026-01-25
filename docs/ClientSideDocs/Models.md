# Models

This document specifies the core data models used in the Hamal Transport App, their purpose, and where they are used.

## UserProfile
- **Path**: [user_profile.dart](../../Frontend/hamal_transport_app/lib/Models/user_profile.dart)
- **Purpose**: Represents a user in the system, including their role (driver, logistics, admin) and specific profile data.
- **Used In**: `AuthenticationService`, `UserProfileViewModel`, `DriverPhoneBookViewModel`.

## Mission
- **Path**: [mission.dart](../../Frontend/hamal_transport_app/lib/Models/mission.dart)
- **Purpose**: Represents a transport mission, including source/destination locations, status, assigned driver, and requirements. This data model is also used as the data model for the missions in the database.
- **Used In**: `MissionsRepository`, `MissionsListViewModel`, `MapViewModel`, `MissionViewModel`.

## Location
- **Path**: [location.dart](../../Frontend/hamal_transport_app/lib/Models/location.dart)
- **Purpose**: A simple structure for latitude/longitude coordinates and a location name.
- **Used In**: `Mission`, `MapViewModel`, `MissionsListViewModel`.

## Contact
- **Path**: [contact.dart](../../Frontend/hamal_transport_app/lib/Models/contact.dart)
- **Purpose**: Stores contact information (name and phone) for mission source and destination points.
- **Used In**: `Mission`.

## DriverProfile
- **Path**: [user_profile.dart](../../Frontend/hamal_transport_app/lib/Models/user_profile.dart)
- **Purpose**: Additional data for users with the `driver` role, specifically their `CarType`.
- **Used In**: `UserProfile`.

## Enums
- **UserRole**: `driver`, `logistics`, `admin`.
- **MissionStatus**: `available`, `assigned`, `pickedUp`, `delivered`, `cancelled`.
- **CarType**: `private`, `trailer`, `pickupTruck`, `truck`.
