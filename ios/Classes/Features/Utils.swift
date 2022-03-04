import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func sleep(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    let seconds = properties["seconds"] as! Double
    let interval = TimeInterval(seconds)
    Thread.sleep(forTimeInterval: interval)
    result(nil)
  }
  
  func crash(result: @escaping FlutterResult, arguments: Any?) {
    NSException.raise(NSExceptionName(rawValue: "AppDynamics crash"), format: "This was triggered natively.", arguments: getVaList([]))
  }
}
