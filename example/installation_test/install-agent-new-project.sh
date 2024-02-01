#!/bin/bash -xe

flutter create latest_version_flutter_project

cd latest_version_flutter_project

pathToAgent="../../.."
flutter pub add "appdynamics_agent:{'path':${pathToAgent}}" --directory=.

# We run the fastest command that would build the projects and validates the installation.
flutter build apk --debug

cd ..
rm -r latest_version_flutter_project