/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/src/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// Hiding the private constructor for [SessionFrame]. We want users to call
/// session frames API by [createSessionFrame], not constructors.
SessionFrame createSessionFrame() => SessionFrame._();

/// Object used to chronicle user flows during an app session.
class SessionFrame {
  final String id = UniqueKey().toString();

  SessionFrame._();

  /// Updates the session frame with a [newName].
  /// This is generally used when the appropriate name for the Session Frame is
  /// not known at the time of its creation.
  ///
  /// Method might throw [Exception].
  Future<void> updateName(String newName) async {
    try {
      final arguments = {"newName": newName, "id": id};
      await channel.invokeMethod<void>('updateSessionFrameName', arguments);
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }

  /// Reports the end of the session frame.
  /// The [SessionFrame] object will no longer be usable after this call.
  ///
  /// Method might throw [Exception].
  Future<void> end() async {
    try {
      await channel.invokeMethod<void>('endSessionFrame', id);
    } on PlatformException catch (e) {
      throw Exception(e.details);
    }
  }
}
