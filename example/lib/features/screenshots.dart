/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk_example/utils/flush_beacons_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Screenshots extends StatefulWidget {
  const Screenshots({Key? key}) : super(key: key);

  @override
  _ScreenshotsState createState() => _ScreenshotsState();
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
      appBar: FlushBeaconsAppBar(title: "Screenshots"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 50, left: 50),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              key: Key("takeScreenshotButton"),
              child: Text('Take screenshot'),
              onPressed: _takeScreenshot,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              key: Key("blockScreenshotsButton"),
              child: Text('Block screenshots'),
              onPressed: _blockScreenshots,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              key: Key("unblockScreenshotsButton"),
              child: Text('Unblock screenshots'),
              onPressed: _unblockScreenshots,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              key: Key("checkScreenshotsStatusButton"),
              child: Text('Check screenshots status'),
              onPressed: _checkScreenshotsStatus,
            ),
            SizedBox(
              height: 20,
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
    );
  }
}
