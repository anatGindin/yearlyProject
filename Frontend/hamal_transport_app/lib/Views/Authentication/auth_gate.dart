import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/user_profile_view_model.dart';
import 'package:provider/provider.dart';
import '../../Services/authentication_service.dart';
import 'package:hamal_transport_app/Services/missions_repository.dart';
import 'package:hamal_transport_app/Constants/mock_data.dart';
import 'role_based_routing.dart';
import 'login_screen_view.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Future<Widget>? _destinationFuture;

  @override
  void initState() {
    super.initState();
    final authService = context.read<AuthenticationService>();
    _destinationFuture = _determineDestination(authService);
  }

  Future<Widget> _determineDestination(
    AuthenticationService authService,
  ) async {
    final shouldAutoLogin = await authService.shouldAutoLogin();
    if (!shouldAutoLogin) {
      return const LoginScreenView();
    }

    // User is logged in, fetch their profile and route based on role
    final userProfile = await authService.getUserProfile(
      authService.currentUser!,
    );

    // Initialize/Refetch missions
    MissionsRepository().setMissions([
      ...sampleMissions,
      ...availableMissions,
      ...adminMissions,
    ]);

    return ChangeNotifierProvider(
      create: (_) => UserProfileViewModel(userProfile),
      child: getDestinationForRole(userProfile.role),
    );
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
