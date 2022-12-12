```dart
/*
* Copyright (c) 2022. AppDynamics LLC and its affiliates.
* All rights reserved.
*
*/

/// Complete example with all Flutter agent's features.

import 'dart:async';

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/routing/on_generate_route.dart';
import 'package:appdynamics_agent_example/routing/route_paths.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = Instrumentation.errorHandler;
  PlatformDispatcher.instance.onError = (error, stack) {
    final details = FlutterErrorDetails(exception: error, stack: stack);
    Instrumentation.errorHandler(details);
    return true;
  };
  
  crashReportCallback(List<CrashReportSummary> summaries) async {
    // ... handle crash reports
  }

  AgentConfiguration config = AgentConfiguration(
      appKey: "<EUM_APP_KEY>",
      loggingLevel: LoggingLevel.verbose,
      collectorURL: "https://www.<collector-url>.com",
      screenshotURL: "https://www.<screenshots-url>.com",
      crashReportCallback: crashReportCallback,
      screenshotsEnabled: true,
      crashReportingEnabled: true
  );
  await Instrumentation.start(config);
  runApp(const MyApp());
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
```