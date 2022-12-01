import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func setUserDataDate(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }
    
    guard let key = properties["key"] as? String else {
      let error = FlutterError(code: "500", message: "Agent setUserDataDateTime() failed.", details: "Please provide a valid string for `key`.")
      result(error)
      return
    }
    
    guard let value = properties["value"] as? Double else {
      let error = FlutterError(code: "500", message: "Agent setUserDataDateTime() failed.", details: "Please provide a valid DateTime for `value`.")
      result(error)
      return
    }
    
    let date = Date(timeIntervalSince1970: value / 1000)
    
    ADEumInstrumentation.setUserDataDate(key, value: date)
    result(nil)
  }
  
  func removeUserDataDate(result: @escaping FlutterResult, arguments: Any?) {
    guard let key = arguments as? String else {
      let error = FlutterError(code: "500", message: "Agent removeUserDataDate() failed.", details: "Please provide a valid string for `key`.")
      result(error)
      return
    }
    
    ADEumInstrumentation.removeUserDataDate(key)
    result(nil)
  }
}
