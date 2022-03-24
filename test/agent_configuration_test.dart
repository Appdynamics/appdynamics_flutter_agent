/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent/src/agent_configuration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('did update property both in class and copyWith()',
      (WidgetTester tester) async {
    AgentConfiguration config =
        AgentConfiguration(appKey: "foo", loggingLevel: LoggingLevel.none);
    AgentConfiguration config2 = config.copyWith(appKey: 'newAppKey');
    expect(config.appKey, isNot(config2.appKey));
    expect(config.loggingLevel, config2.loggingLevel);
    expect(config.collectorURL, config2.collectorURL);
    expect(config.screenshotURL, config2.screenshotURL);
    expect(config.screenshotsEnabled, config2.screenshotsEnabled);
    expect(config.crashReportCallback, config2.crashReportCallback);
    expect(config.crashReportingEnabled, config2.crashReportingEnabled);
    expect(config.applicationName, config2.applicationName);

    AgentConfiguration config3 =
        config.copyWith(loggingLevel: LoggingLevel.info);
    expect(config.appKey, config3.appKey);
  });
}
