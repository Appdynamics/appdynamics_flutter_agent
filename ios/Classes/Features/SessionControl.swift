import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsMobileSdkPlugin {
  func startNextSession(result: @escaping FlutterResult, arguments: Any?) {
    ADEumInstrumentation.startNextSession()
    result(nil)
  }
}
