/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk_example/feature_list/features/change_app_key.dart';
import 'package:appdynamics_mobilesdk_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:appdynamics_mobilesdk_example/feature_list/utils/sized_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/agent_shutdown.dart';
import 'features/anr.dart';
import 'features/breadcrumbs.dart';
import 'features/custom_metrics.dart';
import 'features/custom_timers.dart';
import 'features/error_reporting.dart';
import 'features/info_points.dart';
import 'features/manual_network_requests.dart';
import 'features/screenshots.dart';
import 'features/session_control.dart';
import 'features/session_frames.dart';
import 'features/user_data.dart';

class FeatureList extends StatelessWidget {
  static const platform = MethodChannel('com.appdynamics.flutter.example');

  const FeatureList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(
        key: Key("featureListAppBar"),
        title: 'Feature list',
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedButton(
                  context: context,
                  title: "ANR",
                  keyString: "anrButton",
                  screen: const Anr()),
              SizedButton(
                  context: context,
                  title: "Manual network requests",
                  keyString: "manualNetworkRequestsButton",
                  screen: const ManualNetworkRequests()),
              SizedButton(
                  context: context,
                  title: "Custom timers",
                  keyString: "customTimersButton",
                  screen: const CustomTimers()),
              SizedButton(
                  context: context,
                  title: "Breadcrumbs",
                  keyString: "breadcrumbsButton",
                  screen: const Breadcrumbs()),
              SizedButton(
                  context: context,
                  title: "Error reporting",
                  keyString: "errorReportingButton",
                  screen: const ErrorReporting()),
              SizedButton(
                  context: context,
                  title: "User data",
                  keyString: "userDataButton",
                  screen: const UserData()),
              SizedButton(
                  context: context,
                  title: "Session frames",
                  keyString: "sessionFramesButton",
                  screen: const SessionFrames()),
              SizedButton(
                  context: context,
                  title: "Custom metrics",
                  keyString: "customMetricsButton",
                  screen: const CustomMetrics()),
              SizedButton(
                  context: context,
                  title: "Screenshots",
                  keyString: "screenshotsButton",
                  screen: const Screenshots()),
              SizedButton(
                  context: context,
                  title: "Agent shutdown",
                  keyString: "agentShutdownButton",
                  screen: const AgentShutdown()),
              SizedButton(
                  context: context,
                  title: "Session control",
                  keyString: "sessionControlButton",
                  screen: const SessionControl()),
              SizedButton(
                  context: context,
                  title: "Info points",
                  keyString: "infoPointsButton",
                  screen: const InfoPoints()),
              SizedButton(
                  context: context,
                  title: "Change app key",
                  keyString: "changeAppKeyButton",
                  screen: const ChangeAppKey()),
              ElevatedButton(
                key: const Key("crashAppButton"),
                child: const Text('Crash app'),
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
