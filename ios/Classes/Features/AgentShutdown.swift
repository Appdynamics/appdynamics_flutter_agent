import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsMobileSdkPlugin {
  public func shutdownAgent(result: @escaping FlutterResult, arguments: Any?) {
    ADEumInstrumentation.shutdownAgent()
    result(nil)
  }
  
  public func restartAgent(result: @escaping FlutterResult, arguments: Any?) {
    ADEumInstrumentation.restartAgent()
    result(nil)
  }
}
