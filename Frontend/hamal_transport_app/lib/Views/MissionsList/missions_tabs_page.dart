import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/missions_list_view_model.dart';
import 'package:hamal_transport_app/Views/SharedWidgets/main_app_bar.dart';
import 'package:hamal_transport_app/Views/MissionsList/missions_list_body.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../../Models/mission.dart';
import '../../../Models/mission_list_type.dart';

class MissionTabConfig {
  final String title;
  final IconData icon;
  final MissionsListViewModel viewModel;

  MissionTabConfig({
    required this.title,
    required this.icon,
    required this.viewModel,
  });
}

class MissionsTabsPage extends StatefulWidget {
  final List<MissionTabConfig> tabs;

  const MissionsTabsPage({super.key, required this.tabs});

  @override
  State<MissionsTabsPage> createState() => _MissionsTabsPageState();
}

class _MissionsTabsPageState extends State<MissionsTabsPage> {
  bool _canScrollStart = false;
  bool _canScrollEnd = false;
  final scrollBarArrowAlpha = 100;
  final scrollBarArrowBackgroundAlpha = 50;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textDirection = Directionality.of(context);

    return DefaultTabController(
      length: widget.tabs.length,
      child: Scaffold(
        appBar: MainAppBar(title: l10n.missions),
        body: Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.primary,
              child: Stack(
                children: [
                  NotificationListener<Notification>(
                    onNotification: (notification) {
                      ScrollMetrics? metrics;

                      if (notification is ScrollNotification &&
                          notification.depth == 0) {
                        metrics = notification.metrics;
                      } else if (notification is ScrollMetricsNotification &&
                          notification.depth == 0) {
                        metrics = notification.metrics;
                      }

                      if (metrics != null && metrics.axis == Axis.horizontal) {
                        final maxScroll = metrics.maxScrollExtent;
                        final pixels = metrics.pixels;
                        final canScrollStart =
                            maxScroll > 0 &&
                            pixels > metrics.minScrollExtent + 1;
                        final canScrollEnd =
                            maxScroll > 0 && pixels < maxScroll - 1;

                        if (canScrollStart != _canScrollStart ||
                            canScrollEnd != _canScrollEnd) {
                          if (notification is ScrollMetricsNotification) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {
                                  _canScrollStart = canScrollStart;
                                  _canScrollEnd = canScrollEnd;
                                });
                              }
                            });
                          } else {
                            setState(() {
                              _canScrollStart = canScrollStart;
                              _canScrollEnd = canScrollEnd;
                            });
                          }
                        }
                      }
                      return false;
                    },
                    child: TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.center,
                      labelColor: Theme.of(context).colorScheme.onPrimary,
                      unselectedLabelColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary.withAlpha(180),
                      indicatorColor: Colors.grey,
                      tabs: widget.tabs.map((tab) {
                        final color = _getStatusColor(tab.viewModel.type);
                        return Tab(
                          icon: Icon(tab.icon),
                          child: Container(
                            decoration: color != null
                                ? BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: color,
                                        width: 3.0,
                                      ),
                                    ),
                                  )
                                : null,
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Text(
                              tab.title,
                              softWrap: true,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  // Start Scroll Hint (Back)
                  if (_canScrollStart)
                    Positioned.directional(
                      textDirection: textDirection,
                      start: 0,
                      top: 0,
                      bottom: 0,
                      width: 40,
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: AlignmentDirectional.centerStart,
                              end: AlignmentDirectional.centerEnd,
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.primary.withAlpha(
                                  scrollBarArrowBackgroundAlpha,
                                ),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 16,
                            color: Theme.of(context).colorScheme.onPrimary
                                .withAlpha(scrollBarArrowAlpha),
                          ),
                        ),
                      ),
                    ),
                  // End Scroll Hint (Forward)
                  if (_canScrollEnd)
                    Positioned.directional(
                      textDirection: textDirection,
                      end: 0,
                      top: 0,
                      bottom: 0,
                      width: 40,
                      child: IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: AlignmentDirectional.centerStart,
                              end: AlignmentDirectional.centerEnd,
                              colors: [
                                Theme.of(context).colorScheme.primary.withAlpha(
                                  scrollBarArrowBackgroundAlpha,
                                ),
                                Theme.of(context).colorScheme.primary,
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Theme.of(context).colorScheme.onPrimary
                                .withAlpha(scrollBarArrowAlpha),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: widget.tabs
                    .map(
                      (tab) =>
                          ChangeNotifierProvider<MissionsListViewModel>.value(
                            value: tab.viewModel,
                            child: const MissionsListBody(),
                          ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color? _getStatusColor(MissionListType type) {
    switch (type) {
      case MissionListType.availableMissions:
        return MissionStatus.available.statusColor;
      case MissionListType.assignedMissions:
      case MissionListType.myMissions:
        return MissionStatus.assigned.statusColor;
      case MissionListType.pickedUpMissions:
        return MissionStatus.pickedUp.statusColor;
      case MissionListType.deliveredMissions:
        return MissionStatus.delivered.statusColor;
      case MissionListType.cancelledMissions:
        return MissionStatus.cancelled.statusColor;
      default:
        return null;
    }
  }
}
