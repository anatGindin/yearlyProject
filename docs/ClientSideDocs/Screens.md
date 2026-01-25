# Screens

This document describes the key screens in the Hamal Transport App, their sub-widgets, and how their respective ViewModels handle logic.

## Map View
- **File**: [map_view.dart](../../Frontend/hamal_transport_app/lib/Views/Map/map_view.dart)
- **ViewModel**: [map_view_model.dart](../../Frontend/hamal_transport_app/lib/ViewModels/map_view_model.dart)
- **Functionality**: Displays the user's location and mission markers. `MapViewModel` handles permissions, location streaming, and marker logic.

## User Profile Page
- **File**: [user_profile_page.dart](../../Frontend/hamal_transport_app/lib/Views/UserMenu/user_profile_page.dart)
- **ViewModel**: [user_profile_view_model.dart](../../Frontend/hamal_transport_app/lib/ViewModels/user_profile_view_model.dart)    
- **Functionality**: Displays and allows editing of user profile data. `UserProfileViewModel` interacts with `AuthenticationService` for updates and logouts.

## Missions Tabs Page
- **File**: [missions_tabs_page.dart](../../Frontend/hamal_transport_app/lib/Views/MissionsList/missions_tabs_page.dart)
- **ViewModel**: [missions_list_view_model.dart](../../Frontend/hamal_transport_app/lib/ViewModels/missions_list_view_model.dart)
- **Functionality**: A container for multiple tabs of mission lists. It uses a `TabBar` and `TabBarView`.
- **Tabs Explained**:
    - **My Missions**: Missions currently assigned to the logged-in driver.
    - **Available**: Missions that anyone can pick up.
    - **Assigned/Picked Up/Delivered/Cancelled**: (Logistics only) Category-specific lists for monitoring the fleet.

## Drivers Phonebook
- **File**: [driver_phone_book_screen.dart](../../Frontend/hamal_transport_app/lib/Views/DriversPhonebook/driver_phone_book_screen.dart)
- **ViewModel**: [driver_phone_book_view_model.dart](../../Frontend/hamal_transport_app/lib/ViewModels/driver_phone_book_view_model.dart)
- **Functionality**: (Logistics only) A searchable and filterable directory of all drivers. `DriverPhoneBookViewModel` fetches the full driver list via the `AuthenticationService`.
