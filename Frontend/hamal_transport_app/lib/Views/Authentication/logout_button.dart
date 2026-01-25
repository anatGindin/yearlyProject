import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/Authentication/auth_gate.dart';
import '../../ViewModels/user_profile_view_model.dart';
import '../../l10n/app_localizations.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return FilledButton.icon(
      onPressed: () {
        context.read<UserProfileViewModel>().logOut();
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthGate()),
          (route) => false, // This predicate removes all previous routes
        );
      },
      icon: const Icon(Icons.logout),
      label: Text(l10n.logout),
      //TODO: get from theme
      style: FilledButton.styleFrom(
        minimumSize: const Size(200, 50),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
