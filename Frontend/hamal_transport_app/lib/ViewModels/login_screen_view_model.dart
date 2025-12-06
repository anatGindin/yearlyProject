import 'package:flutter/foundation.dart';
import '../Services/authentication_service.dart';

class LoginScreenViewModel extends ChangeNotifier {
  final AuthenticationService _authService;

  LoginScreenViewModel({AuthenticationService? authService})
    : _authService = authService ?? AuthenticationService();

  bool _isPasswordVisible = false;
  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthenticationError? _error;
  AuthenticationError? get error => _error;

  String? get errorMessage =>
      null; // Deprecated, kept for safety if needed, or remove? I will remove it to force View update.

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signIn(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthenticationError catch (e) {
      _error = e;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
