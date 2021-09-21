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

  testWidgets("Check crash and session breadcrumbs are properly reported",
      (WidgetTester tester) async {
    await jumpStartInstrumentation(tester);

    final breadcrumbsButton = find.byKey(const Key("breadcrumbsButton"));
    await tester.scrollUntilVisible(breadcrumbsButton, 10);
    expect(breadcrumbsButton, findsOneWidget);

    await tester.tap(breadcrumbsButton);
    await tester.pumpAndSettle();

    final leaveBreadcrumbCrashAndSessionButton =
        find.byKey(const Key("leaveBreadcrumbCrashAndSessionButton"));
    expect(leaveBreadcrumbCrashAndSessionButton, findsOneWidget);

    await tester.tap(leaveBreadcrumbCrashAndSessionButton);
    await tester.pumpAndSettle();

    await flushBeacons();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final requests = await findRequestsBy(
        text: "A crash and session breadcrumb.", type: "breadcrumb");
    expect(requests.length, 1);
  });

  // TODO: Add Check Crash Only breadcrumbs when crash reporting is implemented

  tearDown(() async {
    await clearServer();
  });
}
