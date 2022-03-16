/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/material.dart';

class CustomMetrics extends StatelessWidget {
  final customMetricName = "myCustomMetric";
  final customMetricValue = 123;

  const CustomMetrics({Key? key}) : super(key: key);

  Future<void> _reportMetric() async {
    await Instrumentation.reportMetric(
        name: customMetricName, value: customMetricValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(title: "Custom metrics"),
      body: ListView(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    key: const Key("reportMetricButton"),
                    child: Text(
                        'Report metric \n(name: $customMetricName, value: $customMetricValue)',
                        textAlign: TextAlign.center),
                    onPressed: _reportMetric,
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}
