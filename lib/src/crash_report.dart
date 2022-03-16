/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'dart:convert';
import 'dart:core';
import 'dart:isolate';

import 'package:uuid/uuid.dart';

class CrashReport {
  final String message;
  final StackTrace? stackTrace;

  CrashReport({
    required this.message,
    this.stackTrace,
  });

  List getStackFrames(String stackTrace) {
    try {
      final stackFrames = stackTrace
          .split("\n")
          .where((row) => row.trim().isNotEmpty)
          .map((row) {
        final split = row.split(" (");
        final left = split[0].replaceAll(RegExp("\\s+"), " ").split(" ");
        final right = split[1];

        final methodInfo = left[1];
        final split1 = methodInfo.split(".");

        String? type;
        String method;
        if (split1.length == 2) {
          type = split1[0];
          method = split1[1];
        } else {
          method = split1[0];
        }

        final fileInfo = right.substring(0, right.length - 1);
        final split2 = fileInfo.split(":");
        final file = split2[1];
        final line = split2[2];
        final column = split2[3];

        // format imposed by back-end logic.
        final dict = {
          "line": int.parse(line),
          "column": int.parse(column),
          "file": file,
          "method": "Void " + method + "()",
        };

        if (type != null) {
          dict["type"] = "\$." + type;
        }

        return dict;
      });
      return stackFrames.take(5).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  String toString() {
    final stackFrames = getStackFrames(stackTrace.toString());
    final name = Isolate.current.debugName;
    final time = DateTime.now().millisecondsSinceEpoch;
    final targetSite =
        stackFrames.isNotEmpty ? stackFrames.first["method"] : "";
    final guid = const Uuid().v1();

    final dict = {
      "environment": "Flutter",
      "time": time,
      "guid": guid,
      "stackTrace": {
        "exceptionClassName": "Dart exception",
        "message": message,
        "stackFrames": stackFrames,
      },
      "targetSite": targetSite,
      "thread": {"background": false, "id": 1, "name": name, "pool": false},
      "source": "SDK",
    };

    return jsonEncode(dict);
  }
}
