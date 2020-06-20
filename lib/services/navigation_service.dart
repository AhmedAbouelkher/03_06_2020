import 'package:flutter/material.dart';
import 'package:haftaa/ui/BottomNavigationBar.dart';
import 'package:haftaa/ui/LoginOrSignup/ChoseLoginOrSignup.dart';
import 'package:haftaa/ui/LoginOrSignup/Login.dart';
import 'package:haftaa/ui/OnBoarding.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
     _navigationKey.currentState.pop();
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToPageRoute(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        .push(PageRouteBuilder(pageBuilder: (_, __, ___) => new loginScreen()));
  }
}
