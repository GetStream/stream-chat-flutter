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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      //TODO change to system once dark theme is implemented
      themeMode: ThemeMode.light,
      builder: (context, widget) {
        return StreamChat(
          child: widget,
          client: client,
        );
      },
      home: client.state.user == null ? ChooseUserPage() : ChannelListPage(),
    );
  }
}

class ChannelListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = StreamChat.of(context).user;
    return Scaffold(
      appBar: ChannelListHeader(),
      drawer: _buildDrawer(context, user),
      drawerEdgeDragWidth: 50,
      body: ChannelsBloc(
        child: ChannelListView(
          onStartChatPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return NewChatScreen();
            }));
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
                leading: Icon(StreamIcons.edit),
                onTap: () {
                  Navigator.of(context)
                    ..pop()
                    ..push(MaterialPageRoute(builder: (context) {
                      return NewChatScreen();
                    }));
                },
                title: Text(
                  'New direct message',
                  style: TextStyle(
                    fontSize: 14.5,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(StreamIcons.group),
                onTap: () {
                  Navigator.of(context)
                    ..pop()
                    ..push(MaterialPageRoute(builder: (context) {
                      return NewGroupChatScreen();
                    }));
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
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChooseUserPage(),
                        ),
                      );
                    },
                    leading: Icon(StreamIcons.user),
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
      appBar: ChannelHeader(),
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
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4,
                    ),
                    child: TypingIndicator(
                      alignment: Alignment.bottomRight,
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
