#! /bin/sh
#
# Copyright (c) 2021. AppDynamics LLC and its affiliates.
# All rights reserved.
#

set -x # Show commands as they are run

EMULATOR_NAME="AUTOMATION_AVD_x86_64"
ADB=$ANDROID_HOME/platform-tools/adb

readonly WAIT_LOOP_TIME=5 # seconds
readonly MAX_EMULATOR_WAIT_TIME=120 # seconds

echo "Starting Android simulator..."
flutter emulators --launch "$EMULATOR_NAME"

echo "Waiting for emulator to be initialized..."
REMAINING_TIME=${MAX_EMULATOR_WAIT_TIME}
while ! $ADB get-state; do
    if [ ${REMAINING_TIME} -le 0 ]; then
        echo "Failed to start emulator"
        exit 1
    fi
    echo "Keep trying for ${REMAINING_TIME} more seconds"
    sleep ${WAIT_LOOP_TIME}
    let REMAINING_TIME=REMAINING_TIME-${WAIT_LOOP_TIME}
done

echo "Waiting for emulator boot to finish..."
REMAINING_TIME=${MAX_EMULATOR_WAIT_TIME}
while [ "$ADB shell getprop init.svc.bootanim)" = $'running\r' ]; do
    if [ ${REMAINING_TIME} -le 0 ]; then
        echo "Failed to boot emulator"
        exit 1
    fi
    echo "Keep trying for ${REMAINING_TIME} more seconds"
    sleep ${WAIT_LOOP_TIME}
    let REMAINING_TIME=REMAINING_TIME-${WAIT_LOOP_TIME}
done

echo "Emulator started."