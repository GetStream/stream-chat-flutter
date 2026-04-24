import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:collection/collection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart' hide Message;
import 'package:sample_app/notification/notification.dart';
import 'package:sample_app/notification/notification_background_handler.dart';

const notificationChannelId = 'stream_chat_channel';
const notificationChannelName = 'Stream Chat Notifications';
const notificationChannelDescription = 'Notifications for Stream Chat';

/// Owns the FCM + local notification pipeline for the sample app.
///
/// Flow:
///  - Foreground FCM pushes → `_onForegroundMessage` → render locally via
///    `flutter_local_notifications` so we control the title/body text.
///  - Taps (background, terminated, or local-notification) → `_dispatchTap`
///    → `onNotificationTap` callback → the app handles navigation.
class NotificationService {
  NotificationService(this._localNotification);
  final FlutterLocalNotificationsPlugin _localNotification;

  /// Called when a user taps on a notification.
  set onNotificationTap(OnNotificationTap it) => _onNotificationTap = it;
  OnNotificationTap? _onNotificationTap;

  Future<void> initialize() async {
    _registerMessageHandlers();
    await requestPermission();
    await initLocalNotifications();
    await createNotificationChannel();

    if (!kIsWeb && Platform.isIOS) {
      // Foreground presentation is handled entirely by our AppDelegate's
      // `willPresent` override; opting out of Firebase's own options keeps
      // iOS from double-rendering if the native override is ever removed.
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: false,
      );
    }

