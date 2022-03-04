import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func startNextSession(result: @escaping FlutterResult, arguments: Any?) {
    ADEumInstrumentation.startNextSession()
    result(nil)
  }
}
