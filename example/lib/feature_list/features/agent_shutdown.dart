/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/material.dart';

class AgentShutdown extends StatelessWidget {
  const AgentShutdown({Key? key}) : super(key: key);

  _shutdownAgent() async {
    await Instrumentation.shutdownAgent();
  }

  _restartAgent() async {
    await Instrumentation.restartAgent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(title: "Agent shutdown"),
      body: ListView(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    key: const Key("shutdownAgentButton"),
                    child: const Text('Shutdown agent',
                        textAlign: TextAlign.center),
                    onPressed: _shutdownAgent,
                  ),
                  ElevatedButton(
                    key: const Key("restartAgentButton"),
                    child: const Text('Restart agent',
                        textAlign: TextAlign.center),
                    onPressed: _restartAgent,
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}
