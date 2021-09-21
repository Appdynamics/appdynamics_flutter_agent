/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils.dart';
import '../wiremock_utils.dart';

void main() {
  setUp(() async {
    await clearServer();
    await mapAgentInitToReturnSuccess();
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Check custom metrics are properly reported",
      (WidgetTester tester) async {
    const customMetricName = "myCustomMetric";
    const customMetricValue = "123";

    await jumpStartInstrumentation(tester);

    final customMetricsButton = find.byKey(const Key("customMetricsButton"));
    await tester.scrollUntilVisible(customMetricsButton, 10);
    expect(customMetricsButton, findsOneWidget);

    await tester.tap(customMetricsButton);
    await tester.pumpAndSettle();

    final reportMetricButton = find.byKey(const Key("reportMetricButton"));
    expect(reportMetricButton, findsOneWidget);

    await tester.tap(reportMetricButton);
    await flushBeacons();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final requests = await findRequestsBy(
        type: "custom-metric-event",
        metricName: customMetricName,
        metricValue: customMetricValue);
    expect(requests.length, 1);
  });

  tearDown(() async {
    await clearServer();
  });
}
