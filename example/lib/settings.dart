/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:io';

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

import 'feature-list.dart';
import 'utils/push-with-context.dart';

var localServerURL = "http://${Platform.isIOS ? "localhost" : "10.0.2.2"}:9999";
final CollectorURLs = {
  "Local": localServerURL,
  "Shadow Master": "https://eum-shadow-master-col.saas.appd-test.com",
  "Shadow": "https://shadow-eum-col.appdynamics.com",
  "North America": "https://mobile.eum-appdynamics.com",
  "Europe": "https://fra-col.eum-appdynamics.com",
  "APAC": "https://syd-col.eum-appdynamics.com",
};

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static final _defaultCollectorTextFieldText =
      "${CollectorURLs.keys.elementAt(0)} '${CollectorURLs.values.elementAt(0)}'";
  var _collectorURLFieldController =
      TextEditingController(text: _defaultCollectorTextFieldText);
  final _appKeyFieldController = TextEditingController(text: "SM-ADY-BDT");

  @override
  void dispose() {
    _appKeyFieldController.dispose();
    super.dispose();
  }

  void _onCollectorTextFieldPress() {
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: [
          CollectorURLs.keys.toList(),
        ], isArray: true),
        changeToFirst: true,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          final collector = CollectorURLs.keys.elementAt(value[0]);
          final url = CollectorURLs.values.elementAt(value[0]);
          _collectorURLFieldController.text = "$collector '$url'";
          _collectorURLFieldController.selection =
              TextSelection.fromPosition(TextPosition(offset: 0));
        }).showModal(this.context);
  }

  Future<void> _onStartPress(context) async {
    try {
      var appKey = _appKeyFieldController.text;
      var collectorFieldText = _collectorURLFieldController.text;
      var split = _collectorURLFieldController.text.split('\'');
      // Check if custom URL or value from the picker
      var collectorURL = (split.length > 2) ? split[1] : collectorFieldText;

      if (appKey.trim().isEmpty) {
        return;
      }

      AgentConfiguration config = AgentConfiguration(
          appKey: appKey,
          loggingLevel: LoggingLevel.verbose,
          collectorURL: collectorURL);
      await Instrumentation.start(config);

      pushWithContext(context, FeatureList());
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EveryFeature'),
      ),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 8, 50, 20),
            child: TextFormField(
              controller: _collectorURLFieldController,
              onTap: _onCollectorTextFieldPress,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Select collector',
                  hintText: 'https://my-custom-collector.com'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 8, 50, 20),
            child: TextFormField(
              controller: _appKeyFieldController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter app key',
                  hintText: 'AA-BBB-CCC'),
            ),
          ),
          ElevatedButton(
              key: Key("startInstrumentationButton"),
              onPressed: () => _onStartPress(context),
              child: const Text('Start instrumentation')),
        ], mainAxisAlignment: MainAxisAlignment.center),
      ),
    );
  }
}
