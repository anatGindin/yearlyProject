import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../Widgets/logout_button.dart';
import '../Widgets/menu_item.dart';

class ProfileMenuView extends StatelessWidget {
  final PageController pageController;
  final AppLocalizations l10n;
  final ThemeData theme;

  const ProfileMenuView({
    super.key,
    required this.pageController,
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
          onTap: () {
            pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
        ),
        const Divider(),
        const SizedBox(height: 16),
        const LogoutButton(),
      ],
    );
  }
}
