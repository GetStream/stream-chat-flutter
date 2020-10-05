import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let sharedDefaults = UserDefaults(suiteName: "group.io.getstream.flutter")
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if let messageQueue = sharedDefaults?.stringArray(forKey: "messageQueue") {
            UserDefaults.standard.setValue(messageQueue, forKey: "flutter.messageQueue")
            sharedDefaults?.removeObject(forKey: "messageQueue")
        }

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func applicationDidEnterBackground(_ application: UIApplication) {
        if let apiKey = UserDefaults.standard.string(forKey: "flutter.KEY_API_KEY") {
            sharedDefaults?.setValue(apiKey, forKey: "KEY_API_KEY")
        }

        if let token = UserDefaults.standard.string(forKey: "flutter.KEY_TOKEN") {
            sharedDefaults?.setValue(token, forKey: "KEY_TOKEN")
        }

        if let userId = UserDefaults.standard.string(forKey: "flutter.KEY_USER_ID") {
            sharedDefaults?.setValue(userId, forKey: "KEY_USER_ID")
        }
    }
    
    override func applicationWillEnterForeground(_ application: UIApplication) {
        if let messageQueue = sharedDefaults?.stringArray(forKey: "messageQueue") {
            UserDefaults.standard.setValue(messageQueue, forKey: "flutter.messageQueue")
            sharedDefaults?.removeObject(forKey: "messageQueue")
        }
    }
}
