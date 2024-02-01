import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  public func start(result: @escaping FlutterResult, arguments: Any?) {
    let properties = arguments as! Dictionary<String, Any>

    guard let appKey = properties["appKey"] as? String else {
      let error = FlutterError(code: "500", message: "Agent start() failed.", details: "Please provide an appKey.")
      result(error)
      return
    }
    
    let configuration = ADEumAgentConfiguration(appKey: appKey)
    let type = properties["type"] as! String
    let version = properties["version"] as! String
    
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
    
    if let applicationName = properties["applicationName"] as? String {
      configuration.applicationName = applicationName
    }
    
    if crashReportCallback == nil {
      crashReportCallback = CrashCallbackObject()
      configuration.crashReportCallback = crashReportCallback
    }
    
    if let enableLoggingInVSCode = properties["enableLoggingInVSCode"] as? Bool {
      configuration.enableLoggingInVSCode = enableLoggingInVSCode
    }
    
    configuration.enableAutoInstrument = false
    configuration.jsAgentEnabled = false
    configuration.jsAgentAjaxEnabled = false
    configuration.jsAgentFetchEnabled = false
    configuration.jsAgentZonePromiseEnabled = false

    ADEumInstrumentation.initWith(configuration, a: type, b: version);
    result(nil)
    }
}
