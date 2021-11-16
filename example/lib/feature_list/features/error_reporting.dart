/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:convert';

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorReporting extends StatefulWidget {
  const ErrorReporting({Key? key}) : super(key: key);

  @override
  _ErrorReportingState createState() => _ErrorReportingState();
}

class _ErrorReportingState extends State<ErrorReporting> {
  Future<void> _sendError() async {
    try {
      const myMethod = null;
      myMethod();
    } on NoSuchMethodError catch (e) {
      await Instrumentation.reportError(e,
          severityLevel: ErrorSeverityLevel.critical);
    }
  }

  Future<void> _sendException() async {
    try {
      jsonDecode("invalid/exception/json");
    } on FormatException catch (e) {
      await Instrumentation.reportException(e,
          severityLevel: ErrorSeverityLevel.warning);
    }
  }

  Future<void> _sendMessage() async {
    try {
      jsonDecode("invalid/message/json");
    } on FormatException catch (e) {
      await Instrumentation.reportMessage(e.toString(),
          severityLevel: ErrorSeverityLevel.info);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(
        title: 'Report error',
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  key: const Key("reportErrorButton"),
                  child: const Text('Report error (critical)'),
                  onPressed: _sendError),
              ElevatedButton(
                  key: const Key("reportExceptionButton"),
                  child: const Text('Report exception (warning)'),
                  onPressed: _sendException),
              ElevatedButton(
                  key: const Key("reportMessageButton"),
                  child: const Text('Report message (info)'),
                  onPressed: _sendMessage),
            ],
          ),
        ),
      ),
    );
  }
}
