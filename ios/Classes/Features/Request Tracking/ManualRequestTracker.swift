import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func getRequestTrackerWithUrl(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    let id = properties["id"] as! String
    
    guard let urlString = properties["url"] as? String, let url = URL(string: urlString) else {
      let error = FlutterError(code: "500", message: "Agent getRequestTrackerWithUrl() failed.", details: "Please provide a valid URL.")
      result(error)
      return
    }
    
    let requestTracker: ADEumHTTPRequestTracker = ADEumHTTPRequestTracker(url: url)
    requestTrackers[id] = requestTracker
    
    result(nil)
  }
  
  func setRequestTrackerErrorInfo(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    let id = properties["id"] as! String
    let errorDict = properties["errorDict"] as! Dictionary<String, String>
    
    guard let tracker = requestTrackers[id] else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerErrorInfo() failed.", details: "Request tracker was not initialized or already reported.")
      result(error)
      return
    }
    
    tracker.error = NSError(domain: "Manual request tracker", code: 0, userInfo: errorDict)
    result(nil)
  }
  
  func setRequestTrackerStatusCode(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    let id = properties["id"] as! String
    
    guard let tracker = requestTrackers[id] else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerStatusCode() failed.", details: "Request tracker was not initialized or already reported.")
      result(error)
      return
    }
    
    guard let statusCode = properties["statusCode"] as? NSNumber else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerStatusCode() failed.", details: "Please provide a valid status code.")
      result(error)
      return
    }
    
    tracker.statusCode = statusCode
    result(nil)
  }
  
  func setRequestTrackerResponseHeaders(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    let id = properties["id"] as! String
    
    guard let tracker = requestTrackers[id] else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerResponseHeaders() failed.", details: "Request tracker was not initialized or already reported.")
      result(error)
      return
    }
    
    guard let headers = properties["headers"] as? [String: [String]] else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerResponseHeaders() failed.", details: "Please provide valid response headers.")
      result(error)
      return
    }
    
    let stringValues = headers.mapValues { value in
      return value.joined(separator: ", ")
    }
    
    tracker.allHeaderFields = stringValues
    result(nil)
  }
  
  func setRequestTrackerRequestHeaders(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    let id = properties["id"] as! String
    
    guard let tracker = requestTrackers[id] else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerRequestHeaders() failed.", details: "Request tracker was not initialized or already reported.")
      result(error)
      return
    }
    
    guard let headers = properties["headers"] as? [String: [String]] else {
      let error = FlutterError(code: "500", message: "Agent setRequestTrackerRequestHeaders() failed.", details: "Please provide valid response headers.")
      result(error)
      return
    }
    
    let stringValues = headers.mapValues { value in
      return value.joined(separator: ", ")
    }
    
    tracker.allRequestHeaderFields = stringValues
    result(nil)
  }
  
  func requestTrackerReport(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>
    let id = properties["id"] as! String
    
    guard let tracker = requestTrackers[id] else {
      let error = FlutterError(code: "500", message: "Agent requestTrackerReport() failed.", details: "Request tracker was not initialized or already reported.")
      result(error)
      return
    }
    
    tracker.reportDone()
    requestTrackers[id] = nil
    
    result(nil)
  }
  
  func getServerCorrelationHeaders(result: @escaping FlutterResult, arguments: Any?) {
    let headers = ADEumServerCorrelationHeaders.generate()
    let listValues = Dictionary(uniqueKeysWithValues:
                                  headers.map { key, value in (key, [value]) })
    
    result(listValues)
  }
}
