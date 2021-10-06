/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

// TODO: Extract methods into files when static extensions are supported.
// https://github.com/dart-lang/language/issues/723

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk/src/agent_configuration.dart';
import 'package:appdynamics_mobilesdk/src/session_frame.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'globals.dart';

enum BreadcrumbVisibility {
  crashesOnly,
  crashesAndSessions,
}

enum ErrorSeverityLevel {
  /// An error happened, but it did not cause a problem.
  info,

  /// An error happened but the app recovered gracefully.
  warning,

  /// An error happened and caused problems to the app.
  critical,
}

const maxUserDataStringLength = 2048;

/// Interact with the AppDynamics agent running in your application.
///
/// This class provides a number of methods to interact with the AppDynamics
/// agent including:
///
/// - Initializing the agent with the right application key.
/// - Reporting timers, errors, session frames, custom metrics.
class Instrumentation {
  static _initializeCrashCallback(CrashReportCallback callback) {
    Future<dynamic> crashReportingHandler(MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'onCrashReported':
          final rawMaps = methodCall.arguments as List<dynamic>;
          final summaries = rawMaps
              .map((map) =>
                  CrashReportSummary.fromJson(Map<String, dynamic>.from(map)))
              .toList();
          callback(summaries);
      }
    }

    channel.setMethodCallHandler(crashReportingHandler);
  }

  /// Initializing the agent
  /// The agent does not automatically start with your application. Using the
  /// app key shown in your controller UI, you can initialize the agent.
  /// This has to be done near your application's entry point before any other
  /// initialization routines in your application.
  ///
  /// Once initialized, further calls to [Instrumentation.start] have no effect
  /// on the agent.
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
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String type = "Flutter";

    final crashCallback = config.crashReportCallback;
    if (crashCallback != null) {
      _initializeCrashCallback(crashCallback);
    }

    Map<String, dynamic> arguments = {
      "appKey": config.appKey,
      "loggingLevel": config.loggingLevel.index,
      "collectorURL": config.collectorURL,
      "screenshotURL": config.screenshotURL,
      "screenshotsEnabled": config.screenshotsEnabled,
      "crashReportingEnabled": config.crashReportingEnabled,
      "anrDetectionEnabled":
          true, // hardcoded until it's implemented on Android agent too
      "anrStackTraceEnabled":
          true, // hardcoded until it's implemented on Android agent too
      "version": version,
      "type": type,
    }..removeWhere((key, value) => value == null);

    await channel.invokeMethod<void>('start', arguments);
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
      {ErrorSeverityLevel severityLevel = ErrorSeverityLevel.warning}) async {
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
      {ErrorSeverityLevel severityLevel = ErrorSeverityLevel.warning}) async {
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
  ///       severityLevel: ErrorSeverityLevel.info);
  /// }
  /// ```
  static Future<void> reportMessage(String message,
      {ErrorSeverityLevel severityLevel = ErrorSeverityLevel.warning}) async {
    final arguments = {"message": message, "severity": severityLevel.index};
    await channel.invokeMethod<void>('reportError', arguments);
  }

  /// Sets a key-value pair identifier that will be included in all snapshots.
  /// This identifier can be used to add the [string] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [maxUserDataStringLength] characters.
  ///
  /// A [value] of [null] will clear the data.
  /// The [value] is also limited to [maxUserDataStringLength] characters.
  ///
  /// This information is not persisted across application runs.
  /// Once the application is destroyed, user data is cleared.
  ///
  /// Data can be removed via [removeUserData].
  static Future<void> setUserData(
    String key,
    String? value,
  ) async {
    if (value == null) {
      removeUserData(key);
      return;
    }

    final arguments = {"key": key, "value": value};
    await channel.invokeMethod<void>('setUserData', arguments);
  }

  /// Removes the [string] corresponding to a [key] set with [setUserData].
  static Future<void> removeUserData(
    String key,
  ) async {
    await channel.invokeMethod<void>('removeUserData', key);
  }

  /// Sets a key-value pair identifier that will be included in all snapshots.
  /// This identifier can be used to add the [double] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [maxUserDataStringLength] characters.
  ///
  /// A [value] of [null] will clear the data.
  /// The [value] is also limited to [maxUserDataStringLength] characters.
  ///
  /// This information is not persisted across application runs.
  /// Once the application is destroyed, user data is cleared.
  ///
  /// Data can be removed via [removeUserDataDouble].
  static Future<void> setUserDataDouble(
    String key,
    double? value,
  ) async {
    if (value == null) {
      removeUserDataDouble(key);
      return;
    }

    final arguments = {"key": key, "value": value};
    await channel.invokeMethod<void>('setUserDataDouble', arguments);
  }

  /// Removes the [double] corresponding to a [key] set with [setUserDataDouble].
  static Future<void> removeUserDataDouble(
    String key,
  ) async {
    await channel.invokeMethod<void>('removeUserDataDouble', key);
  }

  /// Sets a key-value pair identifier that will be included in all snapshots.
  /// This identifier can be used to add the [int] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [maxUserDataStringLength] characters.
  ///
  /// A [value] of [null] will clear the data.
  /// The [value] is also limited to [maxUserDataStringLength] characters.
  ///
  /// This information is not persisted across application runs.
  /// Once the application is destroyed, user data is cleared.
  ///
  /// Data can be removed via [removeUserDataInt].
  static Future<void> setUserDataInt(
    String key,
    int? value,
  ) async {
    if (value == null) {
      removeUserDataInt(key);
      return;
    }

    final arguments = {"key": key, "value": value};
    await channel.invokeMethod<void>('setUserDataLong', arguments);
  }

  /// Removes the [int] corresponding to a [key] set with [setUserDataInt].
  static Future<void> removeUserDataInt(
    String key,
  ) async {
    await channel.invokeMethod<void>('removeUserDataLong', key);
  }

  /// Sets a key-value pair identifier that will be included in all snapshots.
  /// This identifier can be used to add the [bool] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [maxUserDataStringLength] characters.
  ///
  /// A [value] of [null] will clear the data.
  /// The [value] is also limited to [maxUserDataStringLength] characters.
  ///
  /// This information is not persisted across application run.
  /// Once the application is destroyed, user data is cleared.
  ///
  /// Data can be removed via [removeUserDataBool].
  static Future<void> setUserDataBool(
    String key,
    bool? value,
  ) async {
    if (value == null) {
      removeUserDataBool(key);
      return;
    }

    final arguments = {"key": key, "value": value};
    await channel.invokeMethod<void>('setUserDataBoolean', arguments);
  }

  /// Removes the [bool] corresponding to a [key] set with [setUserDataBool].
  static Future<void> removeUserDataBool(
    String key,
  ) async {
    await channel.invokeMethod<void>('removeUserDataBoolean', key);
  }

  /// Sets a key-value pair identifier that will be included in all snapshots.
  /// This identifier can be used to add the [DateTime] types.
  ///
  /// The [key] must be unique across your application.
  /// The [key] namespace is distinct for each user data type.
  /// Re-using the same [key] overwrites the previous [value].
  /// The [key] is limited to [maxUserDataStringLength] characters.
  ///
  /// A [value] of [null] will clear the data.
  /// The [value] is also limited to [maxUserDataStringLength] characters.
  ///
  /// This information is not persisted across application runs.
  /// Once the application is destroyed, user data is cleared.
  ///
  /// Data can be removed via [removeUserDataDateTime].
  static Future<void> setUserDataDateTime(
    String key,
    DateTime? value,
  ) async {
    if (value == null) {
      removeUserDataDateTime(key);
      return;
    }

    final arguments = {"key": key, "value": value.toIso8601String()};
    await channel.invokeMethod<void>('setUserDataDate', arguments);
  }

  /// Removes the [DateTime] corresponding to a [key] set with
  /// [setUserDataDateTime].
  static Future<void> removeUserDataDateTime(
    String key,
  ) async {
    await channel.invokeMethod<void>('removeUserDataDate', key);
  }

  /// Starts and returns a [SessionFrame] object.
  ///
  /// You can use the Session Frame API to create session frames that will
  /// appear in the session activity. Session frames provide context for what
  /// the user is doing during a session. With this API, you can improve the
  /// names of user screens and chronicle user flows within a business context.
  ///
  /// The following are common use cases for the SessionFrame API:
  ///
  /// * One screen performs multiple functions and you want more granular
  ///  tracking of the individual functions.
  /// * A user flow spans multiple screens or user interactions.
  ///  For example, you could use the API to create the session frames
  ///  "Login", "Product Selection", and "Purchase" to follow the user's flow
  ///  for purchases.
  /// * You want to capture dynamic information based on user interactions to
  /// name session frames, such as an order ID.
  ///
  /// Example:
  ///
  /// ```dart
  /// import '../appdynamics_mobilesdk.dart';
  ///
  /// class ShoppingCart {
  ///   late SessionFrame _sessionFrame;
  ///   late String _orderId;
  ///
  /// void onCheckoutCartButtonClick() async {
  ///   // The checkout starts when the user clicks the checkout button.
  ///   // This may be after they have updated quantities of items in their
  ///   // cart, etc.
  ///   _sessionFrame = await Instrumentation.startSessionFrame("Checkout");
  /// }
  ///
  /// void onConfirmOrderButtonClick() {
  ///   // Once they have confirmed payment info and shipping information,
  ///   // and they are clicking the "Confirm" button to start the backend
  ///   // process of checking out, we may know more information about the
  ///   // order itself, such as an order ID.
  ///   _sessionFrame.updateName("Checkout: Order ID {this.orderId}");
  /// }
  ///
  /// void onProcessOrderComplete() {
  ///   // Once the order is processed, the user is done "checking out" so we end
  ///   // the session frame.
  ///   _sessionFrame.end();
  /// }
  ///
  /// void onCheckoutCancel() {
  ///   // If they cancel or go back, you'll want to end the session frame also, or
  ///   // else it will be left open and appear to have never ended.
  ///   _sessionFrame.end();
  /// }
  /// ```
  static Future<SessionFrame> startSessionFrame(
    String sessionFrameName,
  ) async {
    final sessionFrame = createSessionFrame();
    final arguments = {"name": sessionFrameName, "id": sessionFrame.id};
    await channel.invokeMethod<void>('startSessionFrame', arguments);
    return sessionFrame;
  }

  /// Unblocks screenshot capture if it is currently blocked, otherwise this has
  /// no effect. Returns a [Future] which resolves when screenshots are
  /// effectively unblocked.
  ///
  /// If screenshots are disabled through
  /// [AgentConfiguration.screenshotsEnabled] or through the controller UI, this
  /// method has no effect.
  ///
  /// If screenshots are set to manual mode in the controller UI, this method
  /// unblocks for manual mode only.
  ///
  /// **WARNING:** This will unblock capture for the entire app.
  ///
  /// The user is expected to manage any possible nesting issues that may occur
  /// if blocking and unblocking occur in different code paths.
  ///
  /// See [Instrumentation.blockScreenshots()]
  static Future<void> unblockScreenshots() async {
    await channel.invokeMethod<void>('unblockScreenshots');
  }

  /// Blocks screenshot capture if it is currently unblocked, otherwise this
  /// has no effect. Returns a [Future] which resolves when screenshots are
  /// effectively blocked.
  ///
  /// If screenshots are disabled through
  /// [AgentConfiguration.screenshotsEnabled] or through the controller UI, this
  /// method has no effect.
  ///
  /// **WARNING:**  This will block capture for the entire app.
  ///
  /// The user is expected to manage any possible nesting issues that may
  /// occur if blocking and unblocking occur in different code paths.
  ///
  /// See [Instrumentation.unblockScreenshots]
  static Future<void> blockScreenshots() async {
    await channel.invokeMethod<void>('blockScreenshots');
  }

  /// A [bool] that specifies whether screenshot capturing is blocked.
  static Future<bool> screenshotsBlocked() async {
    final result = await channel.invokeMethod<bool>('screenshotsBlocked');
    return result!;
  }

  /// Asynchronously takes a screenshot of the current screen.
  ///
  /// If screenshots are disabled through
  /// [AgentConfiguration.screenshotsEnabled] or through the controller UI, this
  /// method does nothing.
  ///
  /// This will capture everything, including personal information, so you must
  /// be cautious of when to take the screenshot.
  ///
  /// These screenshots will show up in the Sessions screen for this user.
  ///
  /// The screenshots are taken on a background thread, compressed, and only
  /// non-redundant parts are uploaded, so it is safe to take many of these
  /// without impacting performance of your application.
  static Future<void> takeScreenshot() async {
    await channel.invokeMethod<bool>('takeScreenshot');
  }

  /// Custom metrics allows you to report numeric values associated with a
  /// metric [name]. For example, to track the number of times your users
  /// clicked the *checkout* button.
  ///
  /// [name] should contain only alphanumeric characters and spaces.
  /// Illegal characters shall be replaced by their ASCII hex value.
  ///
  /// Example:
  ///
  /// ```dart
  /// import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
  /// import 'package:flutter/cupertino.dart';
  /// import 'package:flutter/material.dart';
  ///
  /// class App extends StatelessWidget {
  ///   _finishCheckout() {
  ///     Instrumentation.reportMetric(name: "Checkout Count", value: 1);
  ///     // ...rest of the checkout logic
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(title: Text("Checkout screen")),
  ///       body: Center(
  ///         child:
  ///             ElevatedButton(
  ///               child: Text('Checkout'),
  ///               onPressed: _finishCheckout,
  ///             )
  ///     ));
  /// }
  /// ```
  static Future<void> reportMetric({
    required String name,
    required int value,
  }) async {
    final arguments = {"name": name, "value": value};
    await channel.invokeMethod<void>('reportMetric', arguments);
  }
}
