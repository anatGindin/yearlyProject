# Environment Setup

This document explains how to set up your development environment for the Hamal Transport App.

## Prerequisites

To develop for this project, you need to have the following installed:

1.  **Flutter SDK**: The core framework for the mobile application.
    -   Download from: [flutter.dev](https://docs.flutter.dev/get-started/install)
    -   Why: Cross-platform mobile development.
2.  **Dart SDK**: (Included with Flutter).
    -   Why: Programming language for the app.
3.  **Visual Studio Code** or **Android Studio**: Recommended IDEs.
    -   Install Flutter and Dart plugins.
4.  **Firebase CLI**: For managing Firebase services.
    -   Download from: [firebase.google.com](https://firebase.google.com/docs/cli)
    -   Why: Authentication, Database, and Hosting.

## Getting Started

1.  **Clone the repository**:
    ```bash
    git clone <repository_url>
    ```
2.  **Install dependencies**:
    Navigate to [Frontend/hamal_transport_app](../Frontend/hamal_transport_app) and run:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    Connect a device or start an emulator and run:
    ```bash
    flutter run
    ```

## Core Frameworks & Libraries

-   **Provider**: Used for state management across the app.
-   **Firebase Core/Auth/Database**: Provides backend services for authentication and real-time data.
-   **Flex Color Scheme**: for advanced material theming.
-   **Geolocator & Flutter Map**: Used for location tracking and map visualization.
-   **Intl**: For localization support.
-   **HTTP**: For making network requests to external services (like OSRM and our Backend).
