import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:hamal_transport_app/Services/authentication_service.dart';
import 'package:mockito/mockito.dart';

class MockUserCredential extends Mock implements auth.UserCredential {}

class FakeAuthenticationService extends Fake implements AuthenticationService {
  bool signUpCalled = false;
  String? lastEmail;
  String? lastPassword;

  bool shouldThrow = false;
  FakeAuthenticationError? errorToThrow;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<auth.UserCredential> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    if (shouldThrow) {
      if (errorToThrow != null) {
        throw errorToThrow!;
      }
      throw FakeAuthenticationError.unknown;
    }
    return MockUserCredential();
  }

  @override
  Future<auth.UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    if (shouldThrow) {
      if (errorToThrow != null) {
        throw errorToThrow!;
      }
      throw FakeAuthenticationError.unknown;
    }

    signUpCalled = true;
    lastEmail = email;
    lastPassword = password;
    return MockUserCredential();
  }
}

enum FakeAuthenticationError {
  passwordInvalid,
  emailInvalid,
  emailAlreadyInUse,
  networkRequestFailed,
  wrongPassword,
  unknown,
}
