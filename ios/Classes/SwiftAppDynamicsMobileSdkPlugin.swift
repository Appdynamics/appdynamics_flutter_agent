import Flutter
import UIKit
import ADEUMInstrumentation

public class SwiftAppDynamicsMobileSdkPlugin: NSObject, FlutterPlugin {
    var customRequestTracker: ADEumHTTPRequestTracker?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "appdynamics_mobilesdk", binaryMessenger: registrar.messenger())
        let instance = SwiftAppDynamicsMobileSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    

    typealias AdeumMethod = (@escaping FlutterResult, Any?) -> ()
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let methods: [String: AdeumMethod] = [
            "start": start,
            
            // Manual request tracking
            "getRequestTrackerWithUrl": getRequestTrackerWithUrl,
            "setRequestTrackerErrorInfo": setRequestTrackerErrorInfo,
            "setRequestTrackerStatusCode": setRequestTrackerStatusCode,
            "setRequestTrackerResponseHeaders": setRequestTrackerResponseHeaders,
            "setRequestTrackerRequestHeaders": setRequestTrackerRequestHeaders,
            "getServerCorrelationHeaders": getServerCorrelationHeaders,
            "requestTrackerReport": requestTrackerReport,
        ]

        if let method = methods[call.method] {
            method(result, call.arguments)
        } else {
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

        if let anrDetectionEnabled = properties["anrDetectionEnabled"] as? Bool {
            configuration.anrDetectionEnabled = anrDetectionEnabled
        }
        
        if let anrStackTraceEnabled = properties["anrStackTraceEnabled"] as? Bool {
            configuration.anrStackTraceEnabled = anrStackTraceEnabled
        }
        
        if let collectorURL = properties["collectorURL"] as? String {
            configuration.collectorURL = collectorURL
        }
        
        configuration.screenshotsEnabled = false
        configuration.applicationName = "com.appdynamics.FlutterEveryfeatureiOS"
        ADEumInstrumentation.initWith(configuration)
        
        result(nil)
    }

}
