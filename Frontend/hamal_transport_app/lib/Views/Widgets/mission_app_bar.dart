import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/user_profile_page.dart';
import '../../Services/authentication_service.dart';
import '../../ViewModels/user_profile_view_model.dart';
import '../../l10n/app_localizations.dart';
import '../new_mission_page.dart';

/// Reusable AppBar widget for mission screens
class MissionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MissionAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(l10n.appTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.list),
          tooltip: l10n.openTasks,
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const NewMissionPage())),
        ),
        IconButton(
          icon: const Icon(Icons.badge),
          onPressed: () async {
            final auth = AuthenticationService();
            final user = auth.currentUser;

            if (user == null) {
              // not logged in → route to login or ignore
              return;
            }

            final profile = await auth.getUserProfile(user);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => UserProfilePage(
                  userProfileVM: UserProfileViewModel(profile),
                ),
              ),
            );
          },
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
