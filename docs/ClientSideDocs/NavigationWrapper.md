# Navigation Wrapper

The `NavigationBarWrapper` provides the primary navigation structure and ensures a consistent user experience while persisting the state of the app's various modules.

## Overview
- **Path**: [navigation_bar_wrapper.dart](../../Frontend/hamal_transport_app/lib/Views/SharedWidgets/navigation_bar_wrapper.dart)
- **Purpose**: Wraps the main application screens with a Material 3 `NavigationBar` and manages a `TabBarView` for smooth horizontal transitions.

## Features

### State Persistence (KeepAlive)
Each page in the navigation bar is wrapped in a `_KeepAliveNavigator`. This uses Flutter's `AutomaticKeepAliveClientMixin` to ensure that:
- Scroll positions are maintained when switching tabs.
- Form data or temporary UI state is not lost.
- Expensive resources (like maps) are not disposed of prematurely when the user navigates away.

### State Synchronization
The wrapper uses a `TabController` to synchronize the selection in the bottom `NavigationBar` with the visible page in the `TabBarView`. This allows for both tapping icons and swiping between screens.

### Global Navigation Control
It listens to the `MainNavigationController` (provided via [navigation_controller.dart](../../Frontend/hamal_transport_app/lib/Services/navigation_controller.dart)). This allows other parts of the app (like mission cards or the avatar button) to programmatically request a navigation change.

### Lifecycle Management
The `NavBarDestination` configuration supports `onEnter` and `onExit` callbacks. This is used, for example, to start or stop the GPS location stream only when the user is actively viewing the `MapView`.
