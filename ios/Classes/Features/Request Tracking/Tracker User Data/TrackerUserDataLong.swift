import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func setRequestTrackerUserDataLong(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    let id = properties["id"] as! String
    
    guard let key = properties["key"] as? String else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerUserDataLong() failed.", details: "Please provide a valid string for `key`.")
      result(error)
      return
    }
    
    guard let value = properties["value"] as? Int64 else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerUserDataLong() failed.", details: "Please provide a valid long for `value`.")
      result(error)
      return
    }
    
    guard let tracker = requestTrackers[id] else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerUserDataLong() failed.", details: "Request tracker was not initialized or already reported.")
      result(error)
      return
    }
    
    tracker.setUserDataLong(key, value: value)
    result(nil)
  }
}
