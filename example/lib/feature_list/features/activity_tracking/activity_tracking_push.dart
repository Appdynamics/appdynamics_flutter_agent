/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityTrackingPush extends StatefulWidget {
  const ActivityTrackingPush({Key? key}) : super(key: key);

  @override
  _ActivityTrackingPushState createState() => _ActivityTrackingPushState();
}

class _ActivityTrackingPushState extends State<ActivityTrackingPush> {
  _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(title: "Activity Tracking Push"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            ElevatedButton(
              key: const Key("backButton"),
              child: const Text('Back'),
              onPressed: _goBack,
            ),
          ]),
        ),
      ),
    );
  }
}
