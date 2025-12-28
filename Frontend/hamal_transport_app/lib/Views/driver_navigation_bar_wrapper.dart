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

class _DriverNavigationBarWrapperState extends State<DriverNavigationBarWrapper>
    with TickerProviderStateMixin {
  static const List<DriverDestination> allDestinations = [
    DriverDestination(0, DriverPageType.missions),
    DriverDestination(1, DriverPageType.mapView),
    DriverDestination(2, DriverPageType.profile),
  ];

  late final List<GlobalKey<NavigatorState>> navigatorKeys;
  late final List<AnimationController> controllers;
  late final List<Widget> destinationViews;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    navigatorKeys = List.generate(allDestinations.length, (_) => GlobalKey());

    controllers = List.generate(
      allDestinations.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    controllers[selectedIndex].value = 1.0;

    destinationViews = List.generate(
      allDestinations.length,
      (i) => _buildTabView(i, Offset.zero),
    );
  }

  Widget _buildTabView(int index, Offset beginOffset) {
    final animation = controllers[index].drive(
      Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
    );

    return SlideTransition(
      position: animation,
      child: Navigator(
        key: navigatorKeys[index],
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => allDestinations[index].driverPageType.getPage(),
        ),
      ),
    );
  }

  void _onTabSelected(int newIndex) {
    if (newIndex < 0 ||
        newIndex >= allDestinations.length ||
        newIndex == selectedIndex) {
      return;
    }

    final textDirection = Directionality.of(context);
    final isForward = newIndex > selectedIndex;
    final leading = textDirection == TextDirection.ltr ? 1.0 : -1.0;
    final beginOffset = Offset(isForward ? leading : -leading, 0);
    final previousIndex = selectedIndex;
    selectedIndex = newIndex;

    controllers[previousIndex].reverse();
    controllers[selectedIndex].reset();
    controllers[selectedIndex].forward();

    destinationViews[selectedIndex] = _buildTabView(selectedIndex, beginOffset);

    setState(() {});
  }

  void _handleSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() < 200) return; // ignore weak swipes
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    // In LTR:
    // swipe left  -> next tab
    // swipe right -> previous tab
    //
    // In RTL it's reversed
    final swipeToNext = isRtl ? velocity > 0 : velocity < 0;
    final newIndex = swipeToNext ? selectedIndex + 1 : selectedIndex - 1;
    _onTabSelected(newIndex);
  }

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPopWithResult: (_) {
        navigatorKeys[selectedIndex].currentState?.pop();
      },
      child: Scaffold(
        body: GestureDetector(
          onHorizontalDragEnd: _handleSwipe,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            fit: StackFit.expand,
            children: List.generate(allDestinations.length, (index) {
              return Offstage(
                offstage: index != selectedIndex,
                child: destinationViews[index],
              );
            }),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: _onTabSelected,
          destinations: allDestinations.map((d) {
            return NavigationDestination(
              icon: Icon(d.driverPageType.getIcon()),
              label: d.driverPageType.getLabel(context),
            );
          }).toList(),
        ),
      ),
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
