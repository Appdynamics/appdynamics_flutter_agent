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
    final requests =
        await findRequestsBy(type: "system-event", event: "Agent init");
    expect(requests.length, 1);
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    disableHTTPClientOverriding();
    await clearServer();
    await stubServerResponses();
  });

  testWidgets("Instrumentation.start() changes screen",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.assertBeaconSent();
  });

  tearDown(() async {
    await clearServer();
  });
}
