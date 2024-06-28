import UIKit
import Flutter
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      // In AppDelegate.application method
      WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "ActivityBackgroundService")

      // Register a periodic task in iOS 13+
      WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "SaveTodaysActivity", frequency: NSNumber(value: 30 * 60))

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
