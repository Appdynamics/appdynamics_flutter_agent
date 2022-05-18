#! /bin/sh
#
# Copyright (c) 2022. AppDynamics LLC and its affiliates.
# All rights reserved.
#
#

# For debugging purposes
flutter devices --device-timeout=500
flutter emulators

cd ios
pod repo add-cdn trunk https://github.com/CocoaPods/Specs.git
cd ..

flutter build ios --simulator

# Remove residual ios/.symlink folder because it's problematic to TC artifacts.
rm -rf ios/.symlinks

# Current TC artifact path is hardcoded to build/app/reports so we move things there.
mkdir -p build/app/reports
cp -r build/ios/iphonesimulator/Runner.app build/app/reports
