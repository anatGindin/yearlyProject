import 'package:flutter/material.dart';
import '../../Services/authentication_service.dart';
import '../main_page.dart';
import 'login_screen_view.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Future<bool>? _autoLoginFuture;
  final AuthenticationService _authService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    _autoLoginFuture = _authService.shouldAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _autoLoginFuture,
      builder: (context, snapshot) {
        // While waiting for the async check (shared prefs + auth state)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Error or explicit false result
        if (snapshot.hasError || snapshot.data == false) {
          return const LoginScreenView();
        }

        // Success - User is logged in and remember me is valid
        return const MainPage();
      },
    );
  }
}
