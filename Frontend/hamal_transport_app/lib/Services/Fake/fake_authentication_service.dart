import 'package:hamal_transport_app/Services/authentication_service.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:mockito/mockito.dart';

class FakeAuthenticationService extends Fake implements AuthenticationService {
  bool signUpCalled = false;
  bool signInCalled = false;
  String? lastEmail;
  String? lastPassword;
  String? lastName;
  String? lastPhone;
  UserRole? lastRole;

  bool shouldThrow = false;
  AuthenticationError? errorToThrow;

  // Mock user profile for testing
  UserProfile? mockUserProfile;

  @override
  UserProfile? currentUserProfile;

  @override
  Future<UserProfile> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    if (shouldThrow) {
      if (errorToThrow != null) {
        throw errorToThrow!;
      }
      throw AuthenticationError.unknown;
    }
    signInCalled = true;
    lastEmail = email;
    lastPassword = password;

    // Return mock user profile or create a default driver profile
    final profile =
        mockUserProfile ??
        UserProfile(
          uid: 'test-uid',
          email: email,
          name: 'Test User',
          phone: '1234567890',
          role: UserRole.driver,
        );
    currentUserProfile = profile;
    return profile;
  }

  @override
  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
  }) async {
    if (shouldThrow) {
      if (errorToThrow != null) {
        throw errorToThrow!;
      }
      throw AuthenticationError.unknown;
    }

    signUpCalled = true;
    lastEmail = email;
    lastPassword = password;
    lastName = name;
    lastPhone = phone;
    lastRole = role;

    final profile = UserProfile(
      uid: 'test-uid',
      email: email,
      name: name,
      phone: phone,
      role: role,
    );
    currentUserProfile = profile;
    return profile;
  }

  @override
  Future<bool> shouldAutoLogin() async {
    return currentUserProfile != null;
  }

  @override
  Future<void> signOut() async {
    currentUserProfile = null;
  }
}
