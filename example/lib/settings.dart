import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'feature-list.dart';
import 'utils/push-with-context.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EveryFeature'),
      ),
      body: Center(
        child: Column(children: [
          ElevatedButton(
              onPressed: pushWithContext(context, FeatureList()),
              child: Text('Start instrumentation')),
        ], mainAxisAlignment: MainAxisAlignment.center),
      ),
    );
  }
}
