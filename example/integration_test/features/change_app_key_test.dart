/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../tester_utils.dart';
import '../wiremock_utils.dart';

extension on WidgetTester {
  static String validKey = "AA-BBB-CCC";
  static String invalidKey = "123456";

  enterInvalidKey() async {
    final requestTextField = find.byKey(const Key("newKeyTextField"));
    expect(requestTextField, findsOneWidget);

    await enterText(requestTextField, invalidKey);
  }

  enterValidKey() async {
    final requestTextField = find.byKey(const Key("newKeyTextField"));
    expect(requestTextField, findsOneWidget);

    await enterText(requestTextField, validKey);
  }

  assertExceptionCaught() async {
    final errorText = find.byKey(const Key("errorText"));
    expect(errorText, findsOneWidget);
  }

  assertBeaconSent() async {
    final errorText = find.byKey(const Key("errorText"));
    expect(errorText, findsNothing);

    final requests = await findRequestsBy();
    final headers = getBeaconRequestHeaders(requests[0]);
    expect(headers["ky"], validKey);
  }
}

void main() {
  setUp(() async {
    disableHTTPClientOverriding();
    await clearServer();
    await stubServerResponses();
  });

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Check app key change is properly reported",
      (WidgetTester tester) async {
    await tester.jumpstartInstrumentation();
    await tester.tapAndSettle("changeAppKeyButton");
    await tester.enterInvalidKey();
    await tester.tapAndSettle("setKeyButton");
    await tester.assertExceptionCaught();
    await tester.enterValidKey();
    await tester.tapAndSettle("setKeyButton");
    await tester.flushBeacons();
    await tester.assertBeaconSent();
  });

  tearDown(() async {
    await clearServer();
  });
}
