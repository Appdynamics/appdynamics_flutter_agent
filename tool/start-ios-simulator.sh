#! /bin/sh
#
# Copyright (c) 2022. AppDynamics LLC and its affiliates.
# All rights reserved.
#
#

set -x # Show commands as they are run

SIMULATOR_NAME="apple_ios_simulator"

echo "Killing all iOS simulators..."
killall "Simulator"

echo "Starting iOS simulator..."
flutter emulators --launch "$SIMULATOR_NAME"

echo "Waiting for iOS simulator to start..."
sleep 60

echo "Simulator started."
