#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# This pod is not intended to be published, but only integrated on built-time.
#
Pod::Spec.new do |s|
  s.name             = 'appdynamics_agent'
  s.version          = '22.3.0-beta.8'
  s.summary          = 'Flutter plugin to integrate AppDynamics Mobile Real User Monitoring with your app.'
  s.description      = <<-DESC
Flutter plugin to integrate AppDynamics Mobile Real User Monitoring with your app.
                       DESC
  s.homepage         = 'http://appdynamics.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Appdynamics' => 'flutter.agent@appdynamics.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'

  s.dependency 'Flutter'
  s.dependency 'AppDynamicsAgent', '~> 2022.3'

  s.platform = :ios, '9.0'

  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
