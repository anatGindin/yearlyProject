import 'package:flutter/material.dart';
import 'package:hamal_transport_app/ViewModels/missions_list_view_model.dart';
import 'package:hamal_transport_app/Views/missions_list_body.dart';
import 'package:provider/provider.dart';

class MissionTabConfig {
  final String title;
  final IconData icon;
  final MissionsListViewModel viewModel;
  final Color color;

  MissionTabConfig({
    required this.title,
    required this.icon,
    required this.viewModel,
    this.color = Colors.transparent,
  });
}

class MissionsTabsPage extends StatefulWidget {
  final List<MissionTabConfig> tabs;

  const MissionsTabsPage({super.key, required this.tabs});

  @override
  State<MissionsTabsPage> createState() => _MissionsTabsPageState();
}

class _MissionsTabsPageState extends State<MissionsTabsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: widget.tabs.length, vsync: this);
    _controller.addListener(() {
      if (mounted) setState(() {}); // rebuild on tab change
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme
        .of(context)
        .colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Missions')),
      body: Column(
        children: [
          TabBar(
            controller: _controller,
            // ⭐ explicit
            isScrollable: false,
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            indicator: const BoxDecoration(),
            tabs: List.generate(widget.tabs.length, (index) {
              final tab = widget.tabs[index];
              final selected = _controller.index == index;
              final Color base = tab.color != Colors.transparent
                  ? tab.color
                  : scheme.surfaceContainerHighest;
              return SizedBox(
                height: 54,
                child: Container(
                  color: selected ? base.withAlpha(180) : base.withAlpha(20),
                  child: SizedBox.expand(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(tab.icon, size: 20),
                        const SizedBox(height: 2),
                        Text(
                          tab.title,
                          textAlign: TextAlign.center,
                          style: Theme
                              .of(
                            context,
                          )
                              .textTheme
                              .labelSmall!
                              .copyWith(fontSize: 8),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),

          Expanded(
            child: TabBarView(
              controller: _controller, // ⭐ same controller
              children: widget.tabs
                  .map(
                    (tab) =>
                    ChangeNotifierProvider.value(
                      value: tab.viewModel,
                      child: const MissionsListBody(),
                    ),
              )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
