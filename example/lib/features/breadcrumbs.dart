/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk_example/utils/flush-beacons-app-bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Breadcrumbs extends StatefulWidget {
  @override
  _BreadcrumbsState createState() => _BreadcrumbsState();
}

class _BreadcrumbsState extends State<Breadcrumbs> {
  Future<void> _leaveCrashOnlyBreadcrumbPressed() async {
    try {
      await Instrumentation.leaveBreadcrumb(
          "A crash only breadcrumb.", BreadcrumbVisibility.CRASHES_ONLY);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _leaveCrashAndSessionBreadcrumbPressed() async {
    try {
      await Instrumentation.leaveBreadcrumb("A crash and session breadcrumb.",
          BreadcrumbVisibility.CRASHES_AND_SESSIONS);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlushBeaconsAppBar(title: "Breadcrumbs"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 50, left: 50),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              key: Key("leaveBreadcrumbCrashButton"),
              child: Text('Leave crashes only breadcrumb'),
              onPressed: _leaveCrashOnlyBreadcrumbPressed,
            ),
            ElevatedButton(
              key: Key("leaveBreadcrumbCrashAndSessionButton"),
              child: Text('Leave crashes and sessions breadcrumb',
                  textAlign: TextAlign.center),
              onPressed: _leaveCrashAndSessionBreadcrumbPressed,
            ),
          ]),
        ),
      ),
    );
  }
}
