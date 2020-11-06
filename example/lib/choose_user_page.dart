import 'dart:io';

import 'package:example/advanced_options_page.dart';
import 'package:example/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apns/flutter_apns.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void showLocalNotification(Message message, ChannelModel channel) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final initializationSettingsAndroid =
      AndroidInitializationSettings('launch_background');
  final initializationSettingsIOS = IOSInitializationSettings();
  final initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin.show(
    message.id.hashCode,
    '${message.user.name} @ ${channel.name}',
    message.text,
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
  final messageId = notification['data']['message_id'];

  final notificationData =
      await NotificationService.getAndStoreMessage(messageId);

  showLocalNotification(
    notificationData.message,
    notificationData.channel,
  );
}

void _initNotifications(Client client) {
  final connector = createPushConnector();
  connector.configure(
    onBackgroundMessage: backgroundHandler,
  );

  connector.requestNotificationPermissions();
  connector.token.addListener(() {
    if (connector.token.value != null) {
      client.addDevice(
        connector.token.value,
        Platform.isAndroid ? 'firebase' : 'apn',
      );
    }
  });
}

class ChooseUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final users = <String, User>{
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidmlzaGFsIn0._JHWzo92fpTWZMZriJHXqOng6ShYVmWrdaIaPwEPKBg':
          User(
        id: 'vishal',
        extraData: {
          'name': 'Vishal',
        },
      ),
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic3VwZXItYmFuZC05In0.0L6lGoeLwkz0aZRUcpZKsvaXtNEDHBcezVTZ0oPq40A':
          User(
        id: 'super-band-9',
        extraData: {
          'name': 'John Doe',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic2FsdmF0b3JlIn0.GMEKyEhONmFnqtkf1TR1A3oUOSIWhjfQv5RpI906dAM':
          User(
        id: 'salvatore',
        extraData: {
          'name': 'Salvatore',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidG9tbWFzbyJ9.GTalMeZHaBdpIM5w-KWrVIDSy-ODkHTRkf1GZbWAveM':
          User(
        id: 'tommaso',
        extraData: {
          'name': 'Tommaso',
        },
      ),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiamFhcCJ9.xpGE2lu4OoYS7-2yy6PbF0gJnxOaxeGO4EU6xo4EdMU':
          User(
        id: 'jaap',
        extraData: {
          'name': 'Jaap',
        },
      ),
    };
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 34,
              bottom: 20,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/logo.svg',
                height: 40,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 13.0),
            child: Text(
              'Welcome to Stream Chat',
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            'Select a user to try the Flutter SDK:',
            style: TextStyle(
              fontSize: 14.5,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ...users.entries.map((entry) {
                  final token = entry.key;
                  final user = entry.value;
                  return ListTile(
                    onTap: () async {
                      final client = StreamChat.of(context).client;

                      await client.setUser(
                        User(id: user.id, extraData: {
                          'name': user.name,
                        }),
                        token,
                      );

                      if (!kIsWeb) {
                        _initNotifications(client);
                      }

                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return StreamChat(
                              client: client,
                              child: ChannelListPage(),
                            );
                          },
                        ),
                      );
                    },
                    leading: UserAvatar(
                      user: user,
                      constraints: BoxConstraints.tight(
                        Size.fromRadius(20),
                      ),
                    ),
                    title: Text(
                      user.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Stream test account'),
                    trailing: Icon(
                      StreamIcons.arrow_right,
                      color: StreamChatTheme.of(context).accentColor,
                    ),
                  );
                }),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdvancedOptionsPage(),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    child: Icon(
                      StreamIcons.settings,
                      color: Colors.black,
                    ),
                    backgroundColor: StreamChatTheme.of(context).secondaryColor,
                  ),
                  title: Text(
                    'Advanced Options',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Custom settings'),
                  trailing: Icon(
                    StreamIcons.arrow_right,
                    color: StreamChatTheme.of(context).accentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
