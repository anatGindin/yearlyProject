import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/mission_view_model.dart';
import 'package:hamal_transport_app/ViewModels/missions_coordinator_view_model.dart';
import 'package:provider/provider.dart';
import '../Models/mission.dart';
import '../l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class MissionScreen extends StatefulWidget {
  final Mission mission;
  const MissionScreen({required this.mission, super.key});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchWaze(String address) async {
    final wazeUri = Uri.parse('waze://?q=${Uri.encodeComponent(address)}');
    if (await canLaunchUrl(wazeUri)) {
      await launchUrl(wazeUri);
      return;
    }
    final googleUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}',
    );
    if (await canLaunchUrl(googleUri)) {
      await launchUrl(googleUri);
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.cannotLaunchNavigation),
      ),
    );
  }

  void _updateStatus(String newStatus) {
    final mission = widget.mission;
    final missionsCoordinator = context.read<MissionsCoordinatorViewModel>();
    missionsCoordinator.updateStatus(mission, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    final mission = widget.mission;
    final missionsCoordinator = context.read<MissionsCoordinatorViewModel>();
    return ChangeNotifierProvider(
      create: (context) => MissionViewModel(mission),
      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.mission)),
        body: Consumer<MissionViewModel>(
          builder: (context, missionVM, _) {
            missionsCoordinator.setMissionVM(missionVM);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    missionVM.location(),
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(fontSize: 24),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    missionVM.description(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: 18),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${AppLocalizations.of(context)!.contact}${missionVM.contact()}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: 18),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${AppLocalizations.of(context)!.time}${missionVM.time()}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: 16),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${AppLocalizations.of(context)!.mission}: ${_statusLabel(missionVM.status())}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontSize: 18),
                    textAlign: TextAlign.right,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showStatusOptions(),
                        icon: const Icon(Icons.update),
                        label: Text(
                          AppLocalizations.of(context)!.updateStatus,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _launchWaze(mission.location),
                        icon: const Icon(Icons.navigation),
                        label: Text(
                          AppLocalizations.of(context)!.navigateWaze,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Show Take button when this mission is available
                  if (missionsCoordinator.isAvailable(mission))
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          missionsCoordinator.takeMission(mission);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.missionTaken,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.check),
                        label: Text(
                          AppLocalizations.of(context)!.takeMission,
                          style: const TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showStatusOptions() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(title: Text(AppLocalizations.of(context)!.selectStatus)),
            ListTile(
              title: Text(AppLocalizations.of(context)!.chosen),
              onTap: () {
                Navigator.of(context).pop();
                _updateStatus('chosen');
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.pickedUp),
              onTap: () {
                Navigator.of(context).pop();
                _updateStatus('picked_up');
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.delivered),
              onTap: () {
                Navigator.of(context).pop();
                _updateStatus('delivered');
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.cancelled),
              onTap: () {
                Navigator.of(context).pop();
                _updateStatus('cancelled');
              },
            ),
          ],
        );
      },
    );
  }

  // Map internal status codes to Hebrew labels for display
  String _statusLabel(String code) {
    switch (code) {
      case 'chosen':
        return AppLocalizations.of(context)!.chosen;
      case 'picked_up':
        return AppLocalizations.of(context)!.pickedUp;
      case 'delivered':
        return AppLocalizations.of(context)!.delivered;
      case 'cancelled':
        return AppLocalizations.of(context)!.cancelled;
      case 'available':
        return AppLocalizations.of(context)!.available;
      default:
        return code;
    }
  }
}
