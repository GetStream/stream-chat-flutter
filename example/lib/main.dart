import 'dart:io';

import 'package:example/choose_user_page.dart';
import 'package:example/new_chat_screen.dart';
import 'package:example/new_group_chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'notifications_service.dart';
import 'routes/app_routes.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final secureStorage = FlutterSecureStorage();

  final apiKey = await secureStorage.read(key: kStreamApiKey);
  final userId = await secureStorage.read(key: kStreamUserId);

  final client = Client(
    apiKey ?? kDefaultStreamApiKey,
    logLevel: Level.INFO,
    showLocalNotification:
        (!kIsWeb && Platform.isAndroid) ? showLocalNotification : null,
    persistenceEnabled: true,
  );

  if (userId != null) {
    final token = await secureStorage.read(key: kStreamToken);
    await client.setUser(
      User(id: userId),
      token,
    );
    if (!kIsWeb) {
      initNotifications(client);
    }
  }

  runApp(MyApp(client));
}

class MyApp extends StatelessWidget {
  final Client client;

  MyApp(this.client);

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: client,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        //TODO change to system once dark theme is implemented
        themeMode: ThemeMode.light,
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: client.state.user == null
            ? Routes.CHOOSE_USER
            : Routes.CHANNEL_LIST,
      ),
    );
  }
}

class ChannelListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = StreamChat.of(context).user;
    return Scaffold(
      appBar: ChannelListHeader(
        onNewChatButtonTap: () {
          Navigator.pushNamed(context, Routes.NEW_CHAT);
        },
      ),
      drawer: _buildDrawer(context, user),
      drawerEdgeDragWidth: 50,
      body: ChannelsBloc(
        child: ChannelListView(
          onStartChatPressed: () {
            Navigator.pushNamed(context, Routes.NEW_CHAT);
          },
          swipeToAction: true,
          filter: {
            'members': {
              '\$in': [user.id],
            },
            'draft': {
              r'$ne': true,
            },
          },
          options: {
            'presence': true,
          },
          pagination: PaginationParams(
            limit: 20,
          ),
          channelWidget: ChannelPage(),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context, User user) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top + 8,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                  left: 8,
                ),
                child: Row(
                  children: [
                    UserAvatar(
                      user: user,
                      showOnlineStatus: false,
                      constraints: BoxConstraints.tight(Size.fromRadius(20)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: StreamSvgIcon.penWrite(
                  color: Colors.black.withOpacity(.5),
                ),
                onTap: () {
                  Navigator.popAndPushNamed(
                    context,
                    Routes.NEW_CHAT,
                  );
                },
                title: Text(
                  'New direct message',
                  style: TextStyle(
                    fontSize: 14.5,
                  ),
                ),
              ),
              ListTile(
                leading: StreamSvgIcon.contacts(
                  color: Colors.black.withOpacity(.5),
                ),
                onTap: () {
                  Navigator.popAndPushNamed(
                    context,
                    Routes.NEW_GROUP_CHAT,
                  );
                },
                title: Text(
                  'New group',
                  style: TextStyle(
                    fontSize: 14.5,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: ListTile(
                    onTap: () async {
                      await StreamChat.of(context).client.disconnect();

                      final secureStorage = FlutterSecureStorage();
                      await secureStorage.deleteAll();
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.CHOOSE_USER,
                      );
                    },
                    leading: StreamSvgIcon.user(
                      color: Colors.black.withOpacity(.5),
                    ),
                    title: Text(
                      'Sign out',
                      style: TextStyle(
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(
        showTypingIndicator: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                MessageListView(
                  threadBuilder: (_, parentMessage) {
                    return ThreadPage(
                      parent: parentMessage,
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: Color(0xffFCFCFC).withOpacity(.9),
                    child: TypingIndicator(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          MessageInput(),
        ],
      ),
    );
  }
}

class ThreadPage extends StatelessWidget {
  final Message parent;

  ThreadPage({
    Key key,
    this.parent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThreadHeader(
        parent: parent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(
              parentMessage: parent,
            ),
          ),
          if (parent.type != 'deleted')
            MessageInput(
              parentMessage: parent,
            ),
        ],
      ),
    );
  }
}
