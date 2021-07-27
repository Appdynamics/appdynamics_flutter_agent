/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk_example/utils/flush_beacons_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ANR extends StatefulWidget {
  @override
  _ANRState createState() => _ANRState();
}

class _ANRState extends State<ANR> {
  static const platform =
      const MethodChannel('com.appdynamics.flutter.example');

  var showSleepText = false;

  void triggerSleep() {
    setState(() {
      showSleepText = true;
    });

    new Future.delayed(const Duration(milliseconds: 50), () async {
      try {
        const anrThreshold = 5;
        await platform.invokeMethod('sleep', anrThreshold + 1);
      } on PlatformException catch (e) {
        print("Failed to get native sleep: '${e.message}'.");
      }

      setState(() {
        showSleepText = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlushBeaconsAppBar(
        title: 'ANR',
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Trigger sleep'),
              onPressed: () {
                triggerSleep();
              },
            ),
            Visibility(
              child: Text("Zzz Zzz."),
              visible: showSleepText,
            ),
          ],
        ),
      ),
    );
  }
}
