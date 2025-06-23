/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/material.dart';

class Screenshots extends StatefulWidget {
  const Screenshots({super.key});

  @override
  State<Screenshots> createState() => _ScreenshotsState();
}

class _ScreenshotsState extends State<Screenshots> {
  bool? screenshotsStatus;

  @override
  void initState() {
    _checkScreenshotsStatus();
    super.initState();
  }

  Future<void> _takeScreenshot() async {
    await Instrumentation.takeScreenshot();
  }

  Future<void> _blockScreenshots() async {
    await Instrumentation.blockScreenshots();
    await _checkScreenshotsStatus();
  }

  Future<void> _unblockScreenshots() async {
    await Instrumentation.unblockScreenshots();
    await _checkScreenshotsStatus();
  }

  Future<void> _checkScreenshotsStatus() async {
    final status = await Instrumentation.screenshotsBlocked();
    setState(() {
      screenshotsStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(title: "Screenshots"),
      body: ListView(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    key: const Key("takeScreenshotButton"),
                    onPressed: _takeScreenshot,
                    child: const Text('Take screenshot'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    key: const Key("blockScreenshotsButton"),
                    onPressed: _blockScreenshots,
                    child: const Text('Block screenshots'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    key: const Key("unblockScreenshotsButton"),
                    onPressed: _unblockScreenshots,
                    child: const Text('Unblock screenshots'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    key: const Key("checkScreenshotsStatusButton"),
                    onPressed: _checkScreenshotsStatus,
                    child: const Text('Check screenshots status'),
                  ),
                  Text(
                    () {
                      final status = screenshotsStatus;
                      if (status == null) {
                        return "Screenshot status: unknown";
                      }
                      return "Screenshot status: ${status ? "blocked" : "unblocked"}";
                    }(),
                    textAlign: TextAlign.center,
                  )
                ]),
          ),
        ),
      ]),
    );
  }
}
