/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../utils.dart';
import '../wiremock_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await clearServer();
    await mapAgentInitToReturnSuccess();
  });

  testWidgets("Instrumentation.start() changes screen",
      (WidgetTester tester) async {
    await jumpStartInstrumentation(tester);

    final requests =
        await findRequestsBy(type: "system-event", event: "Agent init");
    expect(requests.length, 1);
  });

  tearDown(() async {
    await clearServer();
  });
}
