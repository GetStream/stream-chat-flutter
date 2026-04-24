import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Per flutter_local_notifications' iOS setup guide. Once we own the
    // delegate slot, `FlutterAppDelegate` forwards `UNUserNotificationCenter`
    // callbacks to registered plugins — so firebase_messaging's foreground
    // presentation options and flutter_local_notifications'
    // `DarwinNotificationDetails` banner/list flags each take effect for
    // their own notifications.
    UNUserNotificationCenter.current().delegate = self
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
