/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/material.dart';

class ActivityTrackingReplace extends StatefulWidget {
  const ActivityTrackingReplace({Key? key}) : super(key: key);

  @override
  _ActivityTrackingReplaceState createState() =>
      _ActivityTrackingReplaceState();
}

class _ActivityTrackingReplaceState extends State<ActivityTrackingReplace> {
  _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(title: "Activity Tracking Replace"),
      body: ListView(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    key: const Key("backButton"),
                    child: const Text('Back'),
                    onPressed: _goBack,
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}
