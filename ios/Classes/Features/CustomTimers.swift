import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func startTimer(result: @escaping FlutterResult, arguments: Any?) {
    guard let name = arguments as? String else {
      let error = FlutterError(code: "500", message: "Agent startTimer() failed.", details: "Please provide a valid timer name.")
      result(error)
      return
    }
    ADEumInstrumentation.startTimer(withName: name)
    result(nil)
  }
  
  func stopTimer(result: @escaping FlutterResult, arguments: Any?) {
    guard let name = arguments as? String else {
      let error = FlutterError(code: "500", message: "Agent stopTimer() failed.", details: "Please provide a valid timer name.")
      result(error)
      return
    }
    ADEumInstrumentation.stopTimer(withName: name)
    result(nil)
  }
}
