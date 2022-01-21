import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsMobileSdkPlugin {
  func setUserDataDate(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }
    
    guard let key = properties["key"] as? String else {
      let error = FlutterError(code: "500", message: "Agent setUserDataDateTime() failed.", details: "Please provide a valid string for `key`.")
      result(error)
      return
    }
    
    guard let value = properties["value"] as? String else {
      let error = FlutterError(code: "500", message: "Agent setUserDataDateTime() failed.", details: "Please provide a valid DateTime for `value`.")
      result(error)
      return
    }
    
    let formatter = DateFormatter()
    formatter.dateFormat = SwiftAppDynamicsMobileSdkPlugin.dateFormat
    guard let date = formatter.date(from: value) else {
      let error = FlutterError(code: "500", message: "Agent setUserDataDateTime() failed.", details: "Please provide a valid DateTime for `value`.")
      result(error)
      return
    }
    
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
