#! /bin/sh
#
# Copyright (c) 2022. AppDynamics LLC and its affiliates.
# All rights reserved.
#
#

set -e
set -x

flutter pub global activate dartdoc
dart doc .

# Current TC artifact path is hardcoded to build/app/reports so we move things there.
ARTIFACTS_FOLDER=example/build/app/reports
echo "To view docs, run the \`view-docs.sh\` script. Troubleshooting: https://dart.dev/get-dart" \
> README
zip -j docs.zip tool/view-docs.sh README
zip -ur docs.zip doc
mkdir -p $ARTIFACTS_FOLDER
cp docs.zip $ARTIFACTS_FOLDER
rm docs.zip README