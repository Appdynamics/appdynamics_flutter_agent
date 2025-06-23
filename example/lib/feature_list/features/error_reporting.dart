/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:convert';

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/material.dart';

class ErrorReporting extends StatefulWidget {
  const ErrorReporting({super.key});

  @override
  State<ErrorReporting> createState() => _ErrorReportingState();
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
    } on FormatException catch (e, stackTrace) {
      await Instrumentation.reportException(e,
          severityLevel: ErrorSeverityLevel.warning, stackTrace: stackTrace);
    }
  }

  Future<void> _sendMessage() async {
    try {
      jsonDecode("invalid/message/json");
    } on FormatException catch (e, stackTrace) {
      await Instrumentation.reportMessage(e.toString(),
          severityLevel: ErrorSeverityLevel.info, stackTrace: stackTrace);
    }
  }

  // for testing automatic Flutter exception detection
  void _throwFlutterException() {
    throw Exception("My Flutter exception");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(
        title: 'Report error',
      ),
      body: ListView(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    key: const Key("reportErrorButton"),
                    onPressed: _sendError,
                    child: const Text('Report error (critical)')),
                ElevatedButton(
                    key: const Key("reportExceptionButton"),
                    onPressed: _sendException,
                    child: const Text('Report exception (warning)')),
                ElevatedButton(
                    key: const Key("reportMessageButton"),
                    onPressed: _sendMessage,
                    child: const Text('Report message (info)')),
                ElevatedButton(
                    key: const Key("throwFlutterExceptionButton"),
                    onPressed: _throwFlutterException,
                    child: const Text('Throw Flutter exception'))
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
