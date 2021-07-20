import Foundation
import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsMobileSdkPlugin {
    func getRequestTrackerWithUrl(result: @escaping FlutterResult, arguments: Any?) {
        guard let urlString = arguments as? String, let url = URL(string: urlString) else {
            let error = FlutterError(code: "500", message: "Agent getRequestTrackerWithUrl() failed.", details: "Please provide a valid URL.")
            result(error)
            return
        }
        customRequestTracker = ADEumHTTPRequestTracker(url: url)
        result(nil)
    }
    
    func setRequestTrackerErrorInfo(result: @escaping FlutterResult, arguments: Any?) {
        guard let tracker = customRequestTracker else {
            let error = FlutterError(code: "500", message: "Agent setRequestTrackerErrorInfo() failed.", details: "Request tracker was not initialized.")
            result(error)
            return
        }
        
        guard let errorDict = arguments as? Dictionary<String, String> else {
            return
        }
        
        tracker.error = NSError(domain: "Manual request tracker", code: 0, userInfo: errorDict)
        result(nil)
    }
    
    func setRequestTrackerStatusCode(result: @escaping FlutterResult, arguments: Any?) {
        guard let tracker = customRequestTracker else {
            let error = FlutterError(code: "500", message: "Agent setRequestTrackerStatusCode() failed.", details: "Request tracker was not initialized.")
            result(error)
            return
        }
        
        guard let statusCode = arguments as? NSNumber else {
            return
        }
        
        tracker.statusCode = statusCode
        result(nil)
    }
    
    func setRequestTrackerResponseHeaders(result: @escaping FlutterResult, arguments: Any?) {
        guard let tracker = customRequestTracker else {
            let error = FlutterError(code: "500", message: "Agent setRequestTrackerStatusCode() failed.", details: "Request tracker was not initialized.")
            result(error)
            return
        }
        
        guard let headers = arguments as? [AnyHashable: Any] else {
            return
        }
        
        tracker.allHeaderFields = headers
        result(nil)
    }
    
    func setRequestTrackerRequestHeaders(result: @escaping FlutterResult, arguments: Any?) {
        guard let tracker = customRequestTracker else {
            let error = FlutterError(code: "500", message: "Agent setRequestTrackerRequestHeaders() failed.", details: "Request tracker was not initialized.")
            result(error)
            return
        }
        
        guard let headers = arguments as? [AnyHashable: Any] else {
            return
        }
        
        tracker.allRequestHeaderFields = headers
        result(nil)
    }
    
    func requestTrackerReport(result: @escaping FlutterResult, arguments: Any?) {
        guard let tracker = customRequestTracker else {
            let error = FlutterError(code: "500", message: "Agent requestTrackerReport() failed.", details: "Request tracker was not initialized.")
            result(error)
            return
        }
        
        tracker.reportDone()
        result(nil)
    }

    func getServerCorrelationHeaders(result: @escaping FlutterResult, arguments: Any?) {
        let headers = ADEumServerCorrelationHeaders.generate()
        result(headers)
    }
}
