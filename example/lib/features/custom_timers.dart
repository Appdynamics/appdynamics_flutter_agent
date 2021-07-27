/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk_example/utils/flush_beacons_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTimers extends StatefulWidget {
  @override
  _CustomTimersState createState() => _CustomTimersState();
}

class _CustomTimersState extends State<CustomTimers> {
  Future<void> _startTimerPressed() async {
    await Instrumentation.startTimer("My timer");
  }

  Future<void> _stopTimerPressed() async {
    await Instrumentation.stopTimer("My timer");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlushBeaconsAppBar(title: "Custom timers"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 50, left: 50),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              key: Key("startTimerButton"),
              child: Text('Start timer'),
              onPressed: _startTimerPressed,
            ),
            ElevatedButton(
              key: Key("stopTimerButton"),
              child: Text('Stop timer'),
              onPressed: _stopTimerPressed,
            ),
          ]),
        ),
      ),
    );
  }
}
