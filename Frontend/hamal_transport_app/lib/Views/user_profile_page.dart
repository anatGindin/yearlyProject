import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/user_profile_view_model.dart';
import '../../l10n/app_localizations.dart';
import '../Services/authentication_service.dart';
import '../Views/Authentication/login_screen_view.dart';

class UserProfilePage extends StatefulWidget {
  UserProfilePage({super.key});
  final authService = AuthenticationService();

  @override
  createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final authService = AuthenticationService();
  UserProfileViewModel? userProfileVM;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = authService.currentUser;
      if (user == null) {
        // redirect to login if not authenticated
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (_, _, _) => const LoginScreenView(),
              transitionDuration: Duration.zero,
            ),
          );
        }
        return;
      }

      final profile = await authService.getUserProfile(user);
      setState(() {
        userProfileVM = UserProfileViewModel(profile);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userProfileVM == null) {
      return const Scaffold(body: Center(child: Text("Error loading profile")));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle), centerTitle: true),
      body: Column(
        children: [
          Row(
            children: [
              Text(l10n.name),
              const Text(" : "),
              Text(userProfileVM!.name()),
            ],
          ),
          Row(
            children: [
              Text(l10n.phone),
              const Text(" : "),
              Text(userProfileVM!.phone()),
            ],
          ),
          Row(
            children: [
              Text(l10n.role),
              const Text(" : "),
              Text(userProfileVM!.role(l10n)),
              Icon(userProfileVM!.roleIcon()),
            ],
          ),
          _buildDriverInfo(context),
          const Spacer(),
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
    if (userProfileVM!.isDriver()) {
      final driverProfileVM = userProfileVM!.driverProfileVM!;
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
