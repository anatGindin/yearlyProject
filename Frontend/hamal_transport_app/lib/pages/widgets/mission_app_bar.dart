import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../open_tasks_page.dart';

/// Reusable AppBar widget for mission screens
class MissionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MissionAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.appTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.list),
          tooltip: AppLocalizations.of(context)!.openTasks,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const OpenTasksPage()),
          ),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
