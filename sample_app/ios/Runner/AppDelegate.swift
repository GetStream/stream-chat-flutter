import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    let sharedDefaults = UserDefaults(suiteName: "group.io.getstream.flutter")

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        restoreMessageQueue()

        if #available(iOS 10.0, *) {
          UNUserNotificationCenter.current().delegate = self
        }

        // With the UIScene lifecycle, the app delegate's own background and
        // foreground callbacks are no longer called, so observe the app-wide
        // notifications instead.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    }

    @objc private func didEnterBackground() {
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

    @objc private func willEnterForeground() {
        restoreMessageQueue()
    }

    private func restoreMessageQueue() {
        if let messageQueue = sharedDefaults?.stringArray(forKey: "messageQueue") {
            UserDefaults.standard.setValue(messageQueue, forKey: "flutter.messageQueue")
            sharedDefaults?.removeObject(forKey: "messageQueue")
        }
    }
}
