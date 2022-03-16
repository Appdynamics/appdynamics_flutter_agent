/*
 * Copyright (c) 2022. AppDynamics LLC and its affiliates.
 * All rights reserved.
 *
 */

import 'package:appdynamics_agent_example/app_state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExtraConfigurationsDialog extends StatelessWidget {
  const ExtraConfigurationsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Consumer<AppState>(
                  builder: (context, appState, child) =>
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Crash reporting enabled:"),
                              Checkbox(
                                value: appState.crashReportingEnabled,
                                key: const Key("toggleCrashReportingBox"),
                                onChanged: (bool? newValue) {
                                  appState.crashReportingEnabled = newValue!;
                                },
                              )
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Screenshots enabled:"),
                              Checkbox(
                                value: appState.screenshotsEnabled,
                                key: const Key("toggleScreenshotsBox"),
                                onChanged: (bool? newValue) {
                                  appState.screenshotsEnabled = newValue!;
                                },
                              ),
                            ]),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                    key: const Key("dismissDialogButton"),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close')),
                              ]),
                        )
                      ]))));
    });
  }
}
