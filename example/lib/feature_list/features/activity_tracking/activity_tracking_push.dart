/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/material.dart';

class ActivityTrackingPush extends StatefulWidget {
  const ActivityTrackingPush({super.key});

  @override
  State<ActivityTrackingPush> createState() => _ActivityTrackingPushState();
}

class _ActivityTrackingPushState extends State<ActivityTrackingPush> {
  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(title: "Activity Tracking Push"),
      body: ListView(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    key: const Key("backButton"),
                    onPressed: _goBack,
                    child: const Text('Back'),
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}
