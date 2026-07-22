import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart' hide Message;
import 'package:sample_app/notification/notification.dart';
import 'package:sample_app/notification/notification_background_handler.dart';
import 'package:sample_app/utils/firebase_support.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// The Android notification-channel id used for all chat notifications.
const notificationChannelId = 'stream_chat_channel';

/// The user-facing name of the Android notification channel.
const notificationChannelName = 'Stream Chat Notifications';

/// The user-facing description of the Android notification channel.
const notificationChannelDescription = 'Notifications for Stream Chat';

/// Orchestrates FCM and `flutter_local_notifications` for the sample
/// app.
///
/// Foreground pushes are re-rendered as local banners so the app owns
/// the title/body formatting. Background/terminated pushes are rendered
/// by the OS, and taps funnel through [onNotificationTap] regardless of
/// which path delivered them.
class NotificationService {
  NotificationService(this._localNotification);
  final FlutterLocalNotificationsPlugin _localNotification;

  /// Called once per notification tap. Set before [initialize] so the
  /// app-launch notification isn't missed.
  set onNotificationTap(OnNotificationTap value) => _onNotificationTap = value;
  OnNotificationTap? _onNotificationTap;

  /// Requests permission, registers handlers, and dispatches any
  /// pending launch notification. Call once per instance.
  Future<void> initialize() async {
    // Skip entirely on platforms without Firebase Cloud Messaging (desktop
    // Linux/Windows); otherwise the FCM calls below crash on a missing app.
    if (!isFirebaseSupported) {
      debugPrint('[notif] FCM unsupported on this platform; skipping init');
      return;
    }

    _registerMessageHandlers();
    await requestPermission();
    await initLocalNotifications();
    await createNotificationChannel();

    if (!CurrentPlatform.isWeb && CurrentPlatform.isIos) {
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

  /// Requests the OS-level notification permission via Firebase.
  /// Returns `true` for full or provisional authorization.
  Future<bool> requestPermission() async {
    final result = await FirebaseMessaging.instance.requestPermission();
    return result.authorizationStatus == .authorized || result.authorizationStatus == .provisional;
  }

  var _isLocalNotificationsInitialized = false;

  /// Initializes `flutter_local_notifications`. Idempotent.
  Future<bool> initLocalNotifications() async {
    if (_isLocalNotificationsInitialized) return true;

    const initSettings = InitializationSettings(
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      android: AndroidInitializationSettings('ic_notification'),
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
      if (!CurrentPlatform.isWeb && CurrentPlatform.isIos) {
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

  /// Creates the chat notification channel on Android. No-op elsewhere.
  Future<void> createNotificationChannel() async {
    if (CurrentPlatform.isWeb || !CurrentPlatform.isAndroid) return;
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

  /// Renders [notification] as a local banner. The id is derived from
  /// the payload so duplicate events replace rather than stack.
  ///
  /// Notifications are grouped by channel cid: iOS uses `threadIdentifier`
  /// to collapse banners automatically; Android needs an explicit summary
  /// notification (see [_showAndroidGroupSummary]) on top of `groupKey`.
  Future<void> showLocalNotification(ChatNotification notification) async {
    final groupKey = notification.cid;

    final androidDetails = AndroidNotificationDetails(
      notificationChannelId,
      notificationChannelName,
      channelDescription: notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      groupKey: groupKey,
    );

    // `presentAlert` is the pre-iOS 14 flag; on iOS 14+ you must opt in to
    // `presentBanner` + `presentList` explicitly or the foreground
    // notification is silently dropped.
    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBanner: true,
      presentList: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.active,
      threadIdentifier: groupKey,
    );

    final notificationDetails = NotificationDetails(iOS: iosDetails, android: androidDetails);
    final payload = jsonEncode({'data': notification.toJson()});

    // Stable id derived from the event — not `notification.hashCode` — so
    // iOS replaces a previous banner for the same message instead of
    // stacking a duplicate when onMessage fires twice.
    final id = _notificationIdFor(notification);

    debugPrint(
      '[notif] showLocalNotification id=$id type=${notification.type} '
      'cid=${notification.cid} title="${notification.title}" body="${notification.body}"',
    );

    await _localNotification.show(
      id: id,
      title: notification.title ?? 'New Notification',
      body: notification.body ?? 'You have a new notification.',
      notificationDetails: notificationDetails,
      payload: payload,
    );

    // Android needs an explicit summary notification to visually group the
    // children; iOS handles grouping automatically via `threadIdentifier`.
    if (!CurrentPlatform.isWeb && CurrentPlatform.isAndroid) {
      await _showAndroidGroupSummary(groupKey);
    }
  }

  /// Posts (or refreshes) the Android summary notification for [groupKey].
  ///
  /// Android only collapses children into a group once a summary with the
  /// same `groupKey` exists. The summary id is stable per cid so subsequent
  /// messages in the same channel update the summary in place.
  Future<void> _showAndroidGroupSummary(String groupKey) {
    final summaryDetails = AndroidNotificationDetails(
      notificationChannelId,
      notificationChannelName,
      channelDescription: notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      groupKey: groupKey,
      setAsGroupSummary: true,
      // Children make the sound; the summary is silent so a new message in
      // an already-grouped channel doesn't double-buzz.
      groupAlertBehavior: GroupAlertBehavior.children,
    );

    return _localNotification.show(
      id: _summaryNotificationIdFor(groupKey),
      title: 'New messages',
      notificationDetails: NotificationDetails(android: summaryDetails),
    );
  }

  static int _notificationIdFor(ChatNotification notification) {
    final key = notification.messageId ?? '${notification.type}:${notification.cid}';
    return key.hashCode;
  }

  // Different namespace from [_notificationIdFor] so a child notification
  // and its group summary can never collide on hashCode.
  static int _summaryNotificationIdFor(String groupKey) => 'summary:$groupKey'.hashCode;

  // Initial Notification -----------------------------------------------------

  /// Returns the Stream Chat notification that launched the app, if
  /// any, from either the FCM initial message or a local payload.
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
    if (CurrentPlatform.isWeb || message.data.isEmpty) return;

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

  /// Cancels every notification currently displayed by the app.
  Future<void> clearNotifications() => _localNotification.cancelAll();

  /// Cancels the FCM subscriptions started in [initialize].
  Future<void> dispose() async {
    await _onMessageSubscription?.cancel();
    await _onMessageOpenedSubscription?.cancel();
    _onMessageSubscription = null;
    _onMessageOpenedSubscription = null;
  }
}

/// Signature for [NotificationService.onNotificationTap].
typedef OnNotificationTap = void Function(NotificationInfo info);

/// The process state of the app when a notification was tapped.
enum DeviceState { foreground, background, terminated }

/// The payload delivered to [NotificationService.onNotificationTap].
typedef NotificationInfo = ({
  DeviceState deviceState,
  ChatNotification notification,
});
