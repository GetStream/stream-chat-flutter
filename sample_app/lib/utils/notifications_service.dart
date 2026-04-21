import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' hide Message;
import 'package:go_router/go_router.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void showLocalNotification(
  Event event,
  String currentUserId,
  BuildContext context,
) async {
  // Don't show notification if the event is from the current user.
  if (event.user!.id == currentUserId) return;

  // Don't show notification if the event is not a message.
  if (![
    EventType.messageNew,
    EventType.notificationMessageNew,
  ].contains(event.type)) {
    return;
  }

  // Return if the message is null.
  if (event.message == null) return;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettings = InitializationSettings(
    iOS: DarwinInitializationSettings(),
    android: AndroidInitializationSettings('ic_notification_in_app'),
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (response) async {
      final channelCid = response.payload;
      if (channelCid == null) return;

      final channelType = channelCid.split(':')[0];
      final channelId = channelCid.split(':')[1];

      final client = StreamChat.of(context).client;
      final router = GoRouter.of(context);

      final channel = client.channel(channelType, id: channelId);
      await channel.watch();

      router.pushNamed(
        Routes.CHANNEL_PAGE.name,
        pathParameters: Routes.CHANNEL_PAGE.params(channel),
      );
    },
  );

  // Resolve the notification body via [MessagePreviewFormatter] so
  // attachment-only messages (photo, video, voice, file, poll, ...) render
  // a readable label instead of an empty string.
  final currentUser = StreamChat.maybeOf(context)?.currentUser;
  final formatter = StreamChatConfiguration.of(context).messagePreviewFormatter;
  final previewSpan = formatter.formatMessage(context, event.message!, currentUser: currentUser);

  print('Showing notification for message: ${event.message!.text}, preview: ${previewSpan.toPlainText()}');

  await flutterLocalNotificationsPlugin.show(
    event.message!.id.hashCode,
    event.message!.user!.name,
    previewSpan.toPlainText(includePlaceholders: false).trim(),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'message channel',
        'Message channel',
        channelDescription: 'Channel used for showing messages',
        priority: Priority.high,
        importance: Importance.high,
      ),
      iOS: DarwinNotificationDetails(),
    ),
    payload: '${event.channelType}:${event.channelId}',
  );
}

Future<void> cancelLocalNotifications() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.cancelAll();
}
