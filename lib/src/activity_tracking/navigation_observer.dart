/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../appdynamics_agent.dart';

/// A class used to detect screen transitions in apps using named routes
/// automatically.
///
/// Add the [NavigationObserver] instance to the app's entry (usually in
/// main.dart)
///
/// If you need more granular control, use [WidgetTracker].
///
/// ```dart
/// import 'package:appdynamics_agent/appdynamics_agent.dart';
/// import 'package:flutter/cupertino.dart';
/// import 'package:flutter/material.dart';
///
/// void main() {
///   runApp(const MyApp());
/// }
///
/// class MyApp extends StatelessWidget {
///   const MyApp({Key? key}) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///         initialRoute: MyRoutes.mainScreen,
///         onGenerateRoute: MyRouter.onGenerateRoute,
///         navigatorObservers: [NavigationObserver()]);
///   }
/// }
/// ```
class NavigationObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  Future<void> didPush(
      Route<dynamic> route, Route<dynamic>? previousRoute) async {
    super.didPush(route, previousRoute);

    final name = route.settings.name;
    if (name != null) {
      await WidgetTracker.instance.trackWidgetStart(name);
    }
  }

  @override
  Future<void> didReplace(
      {Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) async {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    final newRouteName = newRoute?.settings.name;
    if (newRouteName != null) {
      WidgetTracker.instance.trackWidgetStart(newRouteName);
    }

    final oldRouteName = oldRoute?.settings.name;
    if (oldRouteName != null) {
      WidgetTracker.instance.trackWidgetEnd(oldRouteName);
    }
  }

  @override
  Future<void> didPop(
      Route<dynamic> route, Route<dynamic>? previousRoute) async {
    super.didPop(route, previousRoute);

    final name = route.settings.name;
    if (name != null) {
      await WidgetTracker.instance.trackWidgetEnd(name);
    }
  }
}
