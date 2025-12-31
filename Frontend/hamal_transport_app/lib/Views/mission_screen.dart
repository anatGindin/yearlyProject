import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/mission_view_model.dart';
import 'package:hamal_transport_app/ViewModels/missions_coordinator_view_model.dart';
import 'package:hamal_transport_app/ViewModels/available_missions_view_model.dart';
import 'package:hamal_transport_app/Views/Widgets/comments_list_view.dart';
import 'package:hamal_transport_app/Views/Widgets/source_destination.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Models/mission.dart';
import '../Models/missions_model.dart';
import '../l10n/app_localizations.dart';
import '../features/Contact_card/view/contact_view.dart';
import '../features/Contact_card/view_model/contact_vm.dart';
import '../Services/routing_service.dart';
import '../Views/Widgets/info_row.dart';

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
        body: Consumer<MissionViewModel>(
          builder: (context, missionVM, _) {
            missionsCoordinator.setMissionVM(missionVM);
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const BackButton(),
                    _buildRouteInfo(missionVM),
                    const SizedBox(height: 16),
                    InfoRow(
                      icon: Icons.star_rounded,
                      label: l10n.status,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(missionVM.status().displayName(context)),
                          _statusUpdater(missionVM),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    InfoRow(
                      icon: Icons.person,
                      label: l10n.sourceContact,
                      child: ContactInfoActionable(vm: sourceContactVM),
                    ),
                    const SizedBox(height: 16),
                    InfoRow(
                      icon: Icons.person,
                      label: l10n.destinationContact,
                      child: ContactInfoActionable(vm: destinationContactVM),
                    ),
                    const SizedBox(height: 16),
                    InfoRow(
                      icon: Icons.alarm,
                      label: l10n.time,
                      child: Text(
                        DateFormat.yMEd(
                          l10n.localeName,
                        ).format(missionVM.time()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InfoRow(
                      icon: Icons.directions_car,
                      label: l10n.carType,
                      child: Text(
                        missionVM.carType().displayName(l10n),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    MissionCommentsTile(missionViewModel: missionVM),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showStatusOptions() {
    final mission = widget.mission;
    final currentStatus = mission.status;
    // TODO: move the "next status" list options to the view model (?)
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

  void _showSuggestedMissionsDialog() async {
    final availableMissionsVM = context.read<AvailableMissionsViewModel>();
    final allMissions = availableMissionsVM.availableMissions;

    if (allMissions.isEmpty) return;

    // Get top 3 suggested missions using heuristic scoring
    final suggestedMissions = await MissionsListsModel.getTopSuggestedMissions(
      allMissions,
      maxResults: 3,
    );

    // Guard context after async operation
    if (!mounted) return;

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.suggestedMissions),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 420),
            child: SizedBox(
              width: double.maxFinite,
              child: suggestedMissions.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(l10n.noMissions, textAlign: TextAlign.center),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.suggestedMissionsMessage,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.builder(
                            itemCount: suggestedMissions.length,
                            itemBuilder: (context, index) {
                              final mission = suggestedMissions[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Text(
                                    '${mission.source.name} → ${mission.destination.name}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    mission.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: const Icon(Icons.arrow_forward),
                                  onTap: () {
                                    Navigator.of(dialogContext).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            MissionScreen(mission: mission),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRouteInfo(MissionViewModel missionVM) {
    final mission = missionVM.mission;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Align(
      alignment: Alignment.centerRight,
      child: FutureBuilder<RouteInfo?>(
        future: mission.getRouteInfo(profile: 'car'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Card(
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.calculatingRoute,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            final route = snapshot.data!;
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: SourceDestination(mission: mission),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withAlpha(50),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      route.formattedDistance,
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.straighten,
                                      color: colorScheme.onPrimaryContainer,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      route.formattedDuration,
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.access_time,
                                      color: colorScheme.onPrimaryContainer,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            if (missionVM.status() == MissionStatus.chosen ||
                                missionVM.status() == MissionStatus.pickedUp)
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final success = await missionVM
                                      .launchNavigation();
                                  // Guard the context we are about to use
                                  if (!context.mounted) return;
                                  if (!success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.cannotLaunchNavigation,
                                        ),
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
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _statusUpdater(MissionViewModel missionVM) {
    final mission = missionVM.mission;
    final missionsCoordinator = context.read<MissionsCoordinatorViewModel>();

    if (!missionsCoordinator.isAvailable(mission)) {
      return ElevatedButton.icon(
        onPressed: (missionVM.status() == MissionStatus.delivered)
            ? null
            : () => _showStatusOptions(),
        icon: const Icon(Icons.update),
        label: Text(
          l10n.updateStatus,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(4),
          elevation: 3,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );
    } else {
      return SizedBox(
        child: ElevatedButton(
          onPressed: () {
            missionsCoordinator.takeMission(mission);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.missionTaken)));
            _showSuggestedMissionsDialog();
          },

          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(4),
            elevation: 3,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          child: Text(
            l10n.takeMission,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
