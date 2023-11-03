import ADEUMInstrumentation
import Flutter

// ADEumMethodCall is not yet exposed from native.
typealias ADEumMethodCall = Any

public class SwiftAppDynamicsAgentPlugin: NSObject, FlutterPlugin {
  static var channel: FlutterMethodChannel?
  
  var crashReportCallback: CrashCallbackObject?
  var requestTrackers: [String: ADEumHTTPRequestTracker] = [:]
  var sessionFrames: [String: ADEumSessionFrame] = [:]
  var callTrackers: [String: ADEumMethodCall] = [:]
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    channel = FlutterMethodChannel(name: "appdynamics_agent", binaryMessenger: registrar.messenger())
    let instance = SwiftAppDynamicsAgentPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel!)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    typealias AdeumMethod = (@escaping FlutterResult, Any?) -> ()
    let methods: [String: AdeumMethod] = [
      "start": start,
      
      /// Manual request tracking
      "getRequestTrackerWithUrl": getRequestTrackerWithUrl,
      "setRequestTrackerErrorInfo": setRequestTrackerErrorInfo,
      "setRequestTrackerStatusCode": setRequestTrackerStatusCode,
      "setRequestTrackerResponseHeaders": setRequestTrackerResponseHeaders,
      "setRequestTrackerRequestHeaders": setRequestTrackerRequestHeaders,
      "getServerCorrelationHeaders": getServerCorrelationHeaders,
      "requestTrackerReport": requestTrackerReport,
      
      "setRequestTrackerUserData": setRequestTrackerUserData,
      "setRequestTrackerUserDataDouble": setRequestTrackerUserDataDouble,
      "setRequestTrackerUserDataLong": setRequestTrackerUserDataLong,
      "setRequestTrackerUserDataBoolean": setRequestTrackerUserDataBoolean,
      "setRequestTrackerUserDataDate": setRequestTrackerUserDataDate,
      
      /// Custom timers
      "startTimer": startTimer,
      "stopTimer": stopTimer,
      
      /// Breadcrumbs
      "leaveBreadcrumb": leaveBreadcrumb,
      
      /// Report error
      "reportError": reportError,
      "createCrashReport": createCrashReport,
      "createNativeCrashReport": createNativeCrashReport,

      /// Report metric
      "reportMetric": reportMetric,
      
      /// User data
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
      
      /// Session frames
      "startSessionFrame": startSessionFrame,
      "updateSessionFrameName": updateSessionFrameName,
      "endSessionFrame": endSessionFrame,
      
      /// Screenshots
      "takeScreenshot": takeScreenshot,
      "blockScreenshots": blockScreenshots,
      "unblockScreenshots": unblockScreenshots,
      "screenshotsBlocked": screenshotsBlocked,
      
      /// Shutdown & restart
      "shutdownAgent": shutdownAgent,
      "restartAgent": restartAgent,
      
      /// Programmatic session control
      "startNextSession": startNextSession,
      
      /// Info points
      "beginCall": beginCall,
      "endCallWithSuccess": endCallWithSuccess,
      "endCallWithError": endCallWithError,
      
      /// Change app key after initialization
      "changeAppKey": changeAppKey,
      
      /// Activity tracking
      "trackPageStart": trackPageStart,
      "trackPageEnd": trackPageEnd,
      
      /// Utils
      "sleep": sleep,
      "crash": crash
    ]
    
    if let method = methods[call.method] {
      do {
        try ObjcExceptionCatch.tryExecute {
          method(result, call.arguments)
        }
      } catch {
        let customError = FlutterError(code: "500", message: "Native method call failed.", details: error.localizedDescription)
        result(customError)
      }
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
