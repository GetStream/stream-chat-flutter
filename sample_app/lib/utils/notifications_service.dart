import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/utils/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'package:go_router/go_router.dart';
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
  ].contains(event.type)) return;

  // Return if the message is null.
  if (event.message == null) return;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettings = InitializationSettings(
    iOS: DarwinInitializationSettings(),
    android: AndroidInitializationSettings('ic_notification_in_app'),
  );

  final appLocalizations = AppLocalizations.of(context);

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

  await flutterLocalNotificationsPlugin.show(
    event.message!.id.hashCode,
    event.message!.user!.name,
    event.message!.text,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'message channel',
        appLocalizations.messageChannelName,
        channelDescription: appLocalizations.messageChannelDescription,
        priority: Priority.high,
        importance: Importance.high,
      ),
      iOS: const DarwinNotificationDetails(),
    ),
    payload: '${event.channelType}:${event.channelId}',
  );
}

Future<void> cancelLocalNotifications() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.cancelAll();
}
