import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func setUserDataDouble(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }
    
    guard let key = properties["key"] as? String else {
      let error = FlutterError(code: "500", message: "Agent setUserDataDouble() failed.", details: "Please provide a valid string for `key`.")
      result(error)
      return
    }
    
    guard let value = properties["value"] as? Double else {
      let error = FlutterError(code: "500", message: "Agent setUserDataDouble() failed.", details: "Please provide a valid double for `value`.")
      result(error)
      return
    }
    
    ADEumInstrumentation.setUserDataDouble(key, value: value)
    result(nil)
  }
  
  func removeUserDataDouble(result: @escaping FlutterResult, arguments: Any?) {
    guard let key = arguments as? String else {
      let error = FlutterError(code: "500", message: "Agent removeUserDataDouble() failed.", details: "Please provide a valid string for `key`.")
      result(error)
      return
    }
    
    ADEumInstrumentation.removeUserDataDouble(key)
    result(nil)
  }
}
