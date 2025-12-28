import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../Widgets/logout_button.dart';
import '../Widgets/menu_item.dart';

class ProfileMenuView extends StatelessWidget {
  final ValueChanged<int> onNavigate;
  final AppLocalizations l10n;
  final ThemeData theme;

  const ProfileMenuView({
    super.key,
    required this.onNavigate,
    required this.l10n,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        MenuItem(
          icon: Icons.person_outline,
          title: l10n.accountInformation,
          theme: theme,
          onTap: () => onNavigate(1),
        ),
        MenuItem(
          icon: Icons.settings_outlined,
          title: l10n.appPreferences,
          theme: theme,
          onTap: () => onNavigate(3),
        ),
        const Divider(),
        const SizedBox(height: 16),
        const LogoutButton(),
      ],
    );
  }
}
