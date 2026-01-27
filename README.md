# Hamal Transportation App

A mobile logistics management application designed to streamline delivery operations for the Hamal organization, replacing the existing WhatsApp-based workflow with a comprehensive mission management system. 

[Download here]

[Download here]:https://idotalk.github.io/Hamal-landing-page/

For further details about this product, the full project's HLD can be found [here]

[here]:https://github.com/anatGindin/yearlyProject/blob/main/HLD.pdf

## Overview

This cross-platform mobile application enables efficient coordination between drivers and logistics staff through real-time location tracking, intelligent delivery assignment, and instant communication. The system emphasizes simplicity and accessibility for elderly drivers while providing powerful management tools for administrators.

## Key Features

### For Drivers
- Accept and manage delivery requests
- Navigate to destinations with Waze integration
- Update delivery status in real-time
- Receive location-based delivery notifications
- View active and upcoming missions

### For Logistics Staff & Administrators
- Deploy delivery requests to drivers
- Track driver locations in real-time
- Set delivery requirements (load capacity, vehicle type)
- Communicate directly with drivers
- Monitor delivery progress and completion

## Tech Stack

- **Frontend**: Flutter (MVVM architecture, role-based UI)
- **Backend**: Python (Django/FastAPI)
- **API**: REST API with WebSocket support for real-time features
- **Integration**: Monday.com API for mission management
- **Navigation**: Waze/Maps API integration
- **CI/CD**: GitHub Actions

## Architecture

The application follows a monolithic server-client architecture with:
- Single backend service as source of truth
- Cross-platform mobile client with role-based UI
- Real-time updates via WebSockets and push notifications
- Background workers for synchronization and data processing

## Project Status

Currently in development as part of an academic project in collaboration with Hamal's logistics department.

## License

Developed for Hamal - A non-profit logistics organization

## Installation

### Prerequisites
- Flutter SDK (version 3.38.0 or higher)
- Dart SDK (version 3.10.0 or higher)
  Python 3.10

### Setup Steps
1. Clone the repository
   ```bash
   git clone https://github.com/anatGindin/yearlyProject.git
   cd yearlyProject
   ```

2. Install Frontend dependencies
   ```bash
   cd Frontend/hamal_transport_app
   flutter pub get
   ```

3. Install Backend dependencies
   ```bash
   cd Backend
   pip install -r requirements.txt
   ```

4. Run the application
   ```bash
   flutter run
   ```

## Usage

### For Drivers
1. Log in to view available transport missions
2. Accept missions that match your vehicle type
3. Update mission status: Assigned → Picked Up → Delivered
4. Use the built-in map for navigation to pickup/delivery locations

### For Logistics Staff
1. Manage transport missions
2. Monitor mission progress and delivery status

---

*Note: This application is designed with accessibility in mind, featuring intuitive interfaces suitable for elderly drivers with options for larger fonts and simplified navigation.*
