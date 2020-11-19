import 'dart:io';

import 'package:example/choose_user_page.dart';
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
      drawer: Drawer(
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
                  title: Text(
                    'New direct message',
                    style: TextStyle(
                      fontSize: 14.5,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(StreamIcons.group),
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
      ),
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
              '\$in': [user.id],
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
