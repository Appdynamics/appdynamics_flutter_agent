/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:convert';
import 'dart:core';
import 'dart:isolate';

import 'package:flutter/foundation.dart';

class AppDynamicsStackFrame {
  final int line;
  final int column;
  final String fileName;
  final String methodName;
  String? type;

  AppDynamicsStackFrame(
      {required this.line,
      required this.column,
      required this.fileName,
      required this.methodName,
      this.type});

  AppDynamicsStackFrame.fromJson(Map<String, dynamic> json)
      : line = json['line'],
        column = json['column'],
        fileName = json['fileName'],
        methodName = json['methodName'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        "line": line,
        "column": column,
        "fileName": fileName,
        "methodName": methodName,
        "type": type
      };
}

class NativeCrashReport {
  final FlutterErrorDetails errorDetails;
  final StackTrace? stackTrace;

  NativeCrashReport({
    required this.errorDetails,
    this.stackTrace,
  });

  List<AppDynamicsStackFrame> getStackFrames(StackTrace stackTrace) {
    List<StackFrame> frames = StackFrame.fromStackTrace(stackTrace);
    List<AppDynamicsStackFrame> appdFrames = [];
    for (StackFrame frame in frames) {
      String fileName = frame.packagePath;
      String longFileName = "${frame.packageScheme}:${frame.package}/$fileName";
      String backendAcceptedMethodFormat = "Void ${frame.method}()";
      final AppDynamicsStackFrame appdFrame = AppDynamicsStackFrame(
        line: frame.line,
        column: frame.column,
        fileName: longFileName,
        methodName: backendAcceptedMethodFormat,
      );

      if (frame.className.isNotEmpty) {
        String backendAcceptedClassFormat = "\$.${frame.className}";
        appdFrame.type = backendAcceptedClassFormat;
      }

      appdFrames.add(appdFrame);
    }
    return appdFrames;
  }

  @override
  String toString() {
    final name = Isolate.current.debugName;
    final time = DateTime.now().millisecondsSinceEpoch;
    final dict = {
      "environment": "Flutter",
      "time": time,
      "thread": {"background": false, "id": 1, "name": name, "pool": false},
      "source": "SDK",
    };

    if (stackTrace != null) {
      final stackFrames = getStackFrames(stackTrace!);

      dict["stackTrace"] = {
        "exceptionClassName": errorDetails.exception.runtimeType.toString(),
        "message": errorDetails.exceptionAsString(),
        "stackFrames": stackFrames,
      };
      dict["targetSite"] = stackFrames.first.methodName;
    }
    return jsonEncode(dict);
  }
}
