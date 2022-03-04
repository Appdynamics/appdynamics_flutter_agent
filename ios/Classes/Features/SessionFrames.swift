import ADEUMInstrumentation
import Flutter

extension SwiftAppDynamicsAgentPlugin {
  func startSessionFrame(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }
    
    guard let name = properties["name"] as? String else {
      let error = FlutterError(code: "500", message: "Agent startSessionFrame() failed.", details: "Please provide a valid session name.")
      result(error)
      return
    }
    
    guard let id = properties["id"] as? String else {
      let error = FlutterError(code: "500", message: "Agent startSessionFrame() failed.", details: "Please provide a valid session ID.")
      result(error)
      return
    }
    
    let sessionFrame: ADEumSessionFrame = ADEumInstrumentation.startSessionFrame(name)
    sessionFrames[id] = sessionFrame
    result(nil)
  }
  
  func updateSessionFrameName(result: @escaping FlutterResult, arguments: Any?) {
    guard let properties = arguments as? Dictionary<String, Any> else {
      return
    }
    
    guard let newName = properties["newName"] as? String else {
      let error = FlutterError(code: "500", message: "Agent updateSessionFrameName() failed.", details: "Please provide a valid session name.")
      result(error)
      return
    }
    
    guard let id = properties["id"] as? String else {
      let error = FlutterError(code: "500", message: "Agent updateSessionFrameName() failed.", details: "Please provide a valid session ID.")
      result(error)
      return
    }
    
    sessionFrames[id]?.updateName(newName)
    result(nil)
  }
  
  func endSessionFrame(result: @escaping FlutterResult, arguments: Any?) {
    guard let id = arguments as? String else {
      let error = FlutterError(code: "500", message: "Agent endSessionFrame() failed.", details: "Please provide a valid session ID.")
      result(error)
      return
    }
    
    if let sessionFrame = sessionFrames[id] {
      sessionFrame.end()
      sessionFrames[id] = nil
    }
    result(nil)
  }
}
