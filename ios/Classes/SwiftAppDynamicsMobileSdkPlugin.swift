import ADEUMInstrumentation
import Flutter

public class SwiftAppDynamicsMobileSdkPlugin: NSObject, FlutterPlugin {
    var customRequestTracker: ADEumHTTPRequestTracker?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "appdynamics_mobilesdk", binaryMessenger: registrar.messenger())
        let instance = SwiftAppDynamicsMobileSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        typealias AdeumMethod = (@escaping FlutterResult, Any?) -> ()
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
            
            // Custom timers
            "startTimer": startTimer,
            "stopTimer": stopTimer,
            
            // Breadcrumbs
            "leaveBreadcrumb": leaveBreadcrumb
        ]
        
        if let method = methods[call.method] {
            method(result, call.arguments)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
