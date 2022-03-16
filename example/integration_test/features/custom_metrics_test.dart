/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../tester_utils.dart';
import '../wiremock_utils.dart';

extension on WidgetTester {
  assertBeaconSent() async {
    final requests = await findRequestsBy(
        type: "custom-metric-event",
        metricName: "myCustomMetric",
        metricValue: "123");
    expect(requests.length, 1);
  }
}

void main() {
  setUp(() async {
    disableHTTPClientOverriding();
    await clearServer();
    await stubServerResponses();
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Check custom metrics are properly reported",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("customMetricsButton");
    await tester.tapAndSettle("reportMetricButton");
    await tester.flushBeacons();
    await tester.assertBeaconSent();
  });

  tearDown(() async {
    await clearServer();
  });
}
