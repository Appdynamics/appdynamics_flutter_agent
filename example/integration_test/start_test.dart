/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk_example/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Instrumentation.start() changes screen",
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    final startButtonFinder = find.byKey(Key("startInstrumentationButton"));

    expect(startButtonFinder, findsOneWidget);

    final featureListBarFinder = find.byKey(Key("featureListAppBar"));
    expect(featureListBarFinder, findsNothing);

    await tester.tap(startButtonFinder);
    await tester.pumpAndSettle();

    expect(featureListBarFinder, findsOneWidget);
  });
}
