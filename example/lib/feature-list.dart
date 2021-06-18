/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'features/ANR.dart';
import 'utils/push-with-context.dart';

class FeatureList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: Key("featureListAppBar"),
        title: Text('Feature list'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Test ANR'),
              onPressed: () => pushWithContext(context, ANR()),
            ),
          ],
        ),
      ),
    );
  }
}
