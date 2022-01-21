import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsMobileSdkPlugin {
  func reportError(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }
    
    let stackTrace = properties["stackTrace"] as? String
    
    guard let message = properties["message"] as? String else {
      let error = FlutterError(code: "500", message: "reportError() failed.", details: "Please provide a valid message string.")
      result(error)
      return
    }
    
    guard let severityInt = properties["severity"] as? Int, let severity = ADEumErrorSeverityLevel.init(rawValue: UInt(severityInt)) else {
      let error = FlutterError(code: "500", message: "reportError() failed.", details: "Please provide a valid error severity level .")
      result(error)
      return
    }
    
    var userInfo = ["message": message]
    if let stackTrace = stackTrace {
      userInfo.updateValue(stackTrace, forKey: "stack")
    }
    
    let error = NSError(domain:"Manual error report", code: 0, userInfo:userInfo)
    ADEumInstrumentation.reportError(error, withSeverity: severity, andStackTrace: false)
    result(nil)
  }
}

