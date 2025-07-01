/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/material.dart';

class SessionFrames extends StatefulWidget {
  const SessionFrames({super.key});

  @override
  State<SessionFrames> createState() => _SessionFramesState();
}

class _SessionFramesState extends State<SessionFrames> {
  final newSessionFrameName = "newSessionFrame";
  final updatedSessionFrameName = "updatedSessionFrame";
  SessionFrame? sessionFrame;

  Future<void> _startSessionFrame() async {
    if (sessionFrame != null) {
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
      appBar: const FlushBeaconsAppBar(title: "Session frames"),
      body: ListView(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    key: const Key("startSessionFrameButton"),
                    onPressed: _startSessionFrame,
                    child: Text(
                        'Start session frame \n(named: "$newSessionFrameName")',
                        textAlign: TextAlign.center),
                  ),
                  ElevatedButton(
                    key: const Key("updateSessionFrameButton"),
                    onPressed: _updateSessionFrame,
                    child: Text(
                        'Update session frame \n(named: "$updatedSessionFrameName")',
                        textAlign: TextAlign.center),
                  ),
                  ElevatedButton(
                    key: const Key("endSessionFrameButton"),
                    onPressed: _endSessionFrame,
                    child: const Text('End session frame',
                        textAlign: TextAlign.center),
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}
