/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

// Shared state between entire widgets in the app.
// Default values for settings are also set here.
import 'package:flutter/cupertino.dart';

class AppState extends ChangeNotifier {
  String _appKey = "SH-AAB-AAE-JGG";
  bool _crashReportingEnabled = true;
  bool _screenshotsEnabled = true;

  String get appKey => _appKey;

  bool get crashReportingEnabled => _crashReportingEnabled;

  bool get screenshotsEnabled => _screenshotsEnabled;

  set appKey(String value) {
    _appKey = value;
    notifyListeners();
  }

  set crashReportingEnabled(bool value) {
    _crashReportingEnabled = value;
    notifyListeners();
  }

  set screenshotsEnabled(bool value) {
    _screenshotsEnabled = value;
    notifyListeners();
  }
}
