import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// Reusable AppBar widget for mission screens
class MissionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MissionAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      title: Text(l10n.appTitle),

      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
