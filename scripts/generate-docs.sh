#! /bin/sh
#
# Copyright (c) 2021. AppDynamics LLC and its affiliates.
# All rights reserved.
#
#
dart pub global activate dartdoc
dartdoc

# Current TC artifact path is hardcoded to build/app/reports so we move things there.
ARTIFACTS_FOLDER=example/build/app/reports
cp -r doc $ARTIFACTS_FOLDER
cp scripts/view-docs.sh $ARTIFACTS_FOLDER
touch $ARTIFACTS_FOLDER/README
echo "To view docs, run the \`view-docs.sh\` script. Troubleshooting: https://dart.dev/get-dart" \
> $ARTIFACTS_FOLDER/README