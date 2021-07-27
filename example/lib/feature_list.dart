/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk_example/features/breadcrumbs.dart';
import 'package:appdynamics_mobilesdk_example/features/custom_timers.dart';
import 'package:appdynamics_mobilesdk_example/features/manual_network_requests.dart';
import 'package:appdynamics_mobilesdk_example/utils/flush_beacons_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'features/ANR.dart';
import 'features/error_reporting.dart';

class FeatureList extends StatelessWidget {
  String _convertSentenceToCamelCase(String text) {
    final split = text.split(" ");
    final lowerCased = split[0].toLowerCase();
    split.removeAt(0);
    final capitalized =
        split.map((e) => "${e[0].toUpperCase()}${e.substring(1)}").toList();
    return [lowerCased, ...capitalized].join("");
  }

  Widget _createSizedButton(BuildContext context, String title, Widget screen) {
    final camelCase = _convertSentenceToCamelCase(title);
    final keyString = "${camelCase}Button";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 10),
        ElevatedButton(
            key: Key(keyString),
            child: Text(title),
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FlushBeaconsAppBar(
        key: Key("featureListAppBar"),
        title: 'Feature list',
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
          child: Column(
            children: [
              _createSizedButton(context, "ANR", ANR()),
              _createSizedButton(
                  context, "Manual network requests", ManualNetworkRequests()),
              _createSizedButton(context, "Custom timers", CustomTimers()),
              _createSizedButton(context, "Breadcrumbs", Breadcrumbs()),
              _createSizedButton(context, "Error reporting", ErrorReporting()),
            ],
          ),
        ),
      ),
    );
  }
}
