/*
 * Copyright (c) 2021. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizedButton extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String keyString;
  final Widget screen;

  void onPressed() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );

  const SizedButton(
      {Key? key,
      required this.context,
      required this.title,
      required this.keyString,
      required this.screen})
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
