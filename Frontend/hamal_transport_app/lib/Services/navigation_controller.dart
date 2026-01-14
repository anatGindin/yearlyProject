import 'package:flutter/material.dart';
import '../Views/navigation_bar_wrapper.dart';

class MainNavigationController extends ChangeNotifier {
  NavBarPageType? _requestedPageType;

  NavBarPageType? get requestedPageType => _requestedPageType;

  void navigateTo(NavBarPageType type) {
    _requestedPageType = type;
    notifyListeners();
  }

  void consumeRequest() {
    _requestedPageType = null;
  }
}
