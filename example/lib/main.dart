import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apns/apns.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
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

void main() async {
  final client = Client(
    's2dxdhpxd94g',
    logLevel: Level.INFO,
    showLocalNotification:
        (!kIsWeb && Platform.isAndroid) ? showLocalNotification : null,
    persistenceEnabled: true,
  );

  await client.setUser(
    User(id: 'super-band-9', extraData: {
      'name': 'Jonathan Doe',
    }),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic3VwZXItYmFuZC05In0.0L6lGoeLwkz0aZRUcpZKsvaXtNEDHBcezVTZ0oPq40A',
  );

  if (!kIsWeb) {
    _initNotifications(client);
  }

  runApp(MyApp(client));
}

class MyApp extends StatelessWidget {
  final Client client;

  MyApp(this.client);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      builder: (context, widget) {
        return StreamChat(
          child: widget,
          client: client,
        );
      },
      home: ChannelListPage(),
    );
  }
}

class ChannelListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return CreateChannelPage();
          }));
        },
      ),
      body: ChannelsBloc(
        child: ChannelListView(
          swipeToAction: true,
          filter: {
            'members': {
              '\$in': [StreamChat.of(context).user.id],
            }
          },
          options: {
            'presence': true,
          },
          sort: [SortOption('last_message_at')],
          pagination: PaginationParams(
            limit: 20,
          ),
          channelWidget: ChannelPage(),
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

class CreateChannelPage extends StatefulWidget {
  @override
  _CreateChannelPageState createState() => _CreateChannelPageState();
}

class _CreateChannelPageState extends State<CreateChannelPage> {
  final ScrollController _scrollController = ScrollController();
  Client client;
  List<User> users = [];
  List<User> selectedUsers = [];
  int offset = 0;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Create a channel',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      floatingActionButton:
          selectedUsers.isNotEmpty ? _buildFAB(context) : SizedBox(),
      body: _buildListView(),
    );
  }

  ListView _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: _itemBuilder,
      itemCount: users.length,
    );
  }

  Widget _itemBuilder(context, i) {
    final user = users[i];
    return ListTile(
      onLongPress: () {
        _selectUser(user);
      },
      selected: selectedUsers.contains(user),
      onTap: () {
        if (selectedUsers.isNotEmpty) {
          return _selectUser(user);
        }
        _createChannel(context, [user]);
      },
      leading: UserAvatar(
        user: user,
      ),
      title: Text(user.name),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.done),
      onPressed: () async {
        String name;
        if (selectedUsers.length > 1) {
          name = await _showEnterNameDialog(context);
          if (name?.isNotEmpty != true) {
            return;
          }
        }

        _createChannel(context, selectedUsers, name);
      },
    );
  }

  Future<String> _showEnterNameDialog(BuildContext context) {
    final controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        contentPadding: const EdgeInsets.all(16),
        title: Text('Enter a name for the channel'),
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          ButtonBar(
            children: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: Text('Ok'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future _createChannel(
    BuildContext context,
    List<User> users, [
    String name,
  ]) async {
    final channel = client.channel('messaging', extraData: {
      'members': [
        client.state.user.id,
        ...users.map((e) => e.id),
      ],
      if (name != null) 'name': name,
    });
    await channel.watch();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return StreamChannel(
            child: ChannelPage(),
            channel: channel,
          );
        },
      ),
    );
  }

  void _selectUser(User user) {
    if (!selectedUsers.contains(user)) {
      setState(() {
        selectedUsers.add(user);
      });
    } else {
      setState(() {
        selectedUsers.remove(user);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    client = StreamChat.of(context).client;

    _scrollController.addListener(() async {
      if (!loading &&
          _scrollController.offset >=
              _scrollController.position.maxScrollExtent - 100) {
        offset += 25;
        await _queryUsers();
      }
    });

    _queryUsers();
  }

  Future<void> _queryUsers() {
    loading = true;
    return client.queryUsers(
      pagination: PaginationParams(
        limit: 25,
        offset: offset,
      ),
      sort: [
        SortOption(
          'name',
          direction: SortOption.ASC,
        ),
      ],
    ).then((value) {
      setState(() {
        users = [
          ...users,
          ...value.users,
        ];
      });
    }).whenComplete(() => loading = false);
  }
}
