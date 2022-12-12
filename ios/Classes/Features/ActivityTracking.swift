import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func trackPageStart(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }

    guard let pageName = properties["widgetName"] as? String else {
      let error = FlutterError(code: "500", message: "Agent trackPageStart() failed.", details: "Please provide a valid widget name.")
      result(error)
      return
    }
    
    let uuid = UUID()

    let startDate = properties["startDate"] as! Double
    let start = Date(timeIntervalSince1970: startDate / 1000)
    
    ADEumInstrumentation.trackPageStart(pageName, uuid: uuid, start: start)
    result(uuid.uuidString)
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
    
    let startDate = properties["startDate"] as! Double
    let start = Date(timeIntervalSince1970: startDate / 1000)
    
    let endDate = properties["endDate"] as! Double
    let end = Date(timeIntervalSince1970: endDate / 1000)

    ADEumInstrumentation.trackPageEnd(pageName, uuid: uuid, start: start, end: end)
    result(nil)
  }
}
