import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/ViewModels/login_screen_view_model.dart';
import 'package:hamal_transport_app/Services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockUserCredential extends Mock implements UserCredential {}

class MockAuthenticationService implements AuthenticationService {
  bool shouldThrow = false;
  AuthenticationError? errorToThrow;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    if (shouldThrow) {
      if (errorToThrow != null) {
        throw errorToThrow!;
      }
      throw AuthenticationError.unknown;
    }
    return MockUserCredential();
  }
}

void main() {
  late LoginScreenViewModel viewModel;
  late MockAuthenticationService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthenticationService();
    viewModel = LoginScreenViewModel(authService: mockAuthService);
  });

  test('Initial state is correct', () {
    expect(viewModel.isLoading, false);
    expect(viewModel.error, null);
    expect(viewModel.isPasswordVisible, false);
  });

  test('Toggle password visibility', () {
    expect(viewModel.isPasswordVisible, false);
    viewModel.togglePasswordVisibility();
    expect(viewModel.isPasswordVisible, true);
    viewModel.togglePasswordVisibility();
    expect(viewModel.isPasswordVisible, false);
  });

  test('login success', () async {
    final success = await viewModel.login('test@test.com', 'password');
    expect(success, true);
    expect(viewModel.error, null);
    expect(viewModel.isLoading, false);
  });

  test('login failure with specific error', () async {
    mockAuthService.shouldThrow = true;
    mockAuthService.errorToThrow = AuthenticationError.wrongPassword;

    final success = await viewModel.login('test@test.com', 'password');

    expect(success, false);
    expect(viewModel.error, AuthenticationError.wrongPassword);
    expect(viewModel.isLoading, false);
  });

  test('login failure with known error', () async {
    mockAuthService.shouldThrow = true;
    mockAuthService.errorToThrow = AuthenticationError.emailInvalid;

    final success = await viewModel.login('test@test.com', 'password');

    expect(success, false);
    expect(viewModel.error, AuthenticationError.emailInvalid);
    expect(viewModel.isLoading, false);
  });
}
