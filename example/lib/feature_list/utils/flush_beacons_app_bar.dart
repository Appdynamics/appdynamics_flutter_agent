/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent/appdynamics_agent.dart';
import 'package:flutter/material.dart';

import 'loading_indicator.dart';

class FlushBeaconsAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool automaticallyImplyLeading;

  const FlushBeaconsAppBar({
    Key? key,
    required this.title,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  _FlushBeaconsAppBarState createState() => _FlushBeaconsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _FlushBeaconsAppBarState extends State<FlushBeaconsAppBar> {
  void _flushBeaconsPressed(BuildContext context) async {
    showLoadingIndicator(context);

    final tracker = await RequestTracker.create("http://send-beacons.com");
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
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              key: const Key("flushBeaconButton"),
              onTap: () => _flushBeaconsPressed(context),
              child: const Icon(Icons.refresh, semanticLabel: 'Flush'),
            )),
      ],
    );
  }
}
