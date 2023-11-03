import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func reportError(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>

    guard let hybridExceptionData = properties["hed"] as? String else {
      let error = FlutterError(code: "500", message: "reportError() failed.", details: "Please provide a valid message string.")
      result(error)
      return
    }

    guard let severityInt = properties["sev"] as? Int, let severity = ADEumErrorSeverityLevel.init(rawValue: UInt(severityInt)) else {
      let error = FlutterError(code: "500", message: "reportError() failed.", details: "Please provide a valid error severity level .")
      result(error)
      return
    }

    ADEumInstrumentation.reportRawError(hybridExceptionData, withSeverity: severity)
    result(nil)
  }

  func createCrashReport(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>

    let hed = properties["hed"] as! String

    ADEumInstrumentation.createRawCrashReport(hed)
    result(nil)
  }

  func createNativeCrashReport(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any>,
    let crashData = properties["crashData"] as? String else {
      let error = FlutterError(code: "500", message: "createNativeCrashReport() failed.", details: "Please provide a valid message string.")
      result(error)
      return
    }
    
    ADEumInstrumentation.createCrashReport(crashData, type: "clrCrashReport")
    result(nil)
  }
}
