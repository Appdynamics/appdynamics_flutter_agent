/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Anr extends StatefulWidget {
  const Anr({Key? key}) : super(key: key);

  @override
  _AnrState createState() => _AnrState();
}

class _AnrState extends State<Anr> {
  static const platform = MethodChannel('com.appdynamics.flutter.example');

  var showSleepText = false;

  void triggerSleep() {
    setState(() {
      showSleepText = true;
    });

    Future.delayed(const Duration(milliseconds: 50), () async {
      const anrThreshold = 5;
      await platform.invokeMethod('sleep', anrThreshold + 1);

      setState(() {
        showSleepText = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(
        title: 'ANR',
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            ElevatedButton(
              child: const Text('Trigger sleep'),
              onPressed: () {
                triggerSleep();
              },
            ),
            Visibility(
              child: const Text("Zzz Zzz."),
              visible: showSleepText,
            ),
          ],
        ),
      ),
    );
  }
}
