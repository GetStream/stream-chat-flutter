import 'dart:io';

import 'package:example/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_apns/flutter_apns.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void showLocalNotification(Event event) async {
  if (event.message == null) return;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final initializationSettingsAndroid =
      AndroidInitializationSettings('launch_background');
  final initializationSettingsIOS = IOSInitializationSettings();
  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin.show(
    event.message.id.hashCode,
    event.message.user.name,
    event.message.text,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'message channel',
        'Message channel',
        'Channel used for showing messages',
        priority: Priority.high,
        importance: Importance.high,
      ),
      iOS: IOSNotificationDetails(),
    ),
  );
}

Future backgroundHandler(Map<String, dynamic> notification) async {
  print('new notification ${notification}');
  // final messageId = notification['data']['id'];
  //
  // final notificationData = await NotificationService.getAndStoreMessage(
  //   messageId: messageId,
  //   storeMessageHandler: (messageResponse) {
  //     return chatPersistentClient.updateChannelState(
  //       ChannelState(
  //         messages: [messageResponse.message],
  //         channel: messageResponse.channel,
  //       ),
  //     );
  //   },
  // );
  //
  // showLocalNotification(
  //   notificationData.message,
  //   notificationData.channel,
  // );
}

void initNotifications(Client client) {
  final connector = createPushConnector();
  connector.configure(
    onBackgroundMessage: backgroundHandler,
  );

  connector.requestNotificationPermissions();
  connector.token.addListener(() {
    if (connector.token.value != null) {
      client.addDevice(
        connector.token.value,
        Platform.isAndroid ? PushProvider.firebase : PushProvider.apn,
      );
    }
  });
}
