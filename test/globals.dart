/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/services.dart';

const MethodChannel channel = const MethodChannel('appdynamics_mobilesdk');

void mockPackageInfo() {
  const MethodChannel('dev.fluttercommunity.plus/package_info')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{
        'appName': 'appdynamics_mobilesdk',
        'packageName': 'com.appdynamics.eum.appdynamics_mobilesdk',
        'version': '1.0.0',
        'buildNumber': '1'
      };
    }
    return null;
  });
}
