import ADEUMInstrumentation
import Flutter

class CrashCallbackObject: NSObject, ADEumCrashReportCallback {
  func onCrashesReported(_ summaries: [ADEumCrashReportSummary]) {
    guard let channel = SwiftAppDynamicsMobileSdkPlugin.channel else {
      print("SwiftAppDynamicsMobileSdkPlugin channel is nil.")
      return
    }
    
    let serializableSummaries = summaries.map { summary -> [String: String?] in
      return [
        "crashId": summary.crashId,
        "exceptionName": summary.exceptionName,
        "exceptionReason": summary.exceptionReason,
        "signalName": summary.signalName,
        "signalCode": summary.signalCode,
      ]
    }
    
    channel.invokeMethod("onCrashReported", arguments: serializableSummaries)
  }
}
