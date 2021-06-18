import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.appdynamics.flutter.example",
                                                  binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            switch call.method {
            case "sleep":
                sleep(result: result, arguments: call.arguments)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

// MARK: Custom methods

public func sleep(result: @escaping FlutterResult, arguments: Any?) {
    let seconds = arguments as? Double
    let interval = TimeInterval(seconds ?? 1)
    Thread.sleep(forTimeInterval: interval)
    
    result(nil)
}
