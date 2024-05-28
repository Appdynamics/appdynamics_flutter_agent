/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/app_state/app_state.dart';
import 'package:appdynamics_agent_example/routing/route_paths.dart';
import 'package:appdynamics_agent_example/settings/utils/constants.dart';
import 'package:appdynamics_agent_example/settings/utils/crash_report_dialog.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_picker/flutter_picker.dart';
import 'package:provider/provider.dart';

import 'utils/extra_configuration_dialog.dart';

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
  String errorMessage = '';

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

  // void _onCollectorTextFieldPress() {
  //   Picker(
  //       adapter: PickerDataAdapter<String>(pickerData: [
  //         collectors.keys.toList(),
  //       ], isArray: true),
  //       changeToFirst: true,
  //       hideHeader: false,
  //       onConfirm: (Picker picker, List value) {
  //         final collector = collectors.entries.elementAt(value[0]);
  //         _currentSelectedCollector = collector;
  //         _collectorFieldController.selection =
  //             TextSelection.fromPosition(const TextPosition(offset: 0));
  //       }).showModal(context);
  // }

  void _setCustomCollector(String _) {
    _collectorFieldController.text = "Custom";
  }

  Future<void> _showCrashReportAlert(String crashReports) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return CrashReportDialog(crashReports: crashReports);
        });
  }

  Future<void> _onStartPress(context) async {
    try {
      setState(() {
        errorMessage = "";
      });

      var appKey = _appKeyFieldController.text;
      var collectorURL = _collectorURLFieldController.text;
      var screenshotURL = _screenshotURLFieldController.text;

      var applicationName = "";
      if (Platform.isAndroid) {
        applicationName = "com.appdynamics.FlutterEveryfeatureAndroid";
      } else if (Platform.isIOS) {
        applicationName = "com.appdynamics.FlutterEveryfeatureiOS";
      }

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
          applicationName: applicationName,
          screenshotsEnabled: appState.screenshotsEnabled,
          crashReportingEnabled: appState.crashReportingEnabled,
          enableLoggingInVSCode: true);
      await Instrumentation.start(config);

      await Navigator.pushNamed(context, RoutePaths.featureList);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _showExtraConfigurationsDialog(context) async {
    await showDialog(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: ListView(shrinkWrap: true, children: <Widget>[
            Column(children: [
              TextFormField(
                controller: _appKeyFieldController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter app key',
                    hintText: 'AA-BBB-CCC'),
              ),
              const SizedBox(height: 20),
              // TextFormField(
              //   controller: _collectorFieldController,
              //   onTap: _onCollectorTextFieldPress,
              //   readOnly: true,
              //   decoration: const InputDecoration(
              //       border: OutlineInputBorder(),
              //       labelText: 'Select collector',
              //       hintText: 'https://my-custom-collector.com'),
              // ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _collectorURLFieldController,
                onFieldSubmitted: _setCustomCollector,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Collector URL',
                    hintText: 'https://my-custom-collector-url.com'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _screenshotURLFieldController,
                onFieldSubmitted: _setCustomCollector,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Screenshot URL',
                    hintText: 'https://my-custom-screenshot-url.com'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  key: const Key("startInstrumentationButton"),
                  onPressed: () => _onStartPress(context),
                  child: const Text('Start instrumentation')),
              const SizedBox(height: 20),
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              )
            ], mainAxisAlignment: MainAxisAlignment.center),
          ]),
        ),
      ),
    );
  }
}
