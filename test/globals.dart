/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const MethodChannel channel = MethodChannel('appdynamics_agent');

void mockPackageInfo() {
  const channel = MethodChannel('dev.fluttercommunity.plus/package_info');
  TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{
        'appName': 'appdynamics_agent',
        'packageName': 'com.appdynamics.eum.appdynamics_agent',
        'version': '1.0.0',
        'buildNumber': '1'
      };
    }
    return null;
  });
}