import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' hide Message;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sample_app/auth/auth_controller.dart';
import 'package:sample_app/firebase_options.dart';
import 'package:sample_app/notification/notification.dart';
import 'package:sample_app/notification/notification_service.dart';
import 'package:sample_app/utils/app_config.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

/// Top-level FCM background handler (Android only).
///
/// Runs in a separate isolate, so Firebase has to be re-initialized
/// from scratch. Pre-caches the referenced message to persistence and
/// renders a local banner. iOS alert pushes are rendered natively by
/// the OS and never reach this code path.
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

  await _preCacheMessage(notification);

  final notificationService = NotificationService(FlutterLocalNotificationsPlugin());
  if (!await notificationService.initLocalNotifications()) return;
  await notificationService.createNotificationChannel();
  await notificationService.showLocalNotification(notification);
}

/// Writes the referenced message to persistence so the UI has it
/// offline when the user taps. Failures fall back to the normal online
/// fetch.
Future<void> _preCacheMessage(ChatNotification notification) async {
  final messageId = notification.messageId;
  if (messageId == null) return;

  String? apiKey;
  String? userId;
  String? token;
  try {
    const secureStorage = FlutterSecureStorage();
    apiKey = await secureStorage.read(key: kStreamApiKey);
    userId = await secureStorage.read(key: kStreamUserId);
    token = await secureStorage.read(key: kStreamToken);
  } catch (e) {
    debugPrint('[notif-bg] failed to read credentials: $e');
    return;
  }

  if (userId == null || token == null) return;

  final persistenceClient = StreamChatPersistenceClient(logLevel: Level.SEVERE);
  final chatClient = StreamChatClient(
    apiKey ?? kDefaultStreamApiKey,
    logLevel: Level.SEVERE,
  )..chatPersistenceClient = persistenceClient;

  try {
    await chatClient.connectUser(
      User(id: userId),
      token,
      connectWebSocket: false,
    );
    if (!persistenceClient.isConnected) {
      await persistenceClient.connect(userId);
    }
    final response = await chatClient.getMessage(messageId);
    await persistenceClient.updateMessages(notification.cid, [response.message]);
  } catch (e, stk) {
    debugPrint('[notif-bg] pre-cache failed: $e; $stk');
  } finally {
    await chatClient.disconnectUser();
    await chatClient.dispose();
  }
}