    final initial = await _getInitialNotification();
    if (initial != null) _dispatchTap(initial, DeviceState.terminated);
    debugPrint('[notif] initialize() done');
  }

  Future<bool> requestPermission() async {
    final result = await FirebaseMessaging.instance.requestPermission();
    return result.authorizationStatus == .authorized || result.authorizationStatus == .provisional;
  }

  var _isLocalNotificationsInitialized = false;
  Future<bool> initLocalNotifications() async {
    if (_isLocalNotificationsInitialized) return true;

    const initSettings = InitializationSettings(
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      android: AndroidInitializationSettings('ic_notification_in_app'),
    );

    try {
      final result = await _localNotification.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onBackgroundLocalMessageTap,
      );
      // On iOS the plugin returns null when another component owns the
      // UNUserNotificationCenter delegate. Treat null as success — `show()`
      // still works through the plugin's own APIs.
      _isLocalNotificationsInitialized = result ?? true;

      // iOS: the plugin's internal "permissions requested" flag is only set
      // by requestPermissions; without this call `show()` silently no-ops
      // even though system-level permissions are granted via Firebase.
      if (!kIsWeb && Platform.isIOS) {
        final iosPlugin = _localNotification
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
        await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
      }
    } catch (e, stk) {
      debugPrint('[notif] initLocalNotifications failed: $e; $stk');
      _isLocalNotificationsInitialized = false;
    }

    return _isLocalNotificationsInitialized;
  }

  Future<void> createNotificationChannel() async {
    if (kIsWeb || !Platform.isAndroid) return;
    final plugin = _localNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (plugin == null) return;
    await plugin.createNotificationChannel(
      const AndroidNotificationChannel(
        notificationChannelId,
        notificationChannelName,
        description: notificationChannelDescription,
        importance: Importance.high,
      ),
    );
  }

  Future<void> showLocalNotification(ChatNotification notification) {
    const androidDetails = AndroidNotificationDetails(
      notificationChannelId,
      notificationChannelName,
      channelDescription: notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    // `presentAlert` is the pre-iOS 14 flag; on iOS 14+ you must opt in to
    // `presentBanner` + `presentList` explicitly or the foreground
    // notification is silently dropped.
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentList: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.active,
    );

    const notificationDetails = NotificationDetails(iOS: iosDetails, android: androidDetails);
    final payload = jsonEncode({'data': notification.toJson()});

    // Stable id derived from the event — not `notification.hashCode` — so
    // iOS replaces a previous banner for the same message instead of
    // stacking a duplicate when onMessage fires twice.
    final id = _notificationIdFor(notification);

    debugPrint(
      '[notif] showLocalNotification id=$id type=${notification.type} '
      'cid=${notification.cid} title="${notification.title}" body="${notification.body}"',
    );

    return _localNotification.show(
      id: id,
      title: notification.title ?? 'New Notification',
      body: notification.body ?? 'You have a new notification.',
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }

  static int _notificationIdFor(ChatNotification notification) {
    final key = notification.messageId ?? '${notification.type}:${notification.cid}';
    return key.hashCode;
  }

  // Initial Notification -----------------------------------------------------

  /// Returns the notification that launched the app, if any.
  ///
  /// Checks both the FCM getInitialMessage (for OS-rendered APNs banners) and
  /// any flutter_local_notifications payload (for notifications we rendered
  /// ourselves). Only Stream Chat notifications are returned; everything
  /// else resolves to `null`.
  Future<ChatNotification?> _getInitialNotification() async {
    final results = await Future.wait([_initialFromFcm(), _initialFromLocal()]);
    return results.firstWhereOrNull((it) => it != null);
  }

  Future<ChatNotification?> _initialFromFcm() async {
    final msg = await FirebaseMessaging.instance.getInitialMessage();
    if (msg == null || msg.data.isEmpty) return null;
    final n = ChatNotification.fromJson(msg.data);
    return n.isStreamChat ? n : null;
  }

  Future<ChatNotification?> _initialFromLocal() async {
    if (!await initLocalNotifications()) return null;

    final details = await _localNotification.getNotificationAppLaunchDetails();
    if (details == null || !details.didNotificationLaunchApp) return null;

    return _parseLocalPayload(details.notificationResponse?.payload);
  }

  // Parses a `flutter_local_notifications` payload (as produced by
  // [showLocalNotification]) back into a [ChatNotification].
  static ChatNotification? _parseLocalPayload(String? raw) {
    if (raw == null) return null;
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final data = decoded['data'];
    if (data is! Map) return null;
    final n = ChatNotification.fromJson(data.cast<String, dynamic>());
    return n.isStreamChat ? n : null;
  }

  // Message Handlers ---------------------------------------------------------

  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedSubscription;

  void _registerMessageHandlers() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);
    _onMessageSubscription = FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    _onMessageOpenedSubscription = FirebaseMessaging.onMessageOpenedApp.listen(_onBackgroundMessageTap);
  }

  Future<void> _onForegroundMessage(RemoteMessage message) async {
    if (kIsWeb || message.data.isEmpty) return;

    final notification = ChatNotification.fromJson(message.data);
    if (!notification.isStreamChat) return;

    debugPrint(
      '[notif] onForegroundMessage type=${notification.type} cid=${notification.cid}',
    );

    try {
      await showLocalNotification(notification);
    } catch (e, stk) {
      debugPrint('[notif] showLocalNotification threw: $e; $stk');
    }
  }

  void _onBackgroundMessageTap(RemoteMessage message) {
    if (message.data.isEmpty) return;
    final notification = ChatNotification.fromJson(message.data);
    if (!notification.isStreamChat) return;
    _dispatchTap(notification, DeviceState.background);
  }

  // Fires when the user taps a notification we scheduled ourselves via
  // `flutter_local_notifications` (foreground banners).
  void _onBackgroundLocalMessageTap(NotificationResponse response) {
    final notification = _parseLocalPayload(response.payload);
    if (notification == null) return;
    _dispatchTap(notification, DeviceState.background);
  }

  void _dispatchTap(ChatNotification notification, DeviceState state) {
    debugPrint(
      '[notif] tap state=$state type=${notification.type} cid=${notification.cid}',
    );
    _onNotificationTap?.call((
      deviceState: state,
      notification: notification,
    ));
  }

  Future<void> clearNotifications() => _localNotification.cancelAll();

  Future<void> dispose() async {
    await _onMessageSubscription?.cancel();
    await _onMessageOpenedSubscription?.cancel();
    _onMessageSubscription = null;
    _onMessageOpenedSubscription = null;
  }
}

typedef OnNotificationTap = void Function(NotificationInfo info);

enum DeviceState { foreground, background, terminated }

/// Delivered to [NotificationService.onNotificationTap].
typedef NotificationInfo = ({
  DeviceState deviceState,
  ChatNotification notification,
});
