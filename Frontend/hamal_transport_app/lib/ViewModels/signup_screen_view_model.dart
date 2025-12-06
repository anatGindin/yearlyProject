import 'package:flutter/foundation.dart';
import '../Services/authentication_service.dart';

class SignupScreenViewModel extends ChangeNotifier {
  final AuthenticationService _authService;

  SignupScreenViewModel({AuthenticationService? authService})
    : _authService = authService ?? AuthenticationService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthenticationError? _error;
  AuthenticationError? get error => _error;

  String? get errorMessage => null; // Deprecated

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  bool _isConfirmPasswordVisible = false;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  // Validation getters
  bool isPasswordValid(String password) =>
      AuthenticationService.validatePassword(password);
  bool isEmailValid(String email) => AuthenticationService.validateEmail(email);

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  Future<bool> signup({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signUp(email: email, password: password);
      // NOTE: In a real app we would update the user profile with name/phone here

      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthenticationError catch (e) {
      _error = e;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = AuthenticationError.unknown;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
