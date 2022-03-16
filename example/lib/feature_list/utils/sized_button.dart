/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/material.dart';

class SizedButton extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String keyString;
  final String screenRoute;

  void onPressed() => Navigator.pushNamed(
        context,
        screenRoute,
      );

  const SizedButton(
      {Key? key,
      required this.context,
      required this.title,
      required this.keyString,
      required this.screenRoute})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
            key: Key(keyString), child: Text(title), onPressed: onPressed),
        const SizedBox(height: 10),
      ],
    );
  }
}
