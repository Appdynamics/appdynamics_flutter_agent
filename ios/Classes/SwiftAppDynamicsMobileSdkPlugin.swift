import ADEUMInstrumentation
import Flutter

public class SwiftAppDynamicsMobileSdkPlugin: NSObject, FlutterPlugin {
    static var channel: FlutterMethodChannel?
    
    var customRequestTracker: ADEumHTTPRequestTracker?
    var crashReportCallback: CrashCallbackObject?
    var sessionFrames: [String: ADEumSessionFrame] = [:]
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "appdynamics_mobilesdk", binaryMessenger: registrar.messenger())
        let instance = SwiftAppDynamicsMobileSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel!)
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
            "leaveBreadcrumb": leaveBreadcrumb,
            
            // Report error
            "reportError": reportError,
            
            // Report metric
            "reportMetric": reportMetric,
            
            // User data
            "setUserData": setUserData,
            "setUserDataDouble": setUserDataDouble,
            "setUserDataLong": setUserDataLong,
            "setUserDataBoolean": setUserDataBoolean,
            "setUserDataDate": setUserDataDate,
            "removeUserData": removeUserData,
            "removeUserDataDouble": removeUserDataDouble,
            "removeUserDataLong": removeUserDataLong,
            "removeUserDataBoolean": removeUserDataBoolean,
            "removeUserDataDate": removeUserDataDate,
            
            // Session frames
            "startSessionFrame": startSessionFrame,
            "updateSessionFrameName": updateSessionFrameName,
            "endSessionFrame": endSessionFrame,
            
            // Screenshots
            "takeScreenshot": takeScreenshot,
            "blockScreenshots": blockScreenshots,
            "unblockScreenshots": unblockScreenshots,
            "screenshotsBlocked": screenshotsBlocked
        ]
        
        if let method = methods[call.method] {
            method(result, call.arguments)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
