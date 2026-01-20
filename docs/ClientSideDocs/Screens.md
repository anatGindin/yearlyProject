# Screens

This document describes the key screens in the Hamal Transport App, their sub-widgets, and how their respective ViewModels handle logic.

## Map View
- **File**: [map_view.dart](../../Frontend/hamal_transport_app/lib/Views/map_view.dart)
- **ViewModel**: [map_view_model.dart](../../Frontend/hamal_transport_app/lib/ViewModels/map_view_model.dart)
- **Key Sub-widgets**:
    - `FlutterMap`: The interactive map component.
    - `MapLegend`: Displays counts of missions by status.
    - `MapFilters`: Allows toggling visibility of different mission types.
- **Functionality**: Displays the user's location and mission markers. `MapViewModel` handles permissions, location streaming, and marker logic.

## User Profile Page
- **File**: [user_profile_page.dart](../../Frontend/hamal_transport_app/lib/Views/user_profile_page.dart)
- **ViewModel**: [user_profile_view_model.dart](../../Frontend/hamal_transport_app/lib/ViewModels/user_profile_view_model.dart)
- **Key Sub-widgets**:
    - `ProfileInformationHeader`: Displays basic user details.
    - `ProfileMenuOptions`: List of settings and actions (Logout, Theme toggle, Language).
- **Functionality**: Displays and allows editing of user profile data. `UserProfileViewModel` interacts with `AuthenticationService` for updates and logouts.

## Missions Tabs Page
- **File**: [missions_tabs_page.dart](../../Frontend/hamal_transport_app/lib/Views/missions_tabs_page.dart)
- **ViewModel**: [missions_list_view_model.dart](../../Frontend/hamal_transport_app/lib/ViewModels/missions_list_view_model.dart)
- **Functionality**: A container for multiple tabs of mission lists. It uses a `TabBar` and `TabBarView`.
- **Tabs Explained**:
    - **My Missions**: Missions currently assigned to the logged-in driver.
    - **Available**: Missions that anyone can pick up.
    - **Assigned/Picked Up/Delivered/Cancelled**: (Logistics only) Category-specific lists for monitoring the fleet.

## Drivers Phonebook
- **File**: [driver_phone_book_screen.dart](../../Frontend/hamal_transport_app/lib/Views/driver_phone_book_screen.dart)
- **ViewModel**: [driver_phone_book_view_model.dart](../../Frontend/hamal_transport_app/lib/ViewModels/driver_phone_book_view_model.dart)
- **Key Sub-widgets**:
    - `SearchBar`: For searching by name or phone.
    - `CarTypeFilter`: Filter options for vehicle types.
- **Functionality**: (Logistics only) A searchable and filterable directory of all drivers. `DriverPhoneBookViewModel` fetches the full driver list via the `AuthenticationService`.
