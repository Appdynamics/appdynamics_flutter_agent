/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/material.dart';

class CrashReportDialog extends StatelessWidget {
  final String crashReports;

  const CrashReportDialog({required this.crashReports, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crash reports detected'),
      content: SingleChildScrollView(
          child: ListBody(children: [Text(crashReports)])),
      actions: [
        TextButton(
          child: const Text('Back'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
