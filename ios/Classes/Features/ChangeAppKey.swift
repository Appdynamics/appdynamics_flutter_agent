import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func changeAppKey(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    
    
    guard let newKey = properties["newKey"] as? String else {
      let error = FlutterError(code: "500", message: "Agent changeAppKey() failed.", details: "Please provide a new valid key.")
      result(error)
      return
    }
    
    ADEumInstrumentation.changeAppKey(newKey)
    result(nil)
  }
}
