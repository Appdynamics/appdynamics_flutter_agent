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
  assertCrashAndSessionBeaconSent() async {
    final requests = await findRequestsBy(
        text: "A crash and session breadcrumb.", type: "breadcrumb");
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

  testWidgets("Check crash and session breadcrumbs are properly reported",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("breadcrumbsButton");
    await tester.tapAndSettle("leaveBreadcrumbCrashAndSessionButton");
    await tester.flushBeacons();
    await tester.assertCrashAndSessionBeaconSent();
  });

  // CDM-7728 TODO: Add Check Crash Only breadcrumbs when we will be able to crash
  // flutter driver and still restart the app

  tearDown(() async {
    await clearServer();
  });
}
