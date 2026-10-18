import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController
    if let existing = window?.rootViewController as? FlutterViewController {
      controller = existing
    } else {
      let window = UIWindow(frame: UIScreen.main.bounds)
      let newController = FlutterViewController(project: nil, initialRoute: nil, nibName: nil, bundle: nil)
      window.rootViewController = newController
      self.window = window
      controller = newController
    }

    // Firebase is initialized from Dart with backend-provided FirebaseOptions.
    GeneratedPluginRegistrant.register(with: self)
    let timezoneChannel = FlutterMethodChannel(
      name: "openvts/timezone",
      binaryMessenger: controller.binaryMessenger
    )
    timezoneChannel.setMethodCallHandler { call, result in
      if call.method == "getLocalTimezone" {
        result(TimeZone.current.identifier)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
