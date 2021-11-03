/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk_example/utils/flush_beacons_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SessionControl extends StatelessWidget {
  const SessionControl({Key? key}) : super(key: key);

  Future<void> _startNextSession() async {
    await Instrumentation.startNextSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(title: "Session control"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 50, left: 50),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              key: const Key("startNextSession"),
              child:
                  const Text('Start next session', textAlign: TextAlign.center),
              onPressed: _startNextSession,
            ),
          ]),
        ),
      ),
    );
  }
}
