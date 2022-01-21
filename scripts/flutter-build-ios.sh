#! /bin/sh
#
# Copyright (c) 2021. AppDynamics LLC and its affiliates.
# All rights reserved.
#
#
flutter build ios --simulator

# Current TC artifact path is hardcoded to build/app/reports so we move things there.
cp /build/ios/iphonesimulator build/app/reports