#! /bin/sh
#
# Copyright (c) 2025. Splunk AppDynamics LLC and its affiliates.
# All rights reserved.
#
#
sudo xcode-select -s /Applications/Xcode-15.2.app/Contents/Developer
flutter upgrade --force
flutter test --coverage
