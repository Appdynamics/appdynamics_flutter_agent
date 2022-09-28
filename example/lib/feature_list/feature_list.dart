/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:appdynamics_agent_example/feature_list/utils/sized_button.dart';
import 'package:appdynamics_agent_example/routing/route_paths.dart';
import 'package:flutter/material.dart';

class FeatureList extends StatelessWidget {
  const FeatureList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const FlushBeaconsAppBar(
          automaticallyImplyLeading: false,
          key: Key("featureListAppBar"),
          title: 'Feature list',
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedButton(
                    context: context,
                    title: "ANR",
                    keyString: "anrButton",
                    screenRoute: RoutePaths.anr),
                SizedButton(
                    context: context,
                    title: "Manual network requests",
                    keyString: "manualNetworkRequestsButton",
                    screenRoute: RoutePaths.manualNetworkRequests),
                SizedButton(
                    context: context,
                    title: "Custom timers",
                    keyString: "customTimersButton",
                    screenRoute: RoutePaths.customTimers),
                SizedButton(
                    context: context,
                    title: "Breadcrumbs",
                    keyString: "breadcrumbsButton",
                    screenRoute: RoutePaths.breadcrumbs),
                SizedButton(
                    context: context,
                    title: "Error reporting",
                    keyString: "errorReportingButton",
                    screenRoute: RoutePaths.errorReporting),
                SizedButton(
                    context: context,
                    title: "User data",
                    keyString: "userDataButton",
                    screenRoute: RoutePaths.userData),
                SizedButton(
                    context: context,
                    title: "Session frames",
                    keyString: "sessionFramesButton",
                    screenRoute: RoutePaths.sessionFrames),
                SizedButton(
                    context: context,
                    title: "Custom metrics",
                    keyString: "customMetricsButton",
                    screenRoute: RoutePaths.customMetrics),
                SizedButton(
                    context: context,
                    title: "Screenshots",
                    keyString: "screenshotsButton",
                    screenRoute: RoutePaths.screenshots),
                SizedButton(
                    context: context,
                    title: "Agent shutdown",
                    keyString: "agentShutdownButton",
                    screenRoute: RoutePaths.agentShutdown),
                SizedButton(
                    context: context,
                    title: "Session control",
                    keyString: "sessionControlButton",
                    screenRoute: RoutePaths.sessionControl),
                SizedButton(
                    context: context,
                    title: "Info points",
                    keyString: "infoPointsButton",
                    screenRoute: RoutePaths.infoPoints),
                SizedButton(
                    context: context,
                    title: "Change app key",
                    keyString: "changeAppKeyButton",
                    screenRoute: RoutePaths.changeAppKey),
                SizedButton(
                    context: context,
                    title: "Activity tracking",
                    keyString: "activityTrackingButton",
                    screenRoute: RoutePaths.activityTracking),
                ElevatedButton(
                  key: const Key("crashAppButton"),
                  child: const Text('Crash app'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    await Instrumentation.crash();
                  },
                ),
              ],
            ),
          ),
        )));
  }
}
