import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/mission.dart';
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
            tooltip: 'משימות פתוחות',
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
                    'משימות פעילות ומתוכננות',
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
                  label: const Text('משימות זמינות', style: TextStyle(fontSize: 16)),
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
      builder: (context) => AlertDialog(
        title: const Text('התקשר לדסק המשלוחים'),
        content: const Text('התקשר לדסק המשלוחים במספר +1-800-555-1234'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('סגור')),
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
      return const Center(child: Text('אין משימות'));
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
                Text('איש קשר: ${m.contact}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18), textAlign: TextAlign.right),
                const SizedBox(height: 8),
                Text('מועד: ${_formatDateTime(m.time)}', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16), textAlign: TextAlign.right),
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
