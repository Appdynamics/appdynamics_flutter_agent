import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func setUserDataBoolean(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }
    
    guard let key = properties["key"] as? String else {
      let error = FlutterError(code: "500", message: "Agent setUserDataBoolean() failed.", details: "Please provide a valid string for `key`.")
      result(error)
      return
    }
    
    guard let value = properties["value"] as? Bool else {
      let error = FlutterError(code: "500", message: "Agent setUserDataBoolean() failed.", details: "Please provide a valid bool for `value`.")
      result(error)
      return
    }
    
    ADEumInstrumentation.setUserDataBoolean(key, value: value)
    result(nil)
  }
  
  func removeUserDataBoolean(result: @escaping FlutterResult, arguments: Any?) {
    guard let key = arguments as? String else {
      let error = FlutterError(code: "500", message: "Agent removeUserDataBool() failed.", details: "Please provide a valid string for `key`.")
      result(error)
      return
    }
    
    ADEumInstrumentation.removeUserDataBoolean(key)
    result(nil)
  }
}
