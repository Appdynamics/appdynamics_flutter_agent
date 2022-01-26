#! /bin/sh
#
# Copyright (c) 2021. AppDynamics LLC and its affiliates.
# All rights reserved.
#
#
set -e

flutter pub global activate dartdoc
# Running `dartdoc` alone was throwing error and no other solution worked.
# https://stackoverflow.com/questions/61086384/dartdoc-failed-top-level-package-requires-flutter-but-flutter-root-environment
flutter pub global run dartdoc:dartdoc

# Current TC artifact path is hardcoded to build/app/reports so we move things there.
ARTIFACTS_FOLDER=example/build/app/reports
echo "To view docs, run the \`view-docs.sh\` script. Troubleshooting: https://dart.dev/get-dart" \
> README
zip -j doc.zip scripts/view-docs.sh README
zip -ur doc.zip doc
cp doc.zip $ARTIFACTS_FOLDER
rm doc.zip README