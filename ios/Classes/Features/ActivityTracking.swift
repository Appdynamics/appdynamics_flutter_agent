import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsMobileSdkPlugin {
  func trackPageStart(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }
    
    guard let pageName = properties["widgetName"] as? String else {
      let error = FlutterError(code: "500", message: "Agent trackPageStart() failed.", details: "Please provide a valid widget name.")
      result(error)
      return
    }
    
    let uuidString = properties["uuidString"] as! String
    let uuid = UUID(uuidString: uuidString)!
    
    let formatter = DateFormatter()
    formatter.dateFormat = SwiftAppDynamicsMobileSdkPlugin.dateFormat
    
    let startDate = properties["startDate"] as! String
    let start = formatter.date(from: startDate)!
    
    ADEumInstrumentation.trackPageStart(pageName, uuid: uuid, start: start)
    result(nil)
  }
  
  func trackPageEnd(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }
    
    guard let pageName = properties["widgetName"] as? String else {
      let error = FlutterError(code: "500", message: "Agent trackPageEnd() failed.", details: "Please provide a valid page name.")
      result(error)
      return
    }
    
    let uuidString = properties["uuidString"] as! String
    let uuid = UUID(uuidString: uuidString)!
    
    let formatter = DateFormatter()
    formatter.dateFormat = SwiftAppDynamicsMobileSdkPlugin.dateFormat
    
    let startDate = properties["startDate"] as! String
    let start = formatter.date(from: startDate)!
    
    let endDate = properties["endDate"] as! String
    let end = formatter.date(from: endDate)!
    
    ADEumInstrumentation.trackPageEnd(pageName, uuid: uuid, start: start, end: end)
    result(nil)
  }
}
