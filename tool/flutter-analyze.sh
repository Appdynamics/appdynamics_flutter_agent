#! /bin/sh
#
# Copyright (c) 2022. AppDynamics LLC and its affiliates.
# All rights reserved.
#
#
ls -1 /Applications | grep -i xcode
xcrun simctl list runtimes
xcodebuild -showsdks
xcode-select --print-path
flutter analyze