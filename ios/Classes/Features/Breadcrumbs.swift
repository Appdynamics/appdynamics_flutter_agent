import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func leaveBreadcrumb(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }
    
    guard let breadcrumb = properties["breadcrumb"] as? String else {
      let error = FlutterError(code: "500", message: "leaveBreadcrumb() failed.", details: "Please provide a valid breadcrumb string.")
      result(error)
      return
    }
    
    guard let modeInt = properties["mode"] as? Int, let mode = ADEumBreadcrumbVisibility.init(rawValue: modeInt) else {
      let error = FlutterError(code: "500", message: "leaveBreadcrumb() failed.", details: "Please provide a valid breadcrumb mode.")
      result(error)
      return
    }
    
    ADEumInstrumentation.leaveBreadcrumb(breadcrumb, mode: mode)
    result(nil)
  }
}

