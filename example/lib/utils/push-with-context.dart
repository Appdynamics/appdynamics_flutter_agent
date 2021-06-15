/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void pushWithContext(BuildContext context, Widget widget) async {
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}
