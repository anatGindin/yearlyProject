import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../Constants/official_info.dart';
import '../../Utils/launcher_utils.dart';
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
        const SizedBox(height: 3),
        const Divider(),
        _QuickActionsCard(l10n: l10n, theme: theme),

        const SizedBox(height: 12),
        const LogoutButton(),
      ],
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  final AppLocalizations l10n;
  final ThemeData theme;

  const _QuickActionsCard({required this.l10n, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    _ActionButton(
                      icon: Icons.phone_in_talk_outlined,
                      label: l10n.callDesk,
                      onTap: () => LauncherUtils.callPhoneNumber(hamalPhone),
                      theme: theme,
                    ),
                    _ActionButton(
                      icon: Icons.mail_outline,
                      label: l10n.contactUs,
                      onTap: () => LauncherUtils.launchEmail(hamalEmail),
                      theme: theme,
                    ),
                  ],
                ),
                Column(
                  children: [
                    _ActionButton(
                      icon: Icons.info_outline,
                      label: l10n.aboutUs,
                      onTap: () => LauncherUtils.launchBrowser(hamalVisionUrl),
                      theme: theme,
                    ),
                    _ActionButton(
                      icon: Icons.help_outline,
                      label: l10n.helpFaq,
                      onTap: () {}, // Future use
                      theme: theme,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ThemeData theme;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 24,
                textDirection: TextDirection.ltr,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
