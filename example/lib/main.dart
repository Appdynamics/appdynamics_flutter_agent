/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:async';

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk_example/routing/on_generate_route.dart';
import 'package:appdynamics_mobilesdk_example/routing/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state/app_state.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = Instrumentation.errorHandler;
    runApp(ChangeNotifierProvider(
        create: (context) => AppState(), child: const MyApp()));
  }, (Object error, StackTrace stack) async {
    final details =
        FlutterErrorDetails(exception: error.toString(), stack: stack);
    await Instrumentation.errorHandler(details);
  });
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
