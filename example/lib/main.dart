/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk_example/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state/app_state.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AppState(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Settings());
  }
}
