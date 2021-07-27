/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

// TODO: Extract methods into files when static extensions are supported.
// https://github.com/dart-lang/language/issues/723

import 'package:appdynamics_mobilesdk/src/agent_configuration.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'globals.dart';

enum BreadcrumbVisibility {
  CRASHES_ONLY,
  CRASHES_AND_SESSIONS,
}

enum ErrorSeverityLevel {
  /// An error happened, but it did not cause a problem.
  INFO,

  /// An error happened but the app recovered gracefully.
  WARNING,

  /// An error happened and caused problems to the app.
  CRITICAL,
}

/// Interact with the AppDynamics agent running in your application.
///
/// This class provides a number of methods to interact with the AppDynamics
/// agent including:
///
/// - Initializing the agent with the right application key.
/// - Reporting timers, errors.
class Instrumentation {
  /// Initializing the agent
  /// The agent does not automatically start with your application. Using the
  /// app key shown in your controller UI, you can initialize the agent.
  /// This has to be done near your application's entry point before any other
  /// initialization routines in your application.
  ///
  /// Once initialized, further calls to {@link start} have no effect on the
  /// agent.
  ///
  /// ```dart
  /// try {
  ///   AgentConfiguration config = AgentConfiguration(
  ///       appKey: appKey,
  ///       loggingLevel: LoggingLevel.verbose,
  ///       collectorURL: collectorURL);
  ///   await Instrumentation.start(config);
  /// } catch (e) {
  ///   logError(e);
  /// }
  /// ```
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
  ///  final checkoutTimerName = "Time spent on checkout";
  ///
  ///  try {
  ///    await Instrumentation.startTimer(checkoutTimerName);
  ///    await someCheckoutService();
  ///    await someOtherLongTask();
  ///  } finally {
  ///    await Instrumentation.stopTimer(checkoutTimerName);
  ///  }
  /// }
  /// ```
  static Future<void> startTimer(String name) async {
    await channel.invokeMethod<void>('startTimer', name);
  }

  static Future<void> stopTimer(String name) async {
    await channel.invokeMethod<void>('stopTimer', name);
  }

  /// Leaves a breadcrumb that will appear in a crash report and optionally,
  /// on the session.
  ///
  /// Call this when something interesting happens in your application.
  /// The breadcrumb will be included in different reports depending on the
  /// `mode`. Each crash report displays the most recent 99 breadcrumbs.
  ///
  /// If you would like it to appear also in sessions, use
  /// [BreadcrumbVisibility.CRASHES_AND_SESSIONS].
  ///
  /// Use [breadcrumb] to include a message in the crash report and sessions.
  /// If it's longer than 2048 characters, it will be truncated.
  /// If it's empty, no breadcrumb will be recorded.
  /// Use [mode] with a value of [BreadcrumbVisibility]. If invalid, defaults
  /// to [BreadcrumbVisibility.CRASHES_ONLY]
  ///
  /// ```dart
  /// Future<void> showSignUp() async {
  ///   try {
  ///     await Instrumentation.leaveBreadcrumb("Pushing Sign up screen.",
  ///      BreadcrumbVisibility.CRASHES_AND_SESSIONS);
  ///     await pushSignUpScreen();
  ///   } catch (e) {
  ///     ...
  ///   }
  /// }
  /// ```
  static Future<void> leaveBreadcrumb(
    String breadcrumb,
    BreadcrumbVisibility mode,
  ) async {
    final arguments = {"breadcrumb": breadcrumb, "mode": mode.index};
    await channel.invokeMethod<void>('leaveBreadcrumb', arguments);
  }

  /// Reports an [exception] that was caught.
  ///
  /// This can be called in [catch] blocks to report unexpected exception that
  /// you want to track.
  ///
  /// ```dart
  /// try {
  ///   await jsonDecode("invalid/exception/json");
  /// } on NoSuchMethodError catch (e) {
  ///   await Instrumentation.reportError(e,
  ///       severityLevel: ErrorSeverityLevel.WARNING);
  /// }
  /// ```
  static Future<void> reportException(Exception exception,
      {ErrorSeverityLevel severityLevel = ErrorSeverityLevel.WARNING}) async {
    final arguments = {
      "message": exception.toString(),
      "severity": severityLevel.index
    };
    await channel.invokeMethod<void>('reportError', arguments);
  }

  /// Reports an [error] that was caught. Includes the error's stackTrace.
  ///
  /// This can be called in [catch] blocks to report unexpected errors that you
  /// want to track.
  ///
  /// ```dart
  /// try {
  ///    final myMethod = null;
  ///    myMethod();
  ///  } on NoSuchMethodError catch (e) {
  ///    await Instrumentation.reportError(e,
  ///        severityLevel: ErrorSeverityLevel.CRITICAL);
  ///  }
  /// ```
  static Future<void> reportError(Error error,
      {ErrorSeverityLevel severityLevel = ErrorSeverityLevel.WARNING}) async {
    final arguments = {
      "message": error.toString(),
      "stackTrace": error.stackTrace.toString(),
      "severity": severityLevel.index
    };
    await channel.invokeMethod<void>('reportError', arguments);
  }

  /// Reports a custom message with a corresponding severity.
  ///
  /// Useful in case you are handling errors that don't match [reportError] nor
  /// [reportException].
  ///
  /// ```dart
  /// try {
  ///   await customAPI();
  /// } on CustomError catch (e) {
  ///   await Instrumentation.reportMessage(e.toString(),
  ///       severityLevel: ErrorSeverityLevel.INFO);
  /// }
  /// ```
  static Future<void> reportMessage(String message,
      {ErrorSeverityLevel severityLevel = ErrorSeverityLevel.WARNING}) async {
    final arguments = {"message": message, "severity": severityLevel.index};
    await channel.invokeMethod<void>('reportError', arguments);
  }
}
