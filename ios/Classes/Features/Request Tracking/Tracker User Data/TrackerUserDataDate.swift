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
    
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = SwiftAppDynamicsAgentPlugin.dateFormat
    guard let value = properties["value"] as? String, let date = formatter.date(from: value) else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerUserDataDate() failed.", details: "Please provide a valid DateTime for `value`.")
      result(error)
      return
    }
    
    guard let tracker = requestTrackers[id] else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerUserDataDate() failed.", details: "Request tracker was not initialized or already reported.")
      result(error)
      return
    }
    
    tracker.setUserDataDate(key, value: date)
    result(nil)
  }
}
