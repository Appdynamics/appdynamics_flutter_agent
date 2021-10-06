import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsMobileSdkPlugin {
  public func start(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }
    
    guard let appKey = properties["appKey"] as? String else {
      let error = FlutterError(code: "500", message: "Agent start() failed.", details: "Please provide an appKey.")
      result(error)
      return
    }
    
    let configuration = ADEumAgentConfiguration(appKey: appKey)
    
    if let loggingLevel = properties["loggingLevel"] as? Int {
      let levels = [ADEumLoggingLevel.off,  ADEumLoggingLevel.info, ADEumLoggingLevel.all]
      configuration.loggingLevel = levels[loggingLevel]
    }
    
    if let anrDetectionEnabled = properties["anrDetectionEnabled"] as? Bool {
      configuration.anrDetectionEnabled = anrDetectionEnabled
    }
    
    if let anrStackTraceEnabled = properties["anrStackTraceEnabled"] as? Bool {
      configuration.anrStackTraceEnabled = anrStackTraceEnabled
    }
    
    if let collectorURL = properties["collectorURL"] as? String {
      configuration.collectorURL = collectorURL
    }
    
    if let screenshotURL = properties["screenshotURL"] as? String {
      configuration.screenshotURL = screenshotURL
    }
    
    if let screenshotsEnabled = properties["screenshotsEnabled"] as? Bool {
      configuration.screenshotsEnabled = screenshotsEnabled
    }
    
    if let crashReportingEnabled = properties["crashReportingEnabled"] as? Bool {
      configuration.crashReportingEnabled = crashReportingEnabled
    }
    
    if crashReportCallback == nil {
      crashReportCallback = CrashCallbackObject()
      configuration.crashReportCallback = crashReportCallback
    }
    
    configuration.enableAutoInstrument = false
    configuration.applicationName = "com.appdynamics.FlutterEveryfeatureiOS"
    ADEumInstrumentation.initWith(configuration)
    
    result(nil)
  }
}
