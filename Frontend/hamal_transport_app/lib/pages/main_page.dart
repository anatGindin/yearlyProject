import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/mission.dart';
import '../constants/mock_data.dart';
import 'mission_screen.dart';
import 'new_mission_page.dart';
import 'open_tasks_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: AppLocalizations.of(context)!.openTasks,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const OpenTasksPage())),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.activeMissions,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),
                  // Expanded mission list
                  Expanded(
                    child: _MissionList(
                      missions: sampleMissions,
                    ),
                  ),
                  const SizedBox(height: 72), // spacing to keep list above buttons
                ],
              ),

              // Bottom-left phone button
              Positioned(
                left: 8,
                bottom: 12,
                child: FloatingActionButton(
                  heroTag: 'phone',
                  onPressed: () => _callHamalDesk(context),
                  child: const Icon(Icons.phone),
                ),
              ),

              // Bottom-right new mission button
              Positioned(
                right: 8,
                bottom: 12,
                child: FloatingActionButton.extended(
                  heroTag: 'new_mission',
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NewMissionPage())),
                  icon: const Icon(Icons.add_box),
                  label: Text(AppLocalizations.of(context)!.availableMissions, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _callHamalDesk(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.callDesk),
        content: Text(AppLocalizations.of(context)!.callDeskMessage),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(AppLocalizations.of(context)!.close)),
        ],
      ),
    );
  }
}

class _MissionList extends StatelessWidget {
  final List<Mission> missions;
  const _MissionList({required this.missions});

  @override
  Widget build(BuildContext context) {
    if (missions.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noMissions));
    }
    return ListView.separated(
      itemCount: missions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final m = missions[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            title: Text(
              m.location,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
              textAlign: TextAlign.right,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(m.description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18), textAlign: TextAlign.right),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.contact}${m.contact}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18), textAlign: TextAlign.right),
                const SizedBox(height: 8),
                Text('${AppLocalizations.of(context)!.time}${_formatDateTime(m.time)}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16), textAlign: TextAlign.right),
              ],
            ),
            isThreeLine: true,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => MissionScreen(mission: m))),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
