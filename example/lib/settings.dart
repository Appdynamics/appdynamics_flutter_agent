/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'feature-list.dart';
import 'utils/push-with-context.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final appKeyFieldController = TextEditingController(text: "SM-ADY-BDT");

  @override
  void dispose() {
    appKeyFieldController.dispose();
    super.dispose();
  }

  Future<void> onStartPress(context) async {
    try {
      var appKey = appKeyFieldController.text;

      if (appKey.trim().isEmpty) {
        return;
      }

      AgentConfiguration config = AgentConfiguration(
          appKey: appKey, loggingLevel: LoggingLevel.verbose);
      await Instrumentation.start(config);

      pushWithContext(context, FeatureList());
    } catch (error) {
      print(error.message);
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
              controller: appKeyFieldController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter app key',
                  hintText: 'AA-BBB-CCC'),
            ),
          ),
          ElevatedButton(
              key: Key("startInstrumentationButton"),
              onPressed: () => onStartPress(context),
              child: const Text('Start instrumentation')),
        ], mainAxisAlignment: MainAxisAlignment.center),
      ),
    );
  }
}
