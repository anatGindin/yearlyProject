import 'package:flutter/material.dart';
import 'package:hamal_transport_app/Services/navigation_controller.dart';
import 'package:provider/provider.dart';

class NavigationBarWrapper extends StatefulWidget {
  const NavigationBarWrapper({super.key, required this.allDestinations});

  final List<NavBarDestination> allDestinations;

  @override
  State<NavigationBarWrapper> createState() => _NavigationBarWrapperState();
}

class _NavigationBarWrapperState extends State<NavigationBarWrapper>
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

    // Listen to global navigation requests
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MainNavigationController>().addListener(
        _handleNavigationRequest,
      );
    });
  }

  void _handleNavigationRequest() {
    if (!mounted) return;
    final controller = context.read<MainNavigationController>();
    final requestedType = controller.requestedPageType;

    if (requestedType != null) {
      final index = widget.allDestinations.indexWhere(
        (d) => d.pageType == requestedType,
      );
      if (index != -1) {
        _onTabSelected(index);
      }
      controller.consumeRequest();
    }
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
                  icon: Icon(d.pageType.getIcon()),
                  label: d.pageType.getLabel(context),
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

class NavBarDestination {
  const NavBarDestination({
    required this.pageType,
    required this.page,
    this.onEnter,
    this.onExit,
  });

  final NavBarPageType pageType;
  final Widget page;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;
}
