#! /bin/sh
#
# Copyright (c) 2021. AppDynamics LLC and its affiliates.
# All rights reserved.
#
#

# For debugging purposes
flutter devices

flutter build ios --simulator

# Current TC artifact path is hardcoded to build/app/reports so we move things there.
cp -r build/ios/iphonesimulator/Runner.app build/app/reports