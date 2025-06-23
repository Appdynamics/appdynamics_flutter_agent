/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:appdynamics_agent_example/routing/route_paths.dart';
import 'package:flutter/material.dart';

class ActivityTracking extends StatefulWidget {
  const ActivityTracking({super.key});

  @override
  State<ActivityTracking> createState() => _ActivityTrackingState();
}

class _ActivityTrackingState extends State<ActivityTracking> {
  Future<void> _pushScreen() async {
    await Navigator.pushNamed(context, RoutePaths.activityTrackingPush);
  }

  Future<void> _replaceScreen() async {
    await Navigator.pushReplacementNamed(
        context, RoutePaths.activityTrackingReplace);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(title: "Activity Tracking"),
      body: ListView(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    key: const Key("pushScreenButton"),
                    onPressed: _pushScreen,
                    child: const Text('Screen push'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    key: const Key("replaceScreenButton"),
                    onPressed: _replaceScreen,
                    child: const Text('Screen replace'),
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}
