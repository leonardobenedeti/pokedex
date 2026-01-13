import Flutter
import UIKit
import FirebaseCore
import FirebaseAnalytics

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let analyticsChannel = FlutterMethodChannel(name: "com.pokedex.features/analytics",
                                              binaryMessenger: controller.binaryMessenger)
    
    analyticsChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
      if let args = call.arguments {
          print("[AnalyticsPlugin] Method: \(call.method) | Args: \(args)")
      } else {
          print("[AnalyticsPlugin] Method: \(call.method) | No Args")
      }
      
      switch call.method {
      case "logEvent":
        guard let args = call.arguments as? [String: Any],
              let name = args["name"] as? String else {
          print("[AnalyticsPlugin] Error: Invalid arguments for logEvent")
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Event name is required", details: nil))
          return
        }
        let parameters = args["parameters"] as? [String: Any]
        print("[AnalyticsPlugin] logEvent -> Name: \(name), Params: \(String(describing: parameters))")
        Analytics.logEvent(name, parameters: parameters)
        result(nil)
        
      case "setUserId":
        guard let args = call.arguments as? [String: Any],
              let userId = args["userId"] as? String else {
          print("[AnalyticsPlugin] Error: Invalid arguments for setUserId")
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "User ID is required", details: nil))
          return
        }
        print("[AnalyticsPlugin] setUserId -> ID: \(userId)")
        Analytics.setUserID(userId)
        result(nil)
        
      case "setUserProperty":
         guard let args = call.arguments as? [String: Any],
              let name = args["name"] as? String,
              let value = args["value"] as? String else {
          print("[AnalyticsPlugin] Error: Invalid arguments for setUserProperty")
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Name and value are required", details: nil))
          return
        }
        print("[AnalyticsPlugin] setUserProperty -> Name: \(name), Value: \(value)")
        Analytics.setUserProperty(value, forName: name)
        result(nil)

      case "setCurrentScreen":
        guard let args = call.arguments as? [String: Any],
              let screenName = args["screenName"] as? String else {
           print("[AnalyticsPlugin] Error: Invalid arguments for setCurrentScreen")
           result(FlutterError(code: "INVALID_ARGUMENTS", message: "Screen name is required", details: nil))
           return
        }
        let screenClass = args["screenClassOverride"] as? String ?? "Flutter"
        
        print("[AnalyticsPlugin] setCurrentScreen -> Name: \(screenName), Class: \(screenClass)")
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
          AnalyticsParameterScreenName: screenName,
          AnalyticsParameterScreenClass: screenClass
        ])
        result(nil)
        
      default:
        print("[AnalyticsPlugin] Error: Method not implemented: \(call.method)")
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
