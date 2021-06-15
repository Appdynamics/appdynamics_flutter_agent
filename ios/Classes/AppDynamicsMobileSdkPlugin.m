#import "AppdynamicsMobileSdkPlugin.h"
#if __has_include(<appdynamics_mobilesdk/appdynamics_mobilesdk-Swift.h>)
#import <appdynamics_mobilesdk/appdynamics_mobilesdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "appdynamics_mobilesdk-Swift.h"
#endif

@implementation AppDynamicsMobileSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAppDynamicsMobileSdkPlugin registerWithRegistrar:registrar];
}
@end
