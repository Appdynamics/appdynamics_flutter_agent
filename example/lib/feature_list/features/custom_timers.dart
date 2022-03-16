/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/material.dart';

class CustomTimers extends StatelessWidget {
  const CustomTimers({Key? key}) : super(key: key);

  Future<void> _startTimerPressed() async {
    await Instrumentation.startTimer("My timer");
  }

  Future<void> _stopTimerPressed() async {
    await Instrumentation.stopTimer("My timer");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(title: "Custom timers"),
      body: ListView(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    key: const Key("startTimerButton"),
                    child: const Text('Start timer'),
                    onPressed: _startTimerPressed,
                  ),
                  ElevatedButton(
                    key: const Key("stopTimerButton"),
                    child: const Text('Stop timer'),
                    onPressed: _stopTimerPressed,
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}
