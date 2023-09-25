/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';

class CrashReport {
  final FlutterErrorDetails errorDetails;
  final StackTrace? stackTrace;

  CrashReport({
    required this.errorDetails,
    this.stackTrace,
  });


  @override
  String toString() {
    final hed = {
      "rst": stackTrace.toString(),
      "crt": DateTime.now().toIso8601String(),
      "env": 'Flutter',
      "em": errorDetails.exception.toString()
    };
    return jsonEncode(hed);
  }
}