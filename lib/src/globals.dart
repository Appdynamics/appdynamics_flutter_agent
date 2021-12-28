/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/services.dart';

// The only channel through which bidirectional communication between Flutter
// and native happens.
const MethodChannel channel = MethodChannel('appdynamics_mobilesdk');

const maxUserDataStringLength = 2048;
