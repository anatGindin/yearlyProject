import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';

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

  // Initialize Firebase
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
  }) async {
    try {
      return await _authProvider.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
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
