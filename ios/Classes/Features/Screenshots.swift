import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func takeScreenshot(result: @escaping FlutterResult, arguments: Any?) {
    ADEumInstrumentation.takeScreenshot()
    result(nil)
  }
  
  func blockScreenshots(result: @escaping FlutterResult, arguments: Any?) {
    ADEumInstrumentation.blockScreenshots()
    result(nil)
  }
  
  func unblockScreenshots(result: @escaping FlutterResult, arguments: Any?) {
    ADEumInstrumentation.unblockScreenshots()
    result(nil)
  }
  
  func screenshotsBlocked(result: @escaping FlutterResult, arguments: Any?) {
    let status = ADEumInstrumentation.screenshotsBlocked()
    result(status)
  }
}
