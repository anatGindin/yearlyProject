import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Views/driver_map_view.dart';
import 'package:hamal_transport_app/Views/main_page.dart';
import 'package:hamal_transport_app/Views/user_profile_page.dart';
import 'package:hamal_transport_app/l10n/app_localizations.dart';

class DriverNavigationBarWrapper extends StatefulWidget {
  const DriverNavigationBarWrapper({super.key});

  @override
  State<DriverNavigationBarWrapper> createState() =>
      _DriverNavigationBarWrapperState();
}

class _DriverNavigationBarWrapperState
    extends State<DriverNavigationBarWrapper> {
  static const List<DriverDestination> allDestinations = [
    DriverDestination(0, DriverPageType.missions),
    DriverDestination(1, DriverPageType.mapView),
    DriverDestination(2, DriverPageType.profile),
  ];

  final List<GlobalKey<NavigatorState>> navigatorKeys = List.generate(
    allDestinations.length,
    (_) => GlobalKey(),
  );

  final PageController _pageController = PageController();

  int selectedIndex = 0;

  void _onTabSelected(int index) {
    if (index == selectedIndex) return;
    setState(() => selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPopWithResult: (_) {
        navigatorKeys[selectedIndex].currentState?.pop();
      },
      child: Scaffold(
        body: PageView.builder(
          controller: _pageController,
          physics: const BouncingScrollPhysics(),
          onPageChanged: (index) => setState(() => selectedIndex = index),
          itemCount: allDestinations.length,
          itemBuilder: (context, index) {
            return _KeepAliveNavigator(
              key: ValueKey(index),
              navigatorKey: navigatorKeys[index],
              page: allDestinations[index].driverPageType.getPage(),
            );
          },
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: _onTabSelected,
          destinations: allDestinations
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

// Keeps each Navigator alive to preserve stack
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

  Widget getPage() {
    switch (this) {
      case DriverPageType.missions:
        return const MainPage();
      case DriverPageType.mapView:
        return const DriverMapView();
      case DriverPageType.profile:
        return const UserProfilePage();
    }
  }

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
  const DriverDestination(this.index, this.driverPageType);

  final int index;
  final DriverPageType driverPageType;
}
