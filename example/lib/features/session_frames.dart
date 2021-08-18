/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk_example/utils/flush_beacons_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SessionFrames extends StatefulWidget {
  const SessionFrames({Key? key}) : super(key: key);

  @override
  _SessionFramesState createState() => _SessionFramesState();
}

class _SessionFramesState extends State<SessionFrames> {
  final newSessionFrameName = "newSessionFrame";
  final updatedSessionFrameName = "updatedSessionFrame";
  SessionFrame? sessionFrame = null;

  Future<void> _startSessionFrame() async {
    if (sessionFrame != null) {
      print("Session frame already initialized.");
      return;
    }

    sessionFrame = await Instrumentation.startSessionFrame(newSessionFrameName);
  }

  Future<void> _updateSessionFrame() async {
    await sessionFrame?.updateName(updatedSessionFrameName);
  }

  Future<void> _endSessionFrame() async {
    await sessionFrame?.end();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlushBeaconsAppBar(title: "Session frames"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 50, left: 50),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              key: Key("startSessionFrameButton"),
              child: Text(
                  'Start session frame \n(named: "$newSessionFrameName")',
                  textAlign: TextAlign.center),
              onPressed: _startSessionFrame,
            ),
            ElevatedButton(
              key: Key("updateSessionFrameButton"),
              child: Text(
                  'Update session frame \n(named: "$updatedSessionFrameName")',
                  textAlign: TextAlign.center),
              onPressed: _updateSessionFrame,
            ),
            ElevatedButton(
              key: Key("endSessionFrameButton"),
              child: Text('End session frame', textAlign: TextAlign.center),
              onPressed: _endSessionFrame,
            ),
          ]),
        ),
      ),
    );
  }
}
