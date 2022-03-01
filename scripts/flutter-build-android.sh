#! /bin/sh
#
# Copyright (c) 2021. AppDynamics LLC and its affiliates.
# All rights reserved.
#
#
flutter build apk

# Current TC artifact path is hardcoded to build/app/reports so we move things there.
mkdir -p build/app/reports
cp build/app/outputs/flutter-apk/app-release.apk build/app/reports