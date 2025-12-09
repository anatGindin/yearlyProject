import 'package:flutter/material.dart';
import '../../Services/authentication_service.dart';
import '../role_based_routing.dart';
import 'login_screen_view.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Future<Widget>? _destinationFuture;
  final AuthenticationService _authService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    _destinationFuture = _determineDestination();
  }

  Future<Widget> _determineDestination() async {
    final shouldAutoLogin = await _authService.shouldAutoLogin();
    if (!shouldAutoLogin) {
      return const LoginScreenView();
    }

    // User is logged in, fetch their profile and route based on role
    final userProfile = _authService.currentUserProfile;
    if (userProfile == null) {
      return const LoginScreenView();
    }

    return getDestinationForRole(userProfile.role);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _destinationFuture,
      builder: (context, snapshot) {
        // While waiting for the async check (shared prefs + auth state)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Error case - go to login
        if (snapshot.hasError || !snapshot.hasData) {
          return const LoginScreenView();
        }

        // Success - return the determined destination
        return snapshot.data!;
      },
    );
  }
}
