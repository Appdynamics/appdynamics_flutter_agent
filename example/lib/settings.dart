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

import 'feature_list.dart';

var localServerURL = "http://${Platform.isIOS ? "localhost" : "10.0.2.2"}:9999";
final Collectors = {
  "Local": {"url": localServerURL, "screenshotURL": localServerURL},
  "Shadow Master": {
    "url": "https://eum-shadow-master-col.saas.appd-test.com",
    "screenshotURL": "https://eum-shadow-master-image.saas.appd-test.com"
  },
  "Shadow": {
    "url": "https://shadow-eum-col.appdynamics.com",
    "screenshotURL": "https://shadow-eum-image.appdynamics.com"
  },
  "North America": {
    "url": "https://mobile.eum-appdynamics.com",
    "screenshotURL": "https://mobile.eum-appdynamics.com"
  },
  "Europe": {
    "url": "https://fra-col.eum-appdynamics.com",
    "screenshotURL": "https://fra-col.eum-appdynamics.com"
  },
  "APAC": {
    "url": "https://syd-col.eum-appdynamics.com",
    "screenshotURL": "https://syd-col.eum-appdynamics.com"
  },
};

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static final _appKey = "SM-AEG-MXS";

  final _appKeyFieldController = TextEditingController(text: _appKey);
  final _collectorFieldController = TextEditingController();
  final _collectorURLFieldController = TextEditingController();
  final _screenshotURLFieldController = TextEditingController();

  void set _currentSelectedCollector(MapEntry collector) {
    final collectorName = collector.key;
    final collectorURL = collector.value["url"];
    final screenshotURL = collector.value["screenshotURL"];
    _collectorFieldController.text = collectorName!;
    _collectorURLFieldController.text = collectorURL!;
    _screenshotURLFieldController.text = screenshotURL!;
  }

  _SettingsState() {
    _currentSelectedCollector = Collectors.entries.elementAt(0);
  }

  @override
  void dispose() {
    _appKeyFieldController.dispose();
    super.dispose();
  }

  void _onCollectorTextFieldPress() {
    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: [
          Collectors.keys.toList(),
        ], isArray: true),
        changeToFirst: true,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          final collector = Collectors.entries.elementAt(value[0]);
          _currentSelectedCollector = collector;
          _collectorFieldController.selection =
              TextSelection.fromPosition(TextPosition(offset: 0));
        }).showModal(this.context);
  }

  void _setCustomCollector(String _) {
    _collectorFieldController.text = "Custom";
  }

  Future<void> _onStartPress(context) async {
    try {
      var appKey = _appKeyFieldController.text;
      var collectorURL = _collectorURLFieldController.text;
      var screenshotURL = _screenshotURLFieldController.text;

      if (appKey.trim().isEmpty) {
        return;
      }

      AgentConfiguration config = AgentConfiguration(
          appKey: appKey,
          loggingLevel: LoggingLevel.verbose,
          collectorURL: collectorURL,
          screenshotURL: screenshotURL);
      await Instrumentation.start(config);

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FeatureList()),
      );
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
              controller: _appKeyFieldController,
              decoration: InputDecoration(
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
              decoration: InputDecoration(
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
              decoration: InputDecoration(
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
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Screenshot URL',
                  hintText: 'https://my-custom-screenshot-url.com'),
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
