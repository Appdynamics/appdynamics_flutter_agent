import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Function() pushWithContext(BuildContext context, Widget widget) {
  return () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  };
}
