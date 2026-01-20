# Role-Based UI & Routing

The app provides a different user experience and set of permissions based on the user's role: `driver`, `logistics`, or `admin`.

## AuthGate
- **Path**: [auth_gate.dart](../../Frontend/hamal_transport_app/lib/Views/Authentication/auth_gate.dart)
- **Functionality**:
    - Acts as the entry point after initial app launch.
    - Uses `AuthenticationService` to check if a user is logged in (session or "Remember Me").
    - If not logged in, it redirects to the `LoginScreenView`.
    - If logged in, it fetches the `UserProfile` from the database.
    - Based on the `UserRole` in the profile, it calls `getDestinationForRole` to navigate to the appropriate interface.

## Role-Based Routing
- **Path**: [role_based_routing.dart](../../Frontend/hamal_transport_app/lib/Views/role_based_routing.dart)
- **Logic**:
    - **Drivers**: Routed to a navigation structure containing:
        - **Missions Tabs**: "My Missions" (active/assigned) and "Available Missions".
        - **Map View**: Centered on the driver's location with mission markers.
        - **Profile**: User account settings.
    - **Logistics/Admin**: Routed to a structure containing:
        - **Missions Tabs**: All mission categories (Available, Assigned, Picked up, Cancelled, Delivered).
        - **Map View**: Global view of all missions.
        - **Drivers Phonebook**: List of all registered drivers with filtering by car type.
        - **Profile**: User account settings.

## Permission Control
UI elements and actions are restricted based on roles. For example:
- Only drivers can "Take" a mission.
- Logistics and admin users can view the full phonebook of drivers.
- The `MapViewModel` filters markers based on the role (e.g., drivers don't see delivered missions).
