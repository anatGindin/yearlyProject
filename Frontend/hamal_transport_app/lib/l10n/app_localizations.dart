import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_he.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('he'),
  ];

  /// App title shown in the app bar and for the application title
  ///
  /// In en, this message translates to:
  /// **'Hamal Transport'**
  String get appTitle;

  /// Label above the counter that explains what the number means
  ///
  /// In en, this message translates to:
  /// **'You have pushed the button this many times:'**
  String get counterText;

  /// Tooltip for the floating action button that increments the counter
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get incrementTooltip;

  /// Button to open available tasks
  ///
  /// In en, this message translates to:
  /// **'Open Tasks'**
  String get openTasks;

  /// Title of active missions list
  ///
  /// In en, this message translates to:
  /// **'Active and Upcoming Missions'**
  String get activeMissions;

  /// Title of available missions page
  ///
  /// In en, this message translates to:
  /// **'Available Missions'**
  String get availableMissions;

  /// Title of call desk dialog
  ///
  /// In en, this message translates to:
  /// **'Call Hamal'**
  String get callDesk;

  /// Message in call desk dialog
  ///
  /// In en, this message translates to:
  /// **'Call Hamal'**
  String get callDeskMessage;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Message when there are no missions
  ///
  /// In en, this message translates to:
  /// **'No missions'**
  String get noMissions;

  /// Contact label
  ///
  /// In en, this message translates to:
  /// **'Contact: '**
  String get contact;

  /// Time label
  ///
  /// In en, this message translates to:
  /// **'Time: '**
  String get time;

  /// Mission page title
  ///
  /// In en, this message translates to:
  /// **'Mission'**
  String get mission;

  /// Update status button
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get updateStatus;

  /// Navigate in Waze button
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigateWaze;

  /// Take mission button
  ///
  /// In en, this message translates to:
  /// **'Take Mission'**
  String get takeMission;

  /// Title for suggested missions dialog
  ///
  /// In en, this message translates to:
  /// **'Suggested Missions'**
  String get suggestedMissions;

  /// Helper text shown in the suggested missions dialog above the list
  ///
  /// In en, this message translates to:
  /// **'Based on your mission, here are some other missions you may be able to take:'**
  String get suggestedMissionsMessage;

  /// Subtitle for mission selection dialog
  ///
  /// In en, this message translates to:
  /// **'Select a mission to view details'**
  String get selectMission;

  /// Select status menu title
  ///
  /// In en, this message translates to:
  /// **'Select Status'**
  String get selectStatus;

  /// Mission status - chosen
  ///
  /// In en, this message translates to:
  /// **'Chosen'**
  String get chosen;

  /// Mission status - picked up
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get pickedUp;

  /// Mission status - delivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// Mission status - cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Mission status - available
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// Status update message
  ///
  /// In en, this message translates to:
  /// **'Status updated to: '**
  String get statusUpdated;

  /// Message when mission is taken
  ///
  /// In en, this message translates to:
  /// **'Mission taken'**
  String get missionTaken;

  /// Error message when navigation app cannot be launched
  ///
  /// In en, this message translates to:
  /// **'Cannot launch navigation app'**
  String get cannotLaunchNavigation;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Sign Up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// Email input label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password input label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Forgot password button text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// Reset password dialog title
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Generic login error message
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginError;

  /// Generic sign up error message
  ///
  /// In en, this message translates to:
  /// **'Sign up failed'**
  String get signupError;

  /// Text prompting user to sign up
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Text prompting user to login
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Full Name input label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get name;

  /// Phone Number input label
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// Confirm Password input label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Error when passwords don't match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// Helper text for password rules
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least 6 characters, one uppercase, one lowercase, and one number.'**
  String get passwordRules;

  /// Message shown when signup is successful
  ///
  /// In en, this message translates to:
  /// **'Signup Successful! Please Login.'**
  String get signupSuccess;

  /// Error message for empty required fields
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// Error message for invalid phone number format
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Israeli phone number.'**
  String get invalidPhone;

  /// Error message for invalid email format
  ///
  /// In en, this message translates to:
  /// **'The email address is not valid.'**
  String get invalidEmail;

  /// Error message when user does not exist
  ///
  /// In en, this message translates to:
  /// **'No user found for that email.'**
  String get userNotFound;

  /// Error message for incorrect password
  ///
  /// In en, this message translates to:
  /// **'Email address or password is incorrect'**
  String get wrongPassword;

  /// Fallback error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get genericError;

  /// Error message when email is already registered
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get emailAlreadyInUse;

  /// Label for remember me checkbox
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Label for role selection dropdown
  ///
  /// In en, this message translates to:
  /// **'Select your role'**
  String get selectRole;

  /// Title for role
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// Driver role option
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get driver;

  /// Logistics team role option
  ///
  /// In en, this message translates to:
  /// **'Logistics Team'**
  String get logistics;

  /// Admin role option
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// Validation error when role is not selected
  ///
  /// In en, this message translates to:
  /// **'Please select a role'**
  String get roleRequired;

  /// Title for under construction page
  ///
  /// In en, this message translates to:
  /// **'Under Construction'**
  String get underConstruction;

  /// Message on under construction page
  ///
  /// In en, this message translates to:
  /// **'This feature is coming soon!'**
  String get underConstructionMessage;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Title for user profile page
  ///
  /// In en, this message translates to:
  /// **'Profile Page'**
  String get profileTitle;

  /// Sort By button text
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortBy;

  /// Filter button text
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterBy;

  /// Sort option - Distance: closest to furthest
  ///
  /// In en, this message translates to:
  /// **'Closest firsts'**
  String get closestToFurthest;

  /// Sort option - Distance: Furthest to closest
  ///
  /// In en, this message translates to:
  /// **'Furthest first'**
  String get furthestToClosest;

  /// Sort option - Time: Newest to oldest
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get newestToOldest;

  /// Sort option - Time: Oldest to newest
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get oldestToNewest;

  /// Filter option - Show all missions
  ///
  /// In en, this message translates to:
  /// **'All missions'**
  String get noFilter;

  /// Filter option - Show 'Chosen' missions
  ///
  /// In en, this message translates to:
  /// **'Chosen'**
  String get menuChosenFilter;

  /// Show 'Picked up' missions
  ///
  /// In en, this message translates to:
  /// **'Picked up'**
  String get menuPickedUpFilter;

  /// Filter option - Show 'Chosen' missions
  ///
  /// In en, this message translates to:
  /// **'\'Chosen\' missions'**
  String get chosenFilter;

  /// Show 'Picked up' missions
  ///
  /// In en, this message translates to:
  /// **'\'Picked up\' missions'**
  String get pickedUpFilter;

  /// Title for cancellation reason dialog
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason'**
  String get cancellationReason;

  /// Hint text for cancellation reason input
  ///
  /// In en, this message translates to:
  /// **'Please enter the reason for cancellation'**
  String get enterCancellationReason;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Source contact label
  ///
  /// In en, this message translates to:
  /// **'Source contact'**
  String get sourceContact;

  /// Destination contact label
  ///
  /// In en, this message translates to:
  /// **'Destination contact'**
  String get destinationContact;

  /// My comments label
  ///
  /// In en, this message translates to:
  /// **'My comments'**
  String get comments;

  /// Message when there are no comments
  ///
  /// In en, this message translates to:
  /// **'There are no comments'**
  String get noComments;

  /// Add comment button text
  ///
  /// In en, this message translates to:
  /// **'Add comment'**
  String get addComment;

  /// Hint text for Add comment input
  ///
  /// In en, this message translates to:
  /// **'Enter comment'**
  String get enterComment;

  /// Delete comment label
  ///
  /// In en, this message translates to:
  /// **'Delete comment'**
  String get deleteComment;

  /// Delete comment message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this comment?'**
  String get deleteCommentConfirmation;

  /// Label for car type selection
  ///
  /// In en, this message translates to:
  /// **'Car Type'**
  String get carType;

  /// Validation error for car type
  ///
  /// In en, this message translates to:
  /// **'Please select a car type'**
  String get carTypeRequired;

  /// Car type - Private
  ///
  /// In en, this message translates to:
  /// **'Private Car'**
  String get privateCar;

  /// Car type - Trailer
  ///
  /// In en, this message translates to:
  /// **'Trailer'**
  String get trailer;

  /// Car type - Pickup Truck
  ///
  /// In en, this message translates to:
  /// **'Pickup Truck'**
  String get pickupTruck;

  /// Car type - Truck
  ///
  /// In en, this message translates to:
  /// **'Truck'**
  String get truck;

  /// Label for confirm email field
  ///
  /// In en, this message translates to:
  /// **'Confirm Email'**
  String get confirmEmail;

  /// Error message when emails do not match
  ///
  /// In en, this message translates to:
  /// **'Emails do not match'**
  String get emailMismatch;

  /// Message displayed while calculating route
  ///
  /// In en, this message translates to:
  /// **'Calculating route...'**
  String get calculatingRoute;

  /// Notice text on forgot password screen explaining what will happen
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get resetPasswordNotice;

  /// Success message when password reset email is sent
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent! Check your inbox.'**
  String get passwordResetSent;

  /// Button or title for Map View
  ///
  /// In en, this message translates to:
  /// **'Map View'**
  String get mapView;

  /// Label for status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Title for map legend
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get legend;

  /// Title for map layers/filters
  ///
  /// In en, this message translates to:
  /// **'Layers'**
  String get layers;

  /// Tooltip for center map button
  ///
  /// In en, this message translates to:
  /// **'My Location'**
  String get center;

  /// Label of Missions option in the driver navigation bar
  ///
  /// In en, this message translates to:
  /// **'Missions'**
  String get missions;

  /// Label of Map option in the driver navigation bar
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// Label of Profile option in the driver navigation bar
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @hamalWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Hamal Warehouse'**
  String get hamalWarehouse;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// Edit Your Profile
  ///
  /// In en, this message translates to:
  /// **'Edit Your Profile'**
  String get edit;

  /// Save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Title for app preferences page
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get appPreferences;

  /// Label for dark mode toggle
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Label for language selection
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Hebrew language option
  ///
  /// In en, this message translates to:
  /// **'Hebrew'**
  String get hebrew;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @helpFaq.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpFaq;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'he'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'he':
      return AppLocalizationsHe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
