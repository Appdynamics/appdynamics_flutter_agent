/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/material.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final intValue = 1234;
  final doubleValue = 123.456;
  final boolValue = true;
  final stringValue = "test string";
  final dateTimeValue = DateTime.utc(2021);

  Future<void> _setInt() async {
    await Instrumentation.setUserDataInt("intKey", intValue);
  }

  Future<void> _removeInt() async {
    await Instrumentation.removeUserDataInt("intKey");
  }

  Future<void> _setDouble() async {
    await Instrumentation.setUserDataDouble("doubleKey", doubleValue);
  }

  Future<void> _removeDouble() async {
    await Instrumentation.removeUserDataDouble("doubleKey");
  }

  Future<void> _setBool() async {
    await Instrumentation.setUserDataBool("boolKey", boolValue);
  }

  Future<void> _removeBool() async {
    await Instrumentation.removeUserDataBool("boolKey");
  }

  Future<void> _setString() async {
    await Instrumentation.setUserData("stringKey", stringValue);
  }

  Future<void> _removeString() async {
    await Instrumentation.removeUserData("stringKey");
  }

  Future<void> _setDateTime() async {
    await Instrumentation.setUserDataDateTime("dateTimeKey", dateTimeValue);
  }

  Future<void> _removeDateTime() async {
    await Instrumentation.removeUserDataDateTime("dateTimeKey");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FlushBeaconsAppBar(title: "Custom timers"),
      body: ListView(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    key: const Key("setIntButton"),
                    onPressed: _setInt,
                    child: Text('Set Int ($intValue)'),
                  ),
                  ElevatedButton(
                    key: const Key("removeIntButton"),
                    onPressed: _removeInt,
                    child: const Text('Remove Int'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    key: const Key("setDoubleButton"),
                    onPressed: _setDouble,
                    child: Text('Set Double ($doubleValue)'),
                  ),
                  ElevatedButton(
                    key: const Key("removeDoubleButton"),
                    onPressed: _removeDouble,
                    child: const Text('Remove Double'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    key: const Key("setBoolButton"),
                    onPressed: _setBool,
                    child: Text('Set Bool ($boolValue)'),
                  ),
                  ElevatedButton(
                    key: const Key("removeBoolButton"),
                    onPressed: _removeBool,
                    child: const Text('Remove Bool'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    key: const Key("setStringButton"),
                    onPressed: _setString,
                    child: Text('Set string ($stringValue)'),
                  ),
                  ElevatedButton(
                    key: const Key("removeStringButton"),
                    onPressed: _removeString,
                    child: const Text('Remove String'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    key: const Key("setDateTimeButton"),
                    onPressed: _setDateTime,
                    child: Text('Set DateTime (${dateTimeValue.toString()})',
                        textAlign: TextAlign.center),
                  ),
                  ElevatedButton(
                    key: const Key("removeDateTimeButton"),
                    onPressed: _removeDateTime,
                    child: const Text('Remove DateTime'),
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}
