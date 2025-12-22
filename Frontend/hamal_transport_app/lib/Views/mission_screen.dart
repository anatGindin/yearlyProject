import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/mission_view_model.dart';
import 'package:hamal_transport_app/ViewModels/missions_coordinator_view_model.dart';
import 'package:hamal_transport_app/Views/Widgets/comments_list_view.dart';
import 'package:provider/provider.dart';
import '../Models/mission.dart';
import '../l10n/app_localizations.dart';
import '../features/Contact_card/view/contact_view.dart';
import '../features/Contact_card/view_model/contact_vm.dart';

class MissionScreen extends StatefulWidget {
  final Mission mission;
  const MissionScreen({required this.mission, super.key});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  late AppLocalizations l10n;

  @override
  void initState() {
    super.initState();
  }

  void _updateStatus(MissionStatus newStatus) {
    final mission = widget.mission;
    final missionCoordinator = context.read<MissionsCoordinatorViewModel>();
    missionCoordinator.updateStatus(mission, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    l10n = AppLocalizations.of(context)!;
    final mission = widget.mission;
    final missionsCoordinator = context.read<MissionsCoordinatorViewModel>();
    final sourceContactVM = ContactViewModel(mission.sourceContact);
    final destinationContactVM = ContactViewModel(mission.destinationContact);
    return ChangeNotifierProvider(
      create: (context) => MissionViewModel(mission),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.mission)),
        body: Consumer<MissionViewModel>(
          builder: (context, missionVM, _) {
            missionsCoordinator.setMissionVM(missionVM);
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              missionVM.location(),
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(fontSize: 24),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              missionVM.description(),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${l10n.carType}: ${missionVM.carType().displayName(l10n)}',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${l10n.sourceContact}:',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(fontSize: 16),
                          ),
                          ContactCardActionable(vm: sourceContactVM),
                          const SizedBox(height: 16),
                          Text(
                            '${l10n.destinationContact}:',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(fontSize: 16),
                          ),
                          ContactCardActionable(vm: destinationContactVM),
                          const SizedBox(height: 16),
                          Text(
                            '${l10n.time}${missionVM.time()}',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${l10n.mission}: ${missionVM.status().displayName(context)}',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 12),
                          const SizedBox(height: 16),
                          MissionCommentsTile(missionViewModel: missionVM),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Only show update status button for chosen missions (not available)
                    if (!missionsCoordinator.isAvailable(mission))
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              (missionVM.status() == MissionStatus.delivered)
                              ? null
                              : () => _showStatusOptions(),
                          icon: const Icon(Icons.update),
                          label: Text(
                            l10n.updateStatus,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(64),
                          ),
                        ),
                      ),
                    // Only show navigate button for chosen and picked up missions
                    if (missionVM.status() == MissionStatus.chosen ||
                        missionVM.status() == MissionStatus.pickedUp)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final success = await missionVM.launchNavigation();
                            // Guard the context we are about to use
                            if (!context.mounted) return;
                            if (!success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.cannotLaunchNavigation),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(64),
                          ),
                          icon: const Icon(Icons.navigation),
                          label: Text(
                            l10n.navigateWaze,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
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
                          SnackBar(content: Text(l10n.missionTaken)),
                        );
                      },
                      icon: const Icon(Icons.check),
                      label: Text(
                        l10n.takeMission,
                        style: const TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showStatusOptions() {
    final mission = widget.mission;
    final currentStatus = mission.status;

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(title: Text(l10n.selectStatus)),
            // Show "Picked Up" option only for chosen missions
            if (currentStatus == MissionStatus.chosen)
              ListTile(
                title: Text(l10n.pickedUp),
                onTap: () {
                  Navigator.of(context).pop();
                  _updateStatus(MissionStatus.pickedUp);
                },
              ),
            // Show "Delivered" option only for picked up missions
            if (currentStatus == MissionStatus.pickedUp)
              ListTile(
                title: Text(l10n.delivered),
                onTap: () {
                  Navigator.of(context).pop();
                  _updateStatus(MissionStatus.delivered);
                  // Navigate back to main page after delivery
                  Navigator.of(context).pop();
                },
              ),
            // Show "Cancelled" option for both chosen and picked up missions
            if (currentStatus == MissionStatus.chosen ||
                currentStatus == MissionStatus.pickedUp)
              ListTile(
                title: Text(l10n.cancelled),
                onTap: () {
                  Navigator.of(context).pop();
                  _showCancellationReasonDialog();
                },
              ),
          ],
        );
      },
    );
  }

  void _showCancellationReasonDialog() {
    String cancellationReason = '';
    final missionCoordinator = context.read<MissionsCoordinatorViewModel>();
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.cancellationReason),
          content: TextField(
            maxLines: 3,
            onChanged: (value) {
              cancellationReason = value;
            },
            decoration: InputDecoration(
              hintText: l10n.enterCancellationReason,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                missionCoordinator.cancelMission(cancellationReason);
                // Navigate back to main page after cancellation
                Navigator.of(context).pop();
              },
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );
  }
}
