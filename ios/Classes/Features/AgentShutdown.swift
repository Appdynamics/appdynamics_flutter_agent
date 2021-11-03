import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsMobileSdkPlugin {
  func shutdownAgent(result: @escaping FlutterResult, arguments: Any?) {
    ADEumInstrumentation.shutdownAgent()
    result(nil)
  }
  
  func restartAgent(result: @escaping FlutterResult, arguments: Any?) {
    ADEumInstrumentation.restartAgent()
    result(nil)
  }
}
