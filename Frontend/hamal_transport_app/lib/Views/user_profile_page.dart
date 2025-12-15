import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/user_profile_view_model.dart';
import '../../l10n/app_localizations.dart';
import '../Services/authentication_service.dart';
import '../Views/Authentication/login_screen_view.dart';

class UserProfilePage extends StatelessWidget {
  final UserProfileViewModel userProfileVM;
  UserProfilePage({required this.userProfileVM, super.key});
  final authService = AuthenticationService();
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle), centerTitle: true),
      body: Column(
        children: [
          Row(
            children: [
              Text(l10n.name),
              const Text(" : "),
              Text(userProfileVM.name()),
            ],
          ),
          Row(
            children: [
              Text(l10n.phone),
              const Text(" : "),
              Text(userProfileVM.phone()),
            ],
          ),
          Row(
            children: [
              Text(l10n.role),
              const Text(" : "),
              Text(userProfileVM.role(l10n)),
              Icon(userProfileVM.roleIcon()),
            ],
          ),
          _buildDriverInfo(context),
          Spacer(),
          FilledButton.icon(
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const LoginScreenView(),
                    transitionDuration: Duration.zero,
                  ),
                );
              }
            },
            icon: const Icon(Icons.logout),
            label: Text(l10n.logout),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF364678),
              foregroundColor: Colors.white,
              minimumSize: const Size(200, 50),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDriverInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (userProfileVM.isDriver()) {
      final driverProfileVM = userProfileVM.driverProfileVM!;
      return Row(
        children: [
          Text(l10n.carType),
          const Text(" : "),
          Text(driverProfileVM.carType(l10n)),
          Icon(driverProfileVM.carTypeIcon()),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
