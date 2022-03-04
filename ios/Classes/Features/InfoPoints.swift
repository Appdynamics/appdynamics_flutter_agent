import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func beginCall(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    let callId = properties["callId"] as! String
    
    guard let className = properties["className"] as? String else {
      let error = FlutterError(code: "500", message: "Agent trackCall() failed.", details: "Please provide a valid class name.")
      result(error)
      return
    }
    
    guard let methodName = properties["methodName"] as? String else {
      let error = FlutterError(code: "500", message: "Agent trackCall() failed.", details: "Please provide a valid methodName value.")
      result(error)
      return
    }
    
    let methodArgs: [Any] = (properties["methodArgs"] as? [Any]) ?? []
    
    let tracker = ADEumInstrumentation.beginCall(className, methodName: methodName, withArguments: methodArgs)
    callTrackers[callId] = tracker
    
    result(nil)
  }
  
  func endCallWithSuccess(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    
    
    let callId = properties["callId"] as! String
    let value = properties["result"]!
    
    ADEumInstrumentation.endCall(callTrackers[callId], withValue: value)
    callTrackers[callId] = nil
    
    result(nil)
  }
  
  func endCallWithError(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    
    
    let callId = properties["callId"] as! String
    let error = properties["error"] as! [String: Any]
    
    var dict: [String: Any] = ["is_error": true]
    
    if let message = error["message"] as? String {
      dict["message"] = message
    }
    
    if let stackTrace = error["stackTrace"] as? String {
      dict["stackTrace"] = stackTrace
    }
    
    let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
    let jsonString = String(data: jsonData, encoding: .utf8)
    
    // We will not be using the native `endCall` because it requires a native iOS error.
    // Instead, we end the call with a custom error-like payload.
    ADEumInstrumentation.endCall(callTrackers[callId], withValue: jsonString)
    callTrackers[callId] = nil;
    
    result(nil)
  }
}
