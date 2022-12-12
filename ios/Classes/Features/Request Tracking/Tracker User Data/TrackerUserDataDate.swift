import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func setRequestTrackerUserDataDate(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    let id = properties["id"] as! String
    
    guard let key = properties["key"] as? String else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerUserDataDate() failed.", details: "Please provide a valid string for `key`.")
      result(error)
      return
    }
    
    guard let value = properties["value"] as? Double else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerUserDataDate() failed.", details: "Please provide a valid DateTime for `value`.")
      result(error)
      return
    }
      
    let date = Date(timeIntervalSince1970: value / 1000)
    
    guard let tracker = requestTrackers[id] else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerUserDataDate() failed.", details: "Request tracker was not initialized or already reported.")
      result(error)
      return
    }
    
    tracker.setUserDataDate(key, value: date)
    result(nil)
  }
}
