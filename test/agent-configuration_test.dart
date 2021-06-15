/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk/src/agent-configuration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('did update property both in class and copyWith()', () async {
    AgentConfiguration config =
        AgentConfiguration(appKey: "foo", loggingLevel: LoggingLevel.none);
    AgentConfiguration config2 = config.copyWith();

    expect(config.appKey, config2.appKey);
    expect(config.loggingLevel, config2.loggingLevel);
  });
}
