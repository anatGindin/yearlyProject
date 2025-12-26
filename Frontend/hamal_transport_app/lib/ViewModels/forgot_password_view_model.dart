import 'package:flutter/foundation.dart';
import '../Services/authentication_service.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthenticationService _authService;

  ForgotPasswordViewModel({AuthenticationService? authService})
    : _authService = authService ?? AuthenticationService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthenticationError? _error;
  AuthenticationError? get error => _error;

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;

  // Validation
  bool isEmailValid(String email) => AuthenticationService.validateEmail(email);

  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    _isSuccess = false;
    notifyListeners();

    try {
      await _authService.resetPassword(email);
      _isLoading = false;
      _isSuccess = true;
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

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearSuccess() {
    _isSuccess = false;
    notifyListeners();
  }
}
