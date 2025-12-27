import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/user_profile_page.dart';
import '../../l10n/app_localizations.dart';
import '../driver_map_view.dart';
import '../new_mission_page.dart';
import '../../ViewModels/user_profile_view_model.dart';
import 'package:provider/provider.dart';

/// Reusable AppBar widget for mission screens
class MissionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MissionAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProfileVM = context.read<UserProfileViewModel>();
    return AppBar(
      title: Text(l10n.appTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.map),
          tooltip: l10n.mapView,
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const DriverMapView())),
        ),
        IconButton(
          icon: const Icon(Icons.list),
          tooltip: l10n.openTasks,
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const NewMissionPage())),
        ),
        IconButton(
          icon: const Icon(Icons.badge),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) {
                  return ChangeNotifierProvider.value(
                    value: userProfileVM,
                    child: const UserProfilePage(),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
