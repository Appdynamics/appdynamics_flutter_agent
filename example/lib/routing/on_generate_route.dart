/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent_example/feature_list/feature_list.dart';
import 'package:appdynamics_agent_example/feature_list/features/activity_tracking/activity_tracking.dart';
import 'package:appdynamics_agent_example/feature_list/features/activity_tracking/activity_tracking_push.dart';
import 'package:appdynamics_agent_example/feature_list/features/activity_tracking/activity_tracking_replace.dart';
import 'package:appdynamics_agent_example/feature_list/features/agent_shutdown.dart';
import 'package:appdynamics_agent_example/feature_list/features/anr.dart';
import 'package:appdynamics_agent_example/feature_list/features/breadcrumbs.dart';
import 'package:appdynamics_agent_example/feature_list/features/change_app_key.dart';
import 'package:appdynamics_agent_example/feature_list/features/custom_metrics.dart';
import 'package:appdynamics_agent_example/feature_list/features/custom_timers.dart';
import 'package:appdynamics_agent_example/feature_list/features/error_reporting.dart';
import 'package:appdynamics_agent_example/feature_list/features/info_points.dart';
import 'package:appdynamics_agent_example/feature_list/features/manual_network_requests.dart';
import 'package:appdynamics_agent_example/feature_list/features/screenshots.dart';
import 'package:appdynamics_agent_example/feature_list/features/session_control.dart';
import 'package:appdynamics_agent_example/feature_list/features/session_frames.dart';
import 'package:appdynamics_agent_example/feature_list/features/user_data.dart';
import 'package:appdynamics_agent_example/routing/route_paths.dart';
import 'package:appdynamics_agent_example/settings/settings.dart';
import 'package:flutter/material.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  // CDM-9408 TODO: Find way to assert routeWidgets are in sync with RoutePaths.
  // String enums should be a solution:
  // https://github.com/dart-lang/language/issues/158
  const routeWidgets = {
    RoutePaths.settings: Settings(),
    RoutePaths.featureList: FeatureList(),
    RoutePaths.anr: Anr(),
    RoutePaths.manualNetworkRequests: ManualNetworkRequests(),
    RoutePaths.customTimers: CustomTimers(),
    RoutePaths.breadcrumbs: Breadcrumbs(),
    RoutePaths.errorReporting: ErrorReporting(),
    RoutePaths.userData: UserData(),
    RoutePaths.sessionFrames: SessionFrames(),
    RoutePaths.customMetrics: CustomMetrics(),
    RoutePaths.screenshots: Screenshots(),
    RoutePaths.agentShutdown: AgentShutdown(),
    RoutePaths.sessionControl: SessionControl(),
    RoutePaths.infoPoints: InfoPoints(),
    RoutePaths.changeAppKey: ChangeAppKey(),
    RoutePaths.activityTracking: ActivityTracking(),
    RoutePaths.activityTrackingPush: ActivityTrackingPush(),
    RoutePaths.activityTrackingReplace: ActivityTrackingReplace(),
  };

  if (routeWidgets[settings.name] == null) {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ));
  }

  return MaterialPageRoute(
      builder: (_) => routeWidgets[settings.name]!, settings: settings);
}
