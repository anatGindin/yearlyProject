import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/ViewModels/signup_screen_view_model.dart';
import 'package:hamal_transport_app/Services/Fake/fake_authentication_service.dart';

void main() {
  late SignupScreenViewModel viewModel;
  late FakeAuthenticationService fakeAuthService;

  setUp(() {
    fakeAuthService = FakeAuthenticationService();
    viewModel = SignupScreenViewModel(authService: fakeAuthService);
  });

  group('SignupScreenViewModel Tests', () {
    test('Initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.error, null);
      expect(viewModel.isPasswordVisible, false);
      expect(viewModel.isConfirmPasswordVisible, false);
    });

    test('Validation Logic', () {
      // Email
      expect(viewModel.isEmailValid('test@test.com'), true);
      expect(viewModel.isEmailValid('invalid-email'), false);

      // Password (min 6 chars, 1 upper, 1 lower, 1 number)
      expect(viewModel.isPasswordValid('Pass123'), true);
      expect(viewModel.isPasswordValid('weak'), false);
    });

    test('Signup Success calls service', () async {
      final success = await viewModel.signup(
        email: 'test@test.com',
        password: 'Pass123',
        name: 'Test User',
        phone: '1234567890',
      );

      expect(success, true);
      expect(viewModel.error, null);
      expect(fakeAuthService.signUpCalled, true);
      expect(fakeAuthService.lastEmail, 'test@test.com');
      expect(fakeAuthService.lastPassword, 'Pass123');
    });

    test('Signup Failure sets error', () async {
      fakeAuthService.shouldThrow = true;
      fakeAuthService.errorToThrow = FakeAuthenticationError.emailAlreadyInUse;

      final success = await viewModel.signup(
        email: 'test@test.com',
        password: 'Pass123',
        name: 'Test User',
        phone: '1234567890',
      );

      expect(success, false);
      expect(viewModel.error, FakeAuthenticationError.emailAlreadyInUse);
      expect(fakeAuthService.signUpCalled, false);
    });
  });
}
