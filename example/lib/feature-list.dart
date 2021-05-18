import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'features/first-feature.dart';
import 'utils/push-with-context.dart';

class FeatureList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feature list'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            ElevatedButton(
              child: Text('Open first feature'),
              onPressed: pushWithContext(context, FirstFeature()),
            ),
          ],
        ),
      ),
    );
  }
}
