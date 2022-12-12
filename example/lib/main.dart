/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:ui';

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/routing/on_generate_route.dart';
import 'package:appdynamics_agent_example/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = Instrumentation.errorHandler;
  PlatformDispatcher.instance.onError = (error, stack) {
    final details = FlutterErrorDetails(exception: error, stack: stack);
    Instrumentation.errorHandler(details);
    return true;
  };
  runApp(ChangeNotifierProvider(
      create: (context) => AppState(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: RoutePaths.settings,
        onGenerateRoute: onGenerateRoute,
        navigatorObservers: [NavigationObserver()]);
  }
}
