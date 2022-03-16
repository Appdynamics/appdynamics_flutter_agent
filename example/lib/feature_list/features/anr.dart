/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/material.dart';

class Anr extends StatefulWidget {
  const Anr({Key? key}) : super(key: key);

  @override
  _AnrState createState() => _AnrState();
}

class _AnrState extends State<Anr> {
  var showSleepText = false;

  void triggerSleep() async {
    setState(() {
      showSleepText = true;
    });

    const anrThreshold = 5;
    const duration = Duration(seconds: anrThreshold + 1);
    await Instrumentation.sleep(duration);

    setState(() {
      showSleepText = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(
        title: 'ANR',
      ),
      body: ListView(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 20, 50, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  key: const Key("triggerSleepButton"),
                  child: const Text('Trigger sleep'),
                  onPressed: () {
                    triggerSleep();
                  },
                ),
                Visibility(
                  child: const Text(
                    "Zzz Zzz.",
                    textAlign: TextAlign.center,
                  ),
                  visible: showSleepText,
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
