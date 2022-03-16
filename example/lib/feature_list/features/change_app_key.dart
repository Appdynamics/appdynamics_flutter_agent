/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/app_state/app_state.dart';
import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeAppKey extends StatefulWidget {
  const ChangeAppKey({Key? key}) : super(key: key);

  @override
  _ChangeAppKeyState createState() => _ChangeAppKeyState();
}

class _ChangeAppKeyState extends State<ChangeAppKey> {
  final TextEditingController _newKeyFieldController = TextEditingController();
  var errorText = "";

  void _setNewKey() async {
    final newKey = _newKeyFieldController.text.trim();

    if (newKey.isEmpty) {
      return;
    }

    try {
      await Instrumentation.changeAppKey(newKey);

      final appState = Provider.of<AppState>(context, listen: false);
      appState.appKey = newKey;

      setState(() {
        errorText = "";
      });
    } catch (e) {
      setState(() {
        errorText = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _newKeyFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(title: "Change app key"),
      body: ListView(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Consumer<AppState>(
                      builder: (context, appState, child) =>
                          Text('Current app key: ${appState.appKey}')),
                  const SizedBox(height: 35),
                  TextFormField(
                    key: const Key("newKeyTextField"),
                    controller: _newKeyFieldController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter new app key',
                        hintText: 'AA-BBB-CCC'),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    key: const Key("setKeyButton"),
                    child:
                        const Text('Set new key', textAlign: TextAlign.center),
                    onPressed: _setNewKey,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Visibility(
                    child: Text(
                      errorText,
                      key: const Key("errorText"),
                      textAlign: TextAlign.center,
                    ),
                    visible: errorText.isNotEmpty,
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}
