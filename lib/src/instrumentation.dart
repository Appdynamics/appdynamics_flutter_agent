/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/src/agent-configuration.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'globals.dart';

/// Interact with the AppDynamics agent running in your application.
///
/// This class provides a number of methods to interact with the AppDynamics
/// agent including:
///
/// - Initializing the agent with the right application key.
/// - Reporting timers.
class Instrumentation {
  /// Initializing the agent
  /// The agent does not automatically start with your application. Using the app
  /// key shown in your controller UI, you can initialize the agent.
  /// This has to be done near your application's entry point before any other
  /// initialization routines in your application.
  ///
  /// Once initialized, further calls to {@link start} have no effect on the
  /// agent.
  ///
  /// **Example**
  ///
  /// ```dart
  /// AgentConfiguration config = AgentConfiguration(
  ///   appKey: appKey,
  ///   loggingLevel: LoggingLevel.verbose,
  ///   collectorURL: collectorURL);
  /// await Instrumentation.start(config);
  /// ```
  ///
  static Future<void> start(AgentConfiguration config) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String type = "Flutter";

      Map<String, dynamic> arguments = {
        "appKey": config.appKey,
        "loggingLevel": config.loggingLevel.index,
        "collectorURL": config.collectorURL,
        "anrDetectionEnabled":
            true, // hardcoded until it's implemented on Android agent too
        "anrStackTraceEnabled":
            true, // hardcoded until it's implemented on Android agent too
        "version": version,
        "type": type,
      }..removeWhere((key, value) => value == null);

      await channel.invokeMethod<void>('start', arguments);
    } on PlatformException catch (e) {
      print("Failed to run agent start(): '${e.message}'");
      throw (e);
    }
  }

  /// We can time events by using customer timers that span across
  /// multiple threads/methods.
  ///
  /// Timer names can contain only alphanumeric characters and spaces.
  ///
  /// ```dart
  /// Future<void> doCheckout() async {
  /// *     final CHECKOUT_TIMER = "Time Spent on checkout";
  /// *     Instrumentation.startTimer(CHECKOUT_TIMER);
  /// *
  /// *     try {
  /// *         await someCheckoutService();
  /// *         await someOtherLongTask();
  /// *     } finally {
  /// *         Instrumentation.stopTimer(CHECKOUT_TIMER);
  /// *     }
  /// * }
  /// ```
  ///
  static Future<void> startTimer(String name) async {
    await channel.invokeMethod<void>('startTimer', name);
  }

  static Future<void> stopTimer(String name) async {
    await channel.invokeMethod<void>('stopTimer', name);
  }
}
