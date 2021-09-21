/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk_example/features/breadcrumbs.dart';
import 'package:appdynamics_mobilesdk_example/features/custom_timers.dart';
import 'package:appdynamics_mobilesdk_example/features/error_reporting.dart';
import 'package:appdynamics_mobilesdk_example/features/manual_network_requests.dart';
import 'package:appdynamics_mobilesdk_example/features/user_data.dart';
import 'package:appdynamics_mobilesdk_example/utils/flush_beacons_app_bar.dart';
import 'package:appdynamics_mobilesdk_example/utils/sized_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/ANR.dart';
import 'features/custom_metrics.dart';
import 'features/screenshots.dart';
import 'features/session_frames.dart';

class FeatureList extends StatelessWidget {
  static const platform =
      const MethodChannel('com.appdynamics.flutter.example');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlushBeaconsAppBar(
        key: Key("featureListAppBar"),
        title: 'Feature list',
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedButton(
                  context: context,
                  title: "ANR",
                  keyString: "anrButton",
                  screen: ANR()),
              SizedButton(
                  context: context,
                  title: "Manual network requests",
                  keyString: "manualNetworkRequestsButton",
                  screen: ManualNetworkRequests()),
              SizedButton(
                  context: context,
                  title: "Custom timers",
                  keyString: "customTimersButton",
                  screen: CustomTimers()),
              SizedButton(
                  context: context,
                  title: "Breadcrumbs",
                  keyString: "breadcrumbsButton",
                  screen: Breadcrumbs()),
              SizedButton(
                  context: context,
                  title: "Error reporting",
                  keyString: "errorReportingButton",
                  screen: ErrorReporting()),
              SizedButton(
                  context: context,
                  title: "User data",
                  keyString: "userDataButton",
                  screen: UserData()),
              SizedButton(
                  context: context,
                  title: "Session frames",
                  keyString: "sessionFramesButton",
                  screen: SessionFrames()),
              SizedButton(
                  context: context,
                  title: "Custom metrics",
                  keyString: "customMetricsButton",
                  screen: CustomMetrics()),
              SizedButton(
                  context: context,
                  title: "Screenshots",
                  keyString: "screenshotsButton",
                  screen: Screenshots()),
              ElevatedButton(
                key: Key("crashAppButton"),
                child: Text('Crash app'),
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: () {
                  platform.invokeMethod("crash");
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
