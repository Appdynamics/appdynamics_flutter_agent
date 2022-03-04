import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func setUserDataLong(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }
    
    guard let key = properties["key"] as? String else {
      let error = FlutterError(code: "500", message: "Agent setUserDataLong() failed.", details: "Please provide a valid string for `key`.")
      result(error)
      return
    }
    
    guard let value = properties["value"] as? Int64 else {
      let error = FlutterError(code: "500", message: "Agent setUserDataLong() failed.", details: "Please provide a valid long for `value`.")
      result(error)
      return
    }
    
    ADEumInstrumentation.setUserDataLong(key, value: value)
    result(nil)
  }
  
  func removeUserDataLong(result: @escaping FlutterResult, arguments: Any?) {
    guard let key = arguments as? String else {
      let error = FlutterError(code: "500", message: "Agent removeUserDataLong() failed.", details: "Please provide a valid string for `key`.")
      result(error)
      return
    }
    
    ADEumInstrumentation.removeUserDataLong(key)
    result(nil)
  }
}
