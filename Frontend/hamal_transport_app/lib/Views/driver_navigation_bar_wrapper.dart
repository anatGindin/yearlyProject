import 'package:flutter/material.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';

class DriverNavigationBarWrapper extends StatefulWidget {
  const DriverNavigationBarWrapper({super.key, required this.allDestinations});
  final List<DriverDestination> allDestinations;

  @override
  State<DriverNavigationBarWrapper> createState() =>
      _DriverNavigationBarWrapperState();
}

class _DriverNavigationBarWrapperState extends State<DriverNavigationBarWrapper>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  late final List<GlobalKey<NavigatorState>> navigatorKeys;

  int navBarIndex = 0; // the nav bar option that is highlighted
  int targetIndex = 0; // the nav bar option we tap on
  int _lastActiveIndex = 0;

  @override
  void initState() {
    super.initState();

    navigatorKeys = List.generate(
      widget.allDestinations.length,
      (_) => GlobalKey<NavigatorState>(),
    );

    _tabController = TabController(
      length: widget.allDestinations.length,
      vsync: this,
    );
    _lastActiveIndex = _tabController.index;

    // handle nav bar highlighted option on swipe
    _tabController.animation!.addListener(() {
      final newIndex = _tabController.animation!.value.round();

      // swipe change of index
      if (newIndex != navBarIndex && targetIndex == navBarIndex) {
        setState(() {
          navBarIndex = newIndex;
          targetIndex = newIndex;
        });
      }
      // nav bar change of index (using targetIndex so only the right nav bar option will be highlighted)
      else if (newIndex != navBarIndex && targetIndex == newIndex) {
        setState(() {
          navBarIndex = newIndex;
        });
      }
    });

    // handle start/stop location stream on move to/from map view, only if there is a mapView
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      final newIndex = _tabController.index;
      if (newIndex == _lastActiveIndex) return;

      widget.allDestinations[_lastActiveIndex].onExit?.call();
      widget.allDestinations[newIndex].onEnter?.call();

      _lastActiveIndex = newIndex;
    });
  }

  // runs only on user tap on nav bar
  void _onTabSelected(int index) {
    if (index == _tabController.index) return;

    setState(() => targetIndex = index);

    _tabController.animateTo(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPopWithResult: (_) {
        navigatorKeys[_tabController.index].currentState?.pop();
      },
      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          physics: const BouncingScrollPhysics(),
          children: List.generate(
            widget.allDestinations.length,
            (index) => _KeepAliveNavigator(
              key: ValueKey(index),
              navigatorKey: navigatorKeys[index],
              page: widget.allDestinations[index].page,
            ),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navBarIndex,
          onDestinationSelected: _onTabSelected,
          destinations: widget.allDestinations
              .map(
                (d) => NavigationDestination(
                  icon: Icon(d.driverPageType.getIcon()),
                  label: d.driverPageType.getLabel(context),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _KeepAliveNavigator extends StatefulWidget {
  const _KeepAliveNavigator({
    super.key,
    required this.navigatorKey,
    required this.page,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final Widget page;

  @override
  State<_KeepAliveNavigator> createState() => _KeepAliveNavigatorState();
}

class _KeepAliveNavigatorState extends State<_KeepAliveNavigator>
    with AutomaticKeepAliveClientMixin<_KeepAliveNavigator> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => widget.page),
    );
  }
}

enum DriverPageType {
  missions,
  mapView,
  profile;

  String getLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case DriverPageType.missions:
        return l10n.missions;
      case DriverPageType.mapView:
        return l10n.map;
      case DriverPageType.profile:
        return l10n.profile;
    }
  }

  IconData getIcon() {
    switch (this) {
      case DriverPageType.missions:
        return Icons.list;
      case DriverPageType.mapView:
        return Icons.map;
      case DriverPageType.profile:
        return Icons.person;
    }
  }
}

class DriverDestination {
  const DriverDestination({
    required this.driverPageType,
    required this.page,
    this.onEnter,
    this.onExit,
  });

  final DriverPageType driverPageType;
  final Widget page;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;
}
