/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:appdynamics_agent/src/utils/date_utils.dart';

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
      "crt": DateUtils.convertDateTimeToLong(DateTime.now()),
      "env": 'Flutter',
      "em": errorDetails.exception.toString()
    };
    return jsonEncode(hed);
  }
}
