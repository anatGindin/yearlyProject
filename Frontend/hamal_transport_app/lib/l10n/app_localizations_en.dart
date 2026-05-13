// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hamal Transport';

  @override
  String get activeMissions => 'My Missions';

  @override
  String get availableMissions => 'Available';

  @override
  String get pickedUpMissions => 'Picked Up Missions';

  @override
  String get readyForPickUpMissions => 'Assigned';

  @override
  String get deliveredMissions => 'Delivered Missions';

  @override
  String get cancelledMissions => 'Cancelled Missions';

  @override
  String get callDesk => 'Call Hamal';

  @override
  String get close => 'Close';

  @override
  String get noMissions => 'No missions';

  @override
  String get contact => 'Contact: ';

  @override
  String get time => 'Time: ';

  @override
  String get mission => 'Mission';

  @override
  String get updateStatus => 'Update Status';

  @override
  String get navigateWaze => 'Navigate';

  @override
  String get takeMission => 'Take Mission';

  @override
  String get suggestedMissions => 'Suggested Missions';

  @override
  String get suggestedMissionsMessage =>
      'Based on your mission, here are some other missions you may be able to take:';

  @override
  String get km => 'km';

  @override
  String get selectMission => 'Select a mission to view details';

  @override
  String get selectStatus => 'Select Status';

  @override
  String get chosen => 'Chosen';

  @override
  String get pickedUp => 'Picked up';

  @override
  String get delivered => 'Delivered';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get available => 'Available';

  @override
  String get missionTaken => 'Mission taken';

  @override
  String get cannotLaunchNavigation => 'Cannot launch navigation app';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get signupError => 'Sign up failed';

  @override
  String get name => 'Full Name';

  @override
  String get phone => 'Phone Number';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get passwordRules =>
      'Password must contain at least 6 characters, one uppercase, one lowercase, and one number.';

  @override
  String get signupSuccess => 'Signup Successful! Please Login.';

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidPhone => 'Please enter a valid Israeli phone number.';

  @override
  String get invalidEmail => 'The email address is not valid.';

  @override
  String get wrongPassword => 'Email address or password is incorrect';

  @override
  String get genericError => 'Something went wrong.';

  @override
  String get emailAlreadyInUse => 'This email is already in use.';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get role => 'Role';

  @override
  String get driver => 'Driver';

  @override
  String get logistics => 'Logistics Team';

  @override
  String get admin => 'Admin';

  @override
  String get underConstruction => 'Under Construction';

  @override
  String get underConstructionMessage => 'This feature is coming soon!';

  @override
  String get logout => 'Logout';

  @override
  String get sortBy => 'Sort';

  @override
  String get filterBy => 'Filter';

  @override
  String get closestToFurthest => 'Shortest Driving Distance';

  @override
  String get distanceFromYouClosest => 'Distance from you - closest first';

  @override
  String get furthestToClosest => 'Longest Driving Distance';

  @override
  String get distanceFromYouFurthest => 'Distance from you - furthest first';

  @override
  String get newestToOldest => 'Newest first';

  @override
  String get oldestToNewest => 'Oldest first';

  @override
  String get noFilter => 'All missions';

  @override
  String get menuChosenFilter => 'Chosen';

  @override
  String get menuPickedUpFilter => 'Picked up';

  @override
  String get cancellationReason => 'Cancellation Reason';

  @override
  String get enterCancellationReason =>
      'Please enter the reason for cancellation';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get sourceContact => 'Source contact';

  @override
  String get destinationContact => 'Destination contact';

  @override
  String get comments => 'Comments';

  @override
  String get addComment => 'Add comment';

  @override
  String get enterComment => 'Enter comment';

  @override
  String get deleteComment => 'Delete comment';

  @override
  String get deleteCommentConfirmation =>
      'Are you sure you want to delete this comment?';

  @override
  String get editComment => 'Edit Comment';

  @override
  String get editCommentTitle => 'Edit Comment';

  @override
  String get editMission => 'Edit mission';

  @override
  String get noDriverAssigned => 'No Driver Assigned';

  @override
  String get carType => 'Car Type';

  @override
  String get carTypeRequired => 'Please select a car type';

  @override
  String get privateCar => 'Private Car';

  @override
  String get trailer => 'Trailer';

  @override
  String get pickupTruck => 'Pickup Truck';

  @override
  String get truck => 'Truck';

  @override
  String get confirmEmail => 'Confirm Email';

  @override
  String get emailMismatch => 'Emails do not match';

  @override
  String get calculatingRoute => 'Calculating route...';

  @override
  String get calculateRoute => 'Calculate route';

  @override
  String get resetPasswordNotice =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get passwordResetSent =>
      'Password reset email sent! Check your inbox.';

  @override
  String get drivers => 'Drivers';

  @override
  String get searchDriver => 'Search driver';

  @override
  String get noDrivers => 'No drivers found';

  @override
  String get allCarTypes => 'Show all car types';

  @override
  String get privateOnly => 'Show only private car drivers';

  @override
  String get pickupOnly => 'Show only pickup car drivers';

  @override
  String get trailerOnly => 'Show only trailer car drivers';

  @override
  String get truckOnly => 'Show only truck drivers';

  @override
  String get mapView => 'Map View';

  @override
  String get status => 'Status';

  @override
  String get legend => 'Legend';

  @override
  String get layers => 'Layers';

  @override
  String get center => 'My Location';

  @override
  String get missions => 'Missions';

  @override
  String get map => 'Map';

  @override
  String get profile => 'Profile';

  @override
  String get driverList => 'Driver List';

  @override
  String get hamalWarehouse => 'Hamal Warehouse';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get edit => 'Edit Your Profile';

  @override
  String get save => 'Save';

  @override
  String get appPreferences => 'App Preferences';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get hebrew => 'Hebrew';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get aboutUs => 'About Us';

  @override
  String get helpFaq => 'Help & FAQ';

  @override
  String get driverPage => 'Driver Page';

  @override
  String get source => 'Source';

  @override
  String get destination => 'Destination';

  @override
  String additionOf(String distance, String unit) {
    return 'addition of $distance $unit';
  }

  @override
  String get routeSuggestion => 'Route Suggestion';

  @override
  String driveToAndPickup(String address) {
    return 'Drive to $address and pickup the following packages:';
  }

  @override
  String goToAndDeliver(String address, String missionName) {
    return 'Go to $address and deliver $missionName';
  }

  @override
  String goToAndPickup(String address, String missionName) {
    return 'Go to $address and pickup $missionName';
  }

  @override
  String headToTasks(String address) {
    return 'Head to $address for the following tasks:';
  }

  @override
  String get actionPickup => 'Pickup';

  @override
  String get actionDeliver => 'Deliver';

  @override
  String get districts => 'Destination District';

  @override
  String get districtNorth => 'North';

  @override
  String get districtCenter => 'Center';

  @override
  String get districtJerusalem => 'Jerusalem';

  @override
  String get districtSouth => 'South';
}
