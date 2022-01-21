#! /bin/sh
#
# Copyright (c) 2021. AppDynamics LLC and its affiliates.
# All rights reserved.
#
# macOS expected
brew tap dart-lang/dart
brew install dart
dart pub global activate dhttpd
dhttpd --path doc/api
open http://localhost:8080