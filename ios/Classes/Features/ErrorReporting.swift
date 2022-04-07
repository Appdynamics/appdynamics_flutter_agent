import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func reportError(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    
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
  
  func createCrashReport(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    
    let type = "clrCrashReport"
    let crashDump = properties["crashDump"] as! String
    
    let data = crashDump.data(using: String.Encoding.utf8)!
    let toJson = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSMutableDictionary
    
    toJson["guid"] = UUID().uuidString
    
    let backToData = try! JSONSerialization.data(withJSONObject: toJson, options: .prettyPrinted)
    let backToString = String.init(data: backToData, encoding: .utf8)!
    
    ADEumInstrumentation.createCrashReport(backToString, type: type)
    result(nil)
  }
}
