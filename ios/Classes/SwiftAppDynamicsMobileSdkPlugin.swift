import Flutter
import UIKit
import ADEUMInstrumentation

public class SwiftAppDynamicsMobileSdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "appdynamics_mobilesdk", binaryMessenger: registrar.messenger())
        let instance = SwiftAppDynamicsMobileSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "start":
            start(result: result, arguments: call.arguments)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    // MARK: Agent methods
    
    public func start(result: @escaping FlutterResult, arguments: Any?) {
        guard let properties = arguments as? Dictionary<String, Any> else {
            return
        }
        
        guard let appKey = properties["appKey"] as? String else {
            let error = FlutterError(code: "500", message: "Agent start() failed.", details: "Please provide an appKey.")
            result(error)
            return
        }
        
        let configuration = ADEumAgentConfiguration(appKey: appKey)
        
        if let loggingLevel = properties["loggingLevel"] as? Int {
            let levels = [ADEumLoggingLevel.off,  ADEumLoggingLevel.info, ADEumLoggingLevel.all]
            configuration.loggingLevel = levels[loggingLevel]
        }
        
        ADEumInstrumentation.initWith(configuration)
        
        result(nil)
    }
}
