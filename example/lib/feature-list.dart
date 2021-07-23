/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk_example/features/custom-timers.dart';
import 'package:appdynamics_mobilesdk_example/features/manual-network-requests.dart';
import 'package:appdynamics_mobilesdk_example/utils/flush-beacons-app-bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'features/ANR.dart';
import 'utils/push-with-context.dart';

class FeatureList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlushBeaconsAppBar(
        key: Key("featureListAppBar"),
        title: 'Feature list',
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30),
              ElevatedButton(
                child: Text('ANR'),
                onPressed: () => pushWithContext(context, ANR()),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text('Manual network requests'),
                key: Key("manualNetworkRequestsButton"),
                onPressed: () =>
                    pushWithContext(context, ManualNetworkRequests()),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                child: Text('Custom timers'),
                key: Key("customTimersButton"),
                onPressed: () => pushWithContext(context, CustomTimers()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
