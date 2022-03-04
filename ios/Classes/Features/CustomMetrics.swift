import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func reportMetric(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }
    
    guard let name = properties["name"] as? String else {
      let error = FlutterError(code: "500", message: "Agent reportMetric() failed.", details: "Please provide a valid metric name.")
      result(error)
      return
    }
    
    guard let value = properties["value"] as? Int64 else {
      let error = FlutterError(code: "500", message: "Agent reportMetric() failed.", details: "Please provide a valid metric `int` value.")
      result(error)
      return
    }
    
    ADEumInstrumentation.reportMetric(withName: name, value: value)
    result(nil)
  }
}
