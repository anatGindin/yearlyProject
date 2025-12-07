import 'package:flutter_test/flutter_test.dart';
import 'package:hamal_transport_app/ViewModels/login_screen_view_model.dart';
import 'package:hamal_transport_app/Services/Fake/fake_authentication_service.dart';

void main() {
  late LoginScreenViewModel viewModel;
  late FakeAuthenticationService mockAuthService;

  setUp(() {
    mockAuthService = FakeAuthenticationService();
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
    mockAuthService.errorToThrow = FakeAuthenticationError.wrongPassword;

    final success = await viewModel.login('test@test.com', 'password');

    expect(success, false);
    expect(viewModel.error, FakeAuthenticationError.wrongPassword);
    expect(viewModel.isLoading, false);
  });

  test('login failure with known error', () async {
    mockAuthService.shouldThrow = true;
    mockAuthService.errorToThrow = FakeAuthenticationError.emailInvalid;

    final success = await viewModel.login('test@test.com', 'password');

    expect(success, false);
    expect(viewModel.error, FakeAuthenticationError.emailInvalid);
    expect(viewModel.isLoading, false);
  });
}
