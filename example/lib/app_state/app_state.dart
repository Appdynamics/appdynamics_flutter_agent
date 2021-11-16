import 'package:flutter/cupertino.dart';

// Shared state between entire widgets in the app.
// Default values for settings are also set here.
class AppState extends ChangeNotifier {
  String _appKey = "SM-AER-HCE";
  bool _crashReportingEnabled = true;
  bool _screenshotsEnabled = true;
  bool _autoInstrumentEnabled = false;

  String get appKey => _appKey;

  bool get crashReportingEnabled => _crashReportingEnabled;

  bool get screenshotsEnabled => _screenshotsEnabled;

  bool get autoInstrumentEnabled => _autoInstrumentEnabled;

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

  set autoInstrumentEnabled(bool value) {
    _autoInstrumentEnabled = value;
    notifyListeners();
  }
}
