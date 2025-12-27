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
    with TickerProviderStateMixin<DriverNavigationBarWrapper> {
  static const List<DriverDestination> allDestinations = <DriverDestination>[
    DriverDestination(0, DriverPageType.missions),
    DriverDestination(1, DriverPageType.mapView),
    DriverDestination(2, DriverPageType.profile),
  ];

  late final List<GlobalKey<NavigatorState>> navigatorKeys;
  late final List<AnimationController> destinationFaders;
  late final List<Widget> destinationViews;

  int selectedIndex = 0;

  AnimationController buildFaderController() {
    return AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addStatusListener((status) {
      if (status.isDismissed) setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    navigatorKeys = List.generate(
      allDestinations.length,
      (_) => GlobalKey<NavigatorState>(),
    );

    destinationFaders = List.generate(
      allDestinations.length,
      (_) => buildFaderController(),
    );
    destinationFaders[selectedIndex].value = 1.0;

    final tween = CurveTween(curve: Curves.fastOutSlowIn);

    destinationViews = allDestinations.map((destination) {
      return FadeTransition(
        opacity: destinationFaders[destination.index].drive(tween),
        child: Navigator(
          key: navigatorKeys[destination.index],
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => destination.driverPageType.getPage(),
            );
          },
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (final c in destinationFaders) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPopWithResult: (result) {
        navigatorKeys[selectedIndex].currentState!.pop();
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: allDestinations.map((destination) {
            final index = destination.index;
            final view = destinationViews[index];

            if (index == selectedIndex) {
              destinationFaders[index].forward();
              return Offstage(offstage: false, child: view);
            } else {
              destinationFaders[index].reverse();
              if (destinationFaders[index].isAnimating) {
                return IgnorePointer(child: view);
              }
              return Offstage(child: view);
            }
          }).toList(),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            setState(() => selectedIndex = index);
          },
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
