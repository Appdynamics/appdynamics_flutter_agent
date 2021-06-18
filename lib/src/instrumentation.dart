/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/src/agent-configuration.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'globals.dart';

class Instrumentation {
  /// Initializes the agent with the given configuration.
  ///
  /// @param appKey The AppDynamics app key.
  static Future<void> start(AgentConfiguration config) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      String type = "Flutter";

      Map<String, dynamic> arguments = {
        "appKey": config.appKey,
        "loggingLevel": config.loggingLevel?.index,
        "anrDetectionEnabled": true,
        // hardcoded until it's implemented on Android agent too
        "anrStackTraceEnabled": true,
        // hardcoded until it's implemented on Android agent too
        "version": version,
        "type": type,
      }..removeWhere((key, value) => value == null);

      await channel.invokeMethod<void>('start', arguments);
    } on PlatformException catch (e) {
      print("Failed to run agent start(): '${e.message}'");
      throw (e);
    }
  }
}
