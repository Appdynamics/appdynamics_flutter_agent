#! /bin/sh
#
# Copyright (c) 2022. AppDynamics LLC and its affiliates.
# All rights reserved.
#
#

# For debugging purposes

# START OF INSTALL RUBY 3.22
echo 'eval "$(/opt/homebrew/bin/rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
echo $PATH
/usr/bin/sudo rbenv install 3.2.2
/usr/bin/sudo rbenv global 3.2.2
/usr/bin/sudo chown -R teamcity:teamcity ~/.rbenv/versions/3.2.2
ruby -v

# Installing the activesupport-7.0.8
echo "Installing the activesupport-7.0.8"
gem uninstall activesupport -v 7.1.2
gem install activesupport -v  7.0.8

# Installing the cocoapods
echo "Installing the cocoapods"
gem install cocoapods

# END OF INSTALL RUBY 3.22

flutter devices --device-timeout=500
flutter emulators

cd ios
echo "Installed Pod Version: "
pod --version
pod repo add-cdn trunk https://github.com/CocoaPods/Specs.git
cd ..

flutter build ios --simulator

# Remove residual ios/.symlink folder because it's problematic to TC artifacts.
rm -rf ios/.symlinks

# Current TC artifact path is hardcoded to build/app/reports so we move things there.
mkdir -p build/app/reports
cp -r build/ios/iphonesimulator/Runner.app build/app/reports
