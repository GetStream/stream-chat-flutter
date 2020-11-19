import 'dart:io';

import 'package:example/choose_user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'chips_input_text_field.dart';
import 'notifications_service.dart';
import 'neumorphic_button.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Stream Chat',
          style: TextStyle(color: Colors.black),
        ),
      ),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NewChatScreen()),
                    );
                  },
                  leading: Icon(StreamIcons.edit),
                  title: Text(
                    'New direct message',
                    style: TextStyle(
                      fontSize: 14.5,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NewGroupChatScreen()),
                    );
                  },
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
  final selectedUsers = <User>{};

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
          selectedUsers.isNotEmpty ? _buildFAB(context) : null,
      body: _buildListView(),
    );
  }

  Widget _buildListView() {
    return UsersBloc(
      child: UserListView(
        pagination: PaginationParams(
          limit: 25,
        ),
        sort: [
          SortOption(
            'name',
            direction: SortOption.ASC,
          ),
        ],
        onUserLongPress: (user) {
          _selectUser(user);
        },
        selectedUsers: selectedUsers,
        onUserTap: (user, _) {
          if (selectedUsers.isNotEmpty) {
            return _selectUser(user);
          }
          _createChannel(context, [user]);
        },
      ),
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

        _createChannel(context, selectedUsers.toList(), name);
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
    final client = StreamChat.of(context).client;
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
}

class NewChatScreen extends StatefulWidget {
  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final _chipInputTextFieldStateKey =
      GlobalKey<ChipInputTextFieldState<User>>();

  TextEditingController _controller;

  ChipInputTextFieldState get _chipInputTextFieldState =>
      _chipInputTextFieldStateKey.currentState;

  String _userNameQuery = '';

  final _selectedUsers = <User>{};

  bool _isSearchActive = false;

  Channel channel;

  @override
  void initState() {
    super.initState();
    channel = StreamChat.of(context).client.channel('messaging');
    _controller = TextEditingController()
      ..addListener(() {
        setState(() {
          _userNameQuery = _controller.text;
          _isSearchActive = _userNameQuery.isNotEmpty;
        });
      });
  }

  @override
  void dispose() {
    _controller?.clear();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'New Chat',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamChannel(
        showLoading: false,
        channel: channel,
        child: UsersBloc(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ChipsInputTextField<User>(
                key: _chipInputTextFieldStateKey,
                controller: _controller,
                focusNode: FocusNode(),
                chipBuilder: (context, user) {
                  return InputChip(
                    key: ObjectKey(user),
                    label: Text(
                      user.name,
                      style: TextStyle(color: Colors.black),
                    ),
                    avatar: UserAvatar(
                      user: user,
                    ),
                    onDeleted: () => _chipInputTextFieldState.removeItem(user),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                },
                onChipAdded: (user) {
                  setState(() => _selectedUsers.add(user));
                },
                onChipRemoved: (user) {
                  setState(() => _selectedUsers.remove(user));
                },
              ),
              if (!_isSearchActive)
                Container(
                  color: Colors.white54,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => NewGroupChatScreen()),
                      );
                    },
                    child: Row(
                      children: [
                        NeumorphicButton(
                          child: Icon(
                            StreamIcons.group,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Create a Group',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Container(
                width: double.maxFinite,
                color: Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Text(
                    _isSearchActive
                        ? "Matches for \"$_userNameQuery\""
                        : 'On the platform',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: UserListView(
                  filterByUserName: _userNameQuery,
                  selectedUsers: _selectedUsers,
                  groupAlphabetically: _isSearchActive ? false : true,
                  onUserTap: (user, _) {
                    if (!_selectedUsers.contains(user)) {
                      _controller.clear();
                      _chipInputTextFieldState
                        ..addItem(user)
                        ..pauseItemAddition();
                    }
                  },
                  pagination: PaginationParams(
                    limit: 25,
                  ),
                ),
              ),
              MessageInput(
                preMessageSending: (message) async {
                  channel.extraData = {
                    'members': [
                      ..._selectedUsers.map((e) => e.id),
                      channel.client.state.user.id,
                    ],
                  };
                  await channel.watch();
                  return message;
                },
                onMessageSent: (_) {
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewGroupChatScreen extends StatefulWidget {
  @override
  _NewGroupChatScreenState createState() => _NewGroupChatScreenState();
}

class _NewGroupChatScreenState extends State<NewGroupChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Add Group Members',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
