/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:appdynamics_mobilesdk_example/utils/flush_beacons_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserData extends StatefulWidget {
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
      appBar: FlushBeaconsAppBar(title: "Custom timers"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 50, left: 50),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              key: Key("setIntButton"),
              child: Text('Set Int ($intValue)'),
              onPressed: _setInt,
            ),
            ElevatedButton(
              key: Key("removeIntButton"),
              child: Text('Remove Int'),
              onPressed: _removeInt,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              key: Key("setDoubleButton"),
              child: Text('Set Double ($doubleValue)'),
              onPressed: _setDouble,
            ),
            ElevatedButton(
              key: Key("removeDoubleButton"),
              child: Text('Remove Double'),
              onPressed: _removeDouble,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              key: Key("setBoolButton"),
              child: Text('Set Bool ($boolValue)'),
              onPressed: _setBool,
            ),
            ElevatedButton(
              key: Key("removeBoolButton"),
              child: Text('Remove Bool'),
              onPressed: _removeBool,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              key: Key("setStringButton"),
              child: Text('Set string ($stringValue)'),
              onPressed: _setString,
            ),
            ElevatedButton(
              key: Key("removeStringButton"),
              child: Text('Remove String'),
              onPressed: _removeString,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              key: Key("setDateTimeButton"),
              child: Text('Set DateTime (${dateTimeValue.toString()})',
                  textAlign: TextAlign.center),
              onPressed: _setDateTime,
            ),
            ElevatedButton(
              key: Key("removeDateTimeButton"),
              child: Text('Remove DateTime'),
              onPressed: _removeDateTime,
            ),
          ]),
        ),
      ),
    );
  }
}
