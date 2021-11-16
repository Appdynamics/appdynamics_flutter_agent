/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_mobilesdk/appdynamics_mobilesdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loading_indicator.dart';

class FlushBeaconsAppBar extends StatefulWidget with PreferredSizeWidget {
  const FlushBeaconsAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _FlushBeaconsAppBarState createState() => _FlushBeaconsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _FlushBeaconsAppBarState extends State<FlushBeaconsAppBar> {
  void _flushBeaconsPressed(BuildContext context) async {
    showLoadingIndicator(context);

    final tracker = await RequestTracker.create("http://flush-beacons.com");
    tracker.setResponseStatusCode(200);
    tracker.reportDone();

    Future.delayed(const Duration(milliseconds: 200), () {
      hideLoadingIndicator(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              key: const Key("flushBeaconButton"),
              onTap: () => _flushBeaconsPressed(context),
              child: const Icon(Icons.refresh),
            )),
      ],
    );
  }
}
