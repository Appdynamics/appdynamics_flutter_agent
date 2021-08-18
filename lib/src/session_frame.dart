/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/src/globals.dart';
import 'package:flutter/cupertino.dart';

/// Call the private constructor for [SessionFrame].
///
/// We want users to call session frames aPI by _createSessionFrame, not
/// constructors.
SessionFrame createSessionFrame() => SessionFrame._();

class SessionFrame {
  final String id = UniqueKey().toString();

  SessionFrame._();

  /// Updates the session frame with a [newName].
  /// This is generally used when the appropriate name for the Session Frame
  /// is not known at the time of its creation.
  ///
  updateName(String newName) async {
    final arguments = {"newName": newName, "id": this.id};
    await channel.invokeMethod<void>('updateSessionFrameName', arguments);
  }

  /// Reports the end of the session frame.
  /// The [SessionFrame] object will no longer be usable after this call.
  end() async {
    await channel.invokeMethod<void>('endSessionFrame', this.id);
  }
}
