/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:appdynamics_agent_example/feature_list/utils/flush_beacons_app_bar.dart';
import 'package:flutter/material.dart';

class UserData extends StatefulWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  _UserDataState createState() => _UserDataState();
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
                    child: Text('Set Int ($intValue)'),
                    onPressed: _setInt,
                  ),
                  ElevatedButton(
                    key: const Key("removeIntButton"),
                    child: const Text('Remove Int'),
                    onPressed: _removeInt,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    key: const Key("setDoubleButton"),
                    child: Text('Set Double ($doubleValue)'),
                    onPressed: _setDouble,
                  ),
                  ElevatedButton(
                    key: const Key("removeDoubleButton"),
                    child: const Text('Remove Double'),
                    onPressed: _removeDouble,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    key: const Key("setBoolButton"),
                    child: Text('Set Bool ($boolValue)'),
                    onPressed: _setBool,
                  ),
                  ElevatedButton(
                    key: const Key("removeBoolButton"),
                    child: const Text('Remove Bool'),
                    onPressed: _removeBool,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    key: const Key("setStringButton"),
                    child: Text('Set string ($stringValue)'),
                    onPressed: _setString,
                  ),
                  ElevatedButton(
                    key: const Key("removeStringButton"),
                    child: const Text('Remove String'),
                    onPressed: _removeString,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    key: const Key("setDateTimeButton"),
                    child: Text('Set DateTime (${dateTimeValue.toString()})',
                        textAlign: TextAlign.center),
                    onPressed: _setDateTime,
                  ),
                  ElevatedButton(
                    key: const Key("removeDateTimeButton"),
                    child: const Text('Remove DateTime'),
                    onPressed: _removeDateTime,
                  ),
                ]),
          ),
        ),
      ]),
    );
  }
}
