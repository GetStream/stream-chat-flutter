import 'package:example/utils/localizations.dart';
import 'package:example/routes/routes.dart';
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
  if (![
        EventType.messageNew,
        EventType.notificationMessageNew,
      ].contains(event.type) ||
      event.user!.id == currentUserId) {
    return;
  }
  if (event.message == null) return;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notification_in_app');
  const initializationSettingsIOS = IOSInitializationSettings();
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  final appLocalizations = AppLocalizations.of(context);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (channelCid) async {
      debugPrint("[onSelectNotification] #firebase; channelCid: $channelCid");
      debugPrint("[onSelectNotification] #firebase; context: $context");
      if (channelCid != null) {
        final client = StreamChat.of(context).client;
        final router = GoRouter.of(context);

        var channel = client.state.channels[channelCid];

        if (channel == null) {
          final splits = channelCid.split(':');
          final type = splits[0];
          final id = splits[1];
          channel = client.channel(
            type,
            id: id,
          );
          await channel.watch();
        }

        router.pushNamed(
          Routes.CHANNEL_PAGE.name,
          params: Routes.CHANNEL_PAGE.params(channel),
        );
      }
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
      iOS: const IOSNotificationDetails(),
    ),
    payload: '${event.channelType}:${event.channelId}',
  );
}
