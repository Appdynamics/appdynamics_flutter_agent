#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint appdynamics_mobilesdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'appdynamics_mobilesdk'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin to integrate AppDynamics Mobile Real User Monitoring with your app.'
  s.description      = <<-DESC
Flutter plugin to integrate AppDynamics Mobile Real User Monitoring with your app.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'AppDynamicsAgent', '~> 2022.2'
  s.platform = :ios, '8.0'

  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
