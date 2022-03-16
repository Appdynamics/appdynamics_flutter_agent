/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoPoints extends StatelessWidget {
  const InfoPoints({Key? key}) : super(key: key);
  static const platform = MethodChannel('com.appdynamics.flutter.example');

  Future<void> _trackManualSyncCall() async {
    final result = await Instrumentation.trackCall(
        className: "InfoPoints",
        methodName: "_trackManualSyncCall",
        methodArgs: [1, 2],
        methodBody: () {
          return 1 + 2;
        });

    assert(result == 3);
  }

  Future<void> _trackManualAsyncCall() async {
    final result = await Instrumentation.trackCall(
        className: "InfoPoints",
        methodName: "_trackManualAsyncCall",
        methodArgs: [1, 2],
        methodBody: () async {
          return await Future.delayed(const Duration(milliseconds: 10), () {
            return 1 + 2;
          });
        });

    assert(result == 3);
  }

  Future<void> _trackManualAsyncException() async {
    await Instrumentation.trackCall(
        className: "InfoPoints",
        methodName: "_trackManualAsyncException",
        methodBody: () async {
          return await Future.delayed(const Duration(milliseconds: 10), () {
            throw Exception("trackCall async exception");
          });
        });
  }

  Future<void> _trackManualSyncError() async {
    await Instrumentation.trackCall(
        className: "InfoPoints",
        methodName: "_trackManualSyncError",
        methodBody: () {
          throw Error();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(title: "Info points"),
      body: ListView(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    key: const Key("manualSyncCallButton"),
                    child: const Text('Track manual sync call',
                        textAlign: TextAlign.center),
                    onPressed: _trackManualSyncCall,
                  ),
                  ElevatedButton(
                    key: const Key("manualAsyncCallButton"),
                    child: const Text('Track manual async call',
                        textAlign: TextAlign.center),
                    onPressed: _trackManualAsyncCall,
                  ),
                  ElevatedButton(
                    key: const Key("manualAsyncExceptionButton"),
                    child: const Text('Track manual async exception',
                        textAlign: TextAlign.center),
                    onPressed: _trackManualAsyncException,
                  ),
                  ElevatedButton(
                    key: const Key("manualSyncErrorButton"),
                    child: const Text('Track manual sync error',
                        textAlign: TextAlign.center),
                    onPressed: _trackManualSyncError,
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}
