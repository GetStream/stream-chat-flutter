import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' hide Message;
import 'package:sample_app/firebase_options.dart';
import 'package:sample_app/notification/notification.dart';
import 'package:sample_app/notification/notification_service.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Top-level FCM background handler (Android only).
///
/// Runs in a separate isolate, so Firebase has to be re-initialized
/// from scratch. Renders a local banner for the incoming push. iOS alert
/// pushes are rendered natively by the OS and never reach this code path.
///
/// Must stay top-level and keep `@pragma('vm:entry-point')` so release
/// tree shaking doesn't strip it.
@pragma('vm:entry-point')
Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
  // iOS renders alert pushes natively from `aps.alert`; nothing for us to do.
  if (CurrentPlatform.isWeb || !CurrentPlatform.isAndroid) return;

  if (message.data.isEmpty) return;

  final notification = ChatNotification.fromJson(message.data);
  if (!notification.isStreamChat) return;

  debugPrint('[notif-bg] type=${notification.type} cid=${notification.cid}');

  // Background isolate — Firebase must be re-initialized before use.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final notificationService = NotificationService(FlutterLocalNotificationsPlugin());
  if (!await notificationService.initLocalNotifications()) return;
  await notificationService.createNotificationChannel();
  await notificationService.showLocalNotification(notification);
}
