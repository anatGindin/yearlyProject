import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    if (!AuthenticationService.validatePassword(password)) {
      throw AuthenticationError.passwordInvalid;
    }
    if (!AuthenticationService.validateEmail(email)) {
      throw AuthenticationError.emailInvalid;
    }
    try {
      return await _authProvider.createUserWithEmailAndPassword(
        email: email,
        password: password,
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
    }
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final credential = await _authProvider.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await setRememberMe(rememberMe);
      return credential;
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
    await _authProvider.signOut();
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
}

enum AuthenticationError {
  passwordInvalid,
  emailInvalid,
  emailAlreadyInUse,
  networkRequestFailed,
  wrongPassword,
  unknown,
}
