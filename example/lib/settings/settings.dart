/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:convert';

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk_example/app_state/app_state.dart';
import 'package:appdynamics_mobilesdk_example/settings/utils/constants.dart';
import 'package:appdynamics_mobilesdk_example/settings/utils/crash_report_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:provider/provider.dart';

import 'utils/extra_configuration_dialog.dart';
import '../feature_list/feature_list.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _appKeyFieldController = TextEditingController();
  final _collectorFieldController = TextEditingController();
  final _collectorURLFieldController = TextEditingController();
  final _screenshotURLFieldController = TextEditingController();

  set _currentSelectedCollector(MapEntry collector) {
    final collectorName = collector.key;
    final collectorURL = collector.value["url"];
    final screenshotURL = collector.value["screenshotURL"];
    _collectorFieldController.text = collectorName!;
    _collectorURLFieldController.text = collectorURL!;
    _screenshotURLFieldController.text = screenshotURL!;
  }

  @override
  void initState() {
    super.initState();

    _currentSelectedCollector = collectors.entries.elementAt(0);

    final appState = Provider.of<AppState>(context, listen: false);
    _appKeyFieldController.text = appState.appKey;
  }

  @override
  void dispose() {
    _appKeyFieldController.dispose();
    _collectorFieldController.dispose();
    _collectorURLFieldController.dispose();
    _screenshotURLFieldController.dispose();
    super.dispose();
  }

  void _onCollectorTextFieldPress() {
    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: [
          collectors.keys.toList(),
        ], isArray: true),
        changeToFirst: true,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          final collector = collectors.entries.elementAt(value[0]);
          _currentSelectedCollector = collector;
          _collectorFieldController.selection =
              TextSelection.fromPosition(const TextPosition(offset: 0));
        }).showModal(context);
  }

  void _setCustomCollector(String _) {
    _collectorFieldController.text = "Custom";
  }

  Future<void> _showCrashReportAlert(String crashReports) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CrashReportDialog(crashReports: crashReports);
        });
  }

  Future<void> _onStartPress(context) async {
    var appKey = _appKeyFieldController.text;
    var collectorURL = _collectorURLFieldController.text;
    var screenshotURL = _screenshotURLFieldController.text;

    if (appKey.trim().isEmpty) {
      return;
    }

    crashReportCallback(List<CrashReportSummary> summaries) async {
      await _showCrashReportAlert(jsonEncode(summaries));
    }

    final appState = Provider.of<AppState>(context, listen: false);
    AgentConfiguration config = AgentConfiguration(
        appKey: appKey,
        loggingLevel: LoggingLevel.verbose,
        collectorURL: collectorURL,
        screenshotURL: screenshotURL,
        crashReportCallback: crashReportCallback,
        autoInstrument: appState.autoInstrumentEnabled,
        screenshotsEnabled: appState.screenshotsEnabled,
        crashReportingEnabled: appState.crashReportingEnabled);
    await Instrumentation.start(config);

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FeatureList()),
    );
  }

  Future<void> _showExtraConfigurationsDialog(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const ExtraConfigurationsDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EveryFeature'),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                key: const Key("extraConfigurationDialogButton"),
                onTap: () => {_showExtraConfigurationsDialog(context)},
                child: const Icon(Icons.settings),
              )),
        ],
      ),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 8, 50, 20),
            child: TextFormField(
              controller: _appKeyFieldController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter app key',
                  hintText: 'AA-BBB-CCC'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 8, 50, 0),
            child: TextFormField(
              controller: _collectorFieldController,
              onTap: _onCollectorTextFieldPress,
              readOnly: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Select collector',
                  hintText: 'https://my-custom-collector.com'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 8, 50, 0),
            child: TextFormField(
              controller: _collectorURLFieldController,
              onFieldSubmitted: _setCustomCollector,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Collector URL',
                  hintText: 'https://my-custom-collector-url.com'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 8, 50, 20),
            child: TextFormField(
              controller: _screenshotURLFieldController,
              onFieldSubmitted: _setCustomCollector,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Screenshot URL',
                  hintText: 'https://my-custom-screenshot-url.com'),
            ),
          ),
          ElevatedButton(
              key: const Key("startInstrumentationButton"),
              onPressed: () => _onStartPress(context),
              child: const Text('Start instrumentation')),
        ], mainAxisAlignment: MainAxisAlignment.center),
      ),
    );
  }
}
