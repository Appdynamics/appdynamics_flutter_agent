import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func setUserData(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }
    
    guard let key = properties["key"] as? String else {
      let error = FlutterError(code: "500", message: "Agent setUserData() failed.", details: "Please provide a valid string for `key`.")
      result(error)
      return
    }
    
    guard let value = properties["value"] as? String else {
      let error = FlutterError(code: "500", message: "Agent setUserData() failed.", details: "Please provide a valid string for `value`.")
      result(error)
      return
    }
    
    ADEumInstrumentation.setUserData(key, value: value)
    result(nil)
  }
  
  func removeUserData(result: @escaping FlutterResult, arguments: Any?) {
    guard let key = arguments as? String else {
      let error = FlutterError(code: "500", message: "Agent removeUserData() failed.", details: "Please provide a valid string for `key`.")
      result(error)
      return
    }
    
    ADEumInstrumentation.removeUserData(key)
    result(nil)
  }
}
