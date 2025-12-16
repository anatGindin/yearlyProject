import 'package:hamal_transport_app/Services/authentication_service.dart';
import 'package:hamal_transport_app/Models/user_profile.dart';
import 'package:mockito/mockito.dart';

class FakeAuthenticationService extends Mock implements AuthenticationService {
  bool signUpCalled = false;
  bool signInCalled = false;
  String? lastEmail;
  String? lastPassword;
  String? lastName;
  String? lastPhone;
  UserRole? lastRole;
  DriverProfile? lastDriverProfile;

  bool shouldThrow = false;
  AuthenticationError? errorToThrow;

  // Mock user profile for testing
  UserProfile? mockUserProfile;

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
    return profile;
  }

  @override
  Future<UserProfile> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
    DriverProfile? driverProfile,
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
    lastDriverProfile = driverProfile;

    final profile = UserProfile(
      uid: 'test-uid',
      email: email,
      name: name,
      phone: phone,
      role: role,
      driverProfile: driverProfile,
    );
    return profile;
  }

  @override
  Future<bool> shouldAutoLogin() async {
    return mockUserProfile != null;
  }

  @override
  Future<void> signOut() async {
    mockUserProfile = null;
  }
}
