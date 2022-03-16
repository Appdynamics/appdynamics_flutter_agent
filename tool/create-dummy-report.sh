#! /bin/sh
#
# Copyright (c) 2022. AppDynamics LLC and its affiliates.
# All rights reserved.
#
#

# Remove residual ios/.symlink because it's problematic to TC artifacts.
rm -rf ios/.symlinks

# CI/CD pipeline expects .xml test reports after each task is executed.
# Our integration test tasks don't generate reports, so we stub them.
mkdir -p build/test-results
echo "# Dummy comment" > build/test-results/test-result.txt


