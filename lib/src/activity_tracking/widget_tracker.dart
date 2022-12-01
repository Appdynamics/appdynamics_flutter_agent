/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent/src/globals.dart';
import 'package:flutter/services.dart';

class TrackedWidget {
  late String widgetName;

  late String uuidString;

  late int startDate;

  int? endDate;

  TrackedWidget({
    required this.widgetName,
    required this.startDate,
    this.endDate,
  });

  TrackedWidget.fromJson(Map<String, dynamic> json) {
    widgetName = json["widgetName"];
    uuidString = json["uuidString"];
    startDate = json["startDate"];
    endDate = json["endDate"];
  }

  Map<String, dynamic> toJson() {
    return {
      'widgetName': widgetName,
      'uuidString': uuidString,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

/// A class used for manually tracking activities throughout the app.
///
/// The available methods permit specifying the start and end of a Flutter
/// widget to be reflected as an app screen in the controller.
///
/// Warning: Be sure to be using unique widget names. Duplicate names might
/// result in unexpected behavior.
///
/// For apps using named routes, see [NavigationObserver].
///
/// ```dart
/// import 'package:appdynamics_agent/appdynamics_agent.dart';
/// import 'package:flutter/cupertino.dart';
/// import 'package:flutter/material.dart';
///
/// class CheckoutPage extends StatefulWidget {
///   const CheckoutPage({Key? key}) : super(key: key);
///
///   static String screenName = "Checkout Page";
///
///   @override
///   _CheckoutPageState createState() => _CheckoutPageState();
/// }
///
/// class _CheckoutPageState extends State<CheckoutPage> {
///   @override
///   void initState() async {
///     super.initState();
///     await WidgetTracker.instance.trackWidgetStart(CheckoutPage.screenName);
///   }
///
///   _backToMainScreen() async {
///     await WidgetTracker.instance.trackWidgetEnd(CheckoutPage.screenName);
///     Navigator.pop(context);
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Center(
///         child:
///         Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
///           ElevatedButton(
///             child: const Text('Proceed'),
///             onPressed: _backToMainScreen,
///           )
///         ]));
///   }
/// }
/// ```
class WidgetTracker {
  final Map<String, TrackedWidget> trackedWidgets = {};

  WidgetTracker._privateConstructor();

  static final WidgetTracker _instance = WidgetTracker._privateConstructor();

  static WidgetTracker get instance => _instance;

  /// Tracks when a widget has started.
  ///
  /// May throw [Exception] on native platform contingency.
  Future<void> trackWidgetStart(String widgetName) async {
    try {
      final startDate = DateTime.now().millisecondsSinceEpoch;
      final trackedWidget =
          TrackedWidget(widgetName: widgetName, startDate: startDate);

      final params = {
        'widgetName': trackedWidget.widgetName,
        'startDate': trackedWidget.startDate,
        'endDate': trackedWidget.endDate,
      };

      final uuid = await channel.invokeMethod<String>('trackPageStart', params);
      trackedWidget.uuidString = uuid!;

      trackedWidgets[trackedWidget.widgetName] = trackedWidget;
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }

  /// Tracks when a widget has ended.
  ///
  /// If the widget doesn't exist, it doesn't do anything.
  ///
  /// May throw [Exception] on native platform contingency.
  Future<void> trackWidgetEnd(String widgetName) async {
    try {
      final trackedWidget = trackedWidgets[widgetName];

      if (trackedWidget == null) {
        return;
      }

      final endDate = DateTime.now().millisecondsSinceEpoch;
      trackedWidget.endDate = endDate;

      await channel.invokeMethod<void>('trackPageEnd', trackedWidget.toJson());

      trackedWidgets.remove(trackedWidget.widgetName);
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }
}
