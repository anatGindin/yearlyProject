import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
const String _kRememberMeKey = 'remember_me';

class AuthenticationService {
  // Singelton setup
  static final AuthenticationService _instance =
      AuthenticationService._internal();

  factory AuthenticationService() {
    return _instance;
  }

  AuthenticationService._internal();

  // Current session information
  final _authProvider = FirebaseAuth.instance;

  User? get currentUser => _authProvider.currentUser;

  Stream<User?> get authStateChanges => _authProvider.authStateChanges();
  UserProfile? _currentUserProfile;

  UserProfile? get currentUserProfile => _currentUserProfile;

  // Database
  final DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');

  // AppCheck
  final _appCheck = FirebaseAppCheck.instance;
  Future<String?> getAppCheckToken() async {
    try {
      // false tells the SDK to pull from the internal cache if it's still valid
      final String? appCheckToken = await _appCheck.getToken(true);
      return appCheckToken;
    } catch (e) {
      print("Error fetching App Check token: $e");
      return null;
    }
  }


  // Persistance
  Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kRememberMeKey, value);
  }

  Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kRememberMeKey) ?? false; // Default to false
  }

  /// Checks if the user should be automatically logged in.
  /// Returns true if valid session exists AND remember me is enabled.
  Future<bool> shouldAutoLogin() async {
    final user = currentUser;
    if (user == null) {
      return false;
    }
    final rememberMe = await getRememberMe();
    if (!rememberMe) {
      // If remember me is false, we shouldn't auto login, so we sign out just in case
      // (Though usually we rely on just routing to login screen)
      await signOut();
      return false;
    }
    return true;
  }

  // Intentions
  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
    DriverProfile? driverProfile,
  }) async {
    if (!AuthenticationService.validatePassword(password)) {
      throw AuthenticationError.passwordInvalid;
    }
    if (!AuthenticationService.validateEmail(email)) {
      throw AuthenticationError.emailInvalid;
    }
    try {
      await _authProvider.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _postUserProfile(
        _authProvider.currentUser!,
        name,
        phone,
        role,
        driverProfile,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthenticationError.emailInvalid;
        case 'email-already-in-use':
          throw AuthenticationError.emailAlreadyInUse;
        case 'network-request-failed':
          throw AuthenticationError.networkRequestFailed;
        default:
          throw AuthenticationError.unknown;
      }
    } on Exception catch (_) {
      throw AuthenticationError.unknown;
    }
  }

  Future<UserProfile> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      await _authProvider.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await setRememberMe(rememberMe);
      return await getUserProfile(_authProvider.currentUser!);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw AuthenticationError.emailInvalid;
        case 'user-not-found':
          throw AuthenticationError.emailInvalid;
        case 'wrong-password':
          throw AuthenticationError.wrongPassword;
        case 'network-request-failed':
          throw AuthenticationError.networkRequestFailed;
        default:
          throw AuthenticationError.unknown;
      }
    }
  }

  Future<void> signOut() async {
    await setRememberMe(false); // Clear remember me on explicit sign out
    _currentUserProfile = null;
    await _authProvider.signOut();
  }

  Future<UserProfile> _postUserProfile(
    User user,
    String name,
    String phone,
    UserRole role,
    DriverProfile? driverProfile,
  ) async {
    try {
      final userProfile = UserProfile(
        uid: user.uid,
        email: user.email!,
        name: name,
        phone: phone,
        role: role,
        driverProfile: driverProfile,
      );
      await usersRef.child(user.uid).set(userProfile.userProfileToDictionary());
      return userProfile;
    } catch (e) {
      throw AuthenticationError.databaseError;
    }
  }

  Future<UserProfile> getUserProfile(User user) async {
    if (_currentUserProfile != null) {
      return _currentUserProfile!;
    }
    try {
      final snapshot = await usersRef.child(user.uid).get();
      if (snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        final profile = UserProfile.fromDictionary(data);
        _currentUserProfile = profile;
        return profile;
      }
      throw AuthenticationError.databaseError;
    } catch (e) {
      throw AuthenticationError.databaseError;
    }
  }

  Future<UserProfile?> getUserProfileByUid(String uid) async {
    try {
      final snapshot = await usersRef.child(uid).get();

      if (snapshot.value == null) {
        return null;
      }
      if (snapshot.value is! Map) {
        return null;
      }
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final profile = UserProfile.fromDictionary(data);
      return profile;
    } catch (e) {
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      if (!validateEmail(email)) {
        throw AuthenticationError.emailInvalid;
      }
      await _authProvider.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw AuthenticationError.unknown;
    }
  }

  // Static util methods for UI validation
  static bool validatePassword(String password) {
    int checksPassed = 0;
    if (password.length >= 6) {
      checksPassed++;
    }
    if (password.contains(RegExp(r'[A-Z]'))) {
      checksPassed++;
    }
    if (password.contains(RegExp(r'[a-z]'))) {
      checksPassed++;
    }
    if (password.contains(RegExp(r'[0-9]'))) {
      checksPassed++;
    }
    return checksPassed == 4;
  }

  static bool validateEmail(String email) {
    return email.contains(
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
    );
  }

  static bool validateIsraeliPhone(String phone) {
    // Basic regex for Israeli mobile: 05X-XXXXXXX or 05XXXXXXXX
    // Or international: +972 5X-XXXXXXX or +9725XXXXXXXX
    return RegExp(r'^(?:05|(?:\+972)?5)\d-?\d{7}$').hasMatch(phone);
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await usersRef
          .child(profile.uid)
          .update(profile.userProfileToDictionary());
    } catch (e) {
      throw AuthenticationError.databaseError;
    }
    {
      _currentUserProfile = profile;
    }
  }

  Future<List<UserProfile>> getAllDrivers() async {
    try {
      final snapshot = await usersRef
          .orderByChild('role')
          .equalTo(UserRole.driver.name)
          .get();

      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final Map<dynamic, dynamic> values =
          snapshot.value as Map<dynamic, dynamic>;
      List<UserProfile> drivers = [];

      values.forEach((key, value) {
        if (value is Map) {
          final userMap = Map<String, dynamic>.from(value);
          userMap['uid'] = key;
          drivers.add(UserProfile.fromDictionary(userMap));
        }
      });

      return drivers;
    } catch (e) {
      print("Database Error: $e");
      throw AuthenticationError.databaseError;
    }
  }
}

enum AuthenticationError {
  passwordInvalid,
  emailInvalid,
  emailAlreadyInUse,
  networkRequestFailed,
  wrongPassword,
  unknown,
  databaseError,
  userNotFound,
}
