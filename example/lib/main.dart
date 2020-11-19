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
                  emptyBuilder: (_) {
                    return LayoutBuilder(
                      builder: (context, viewportConstraints) {
                        return SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: viewportConstraints.maxHeight,
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Icon(
                                      StreamIcons.search,
                                      size: 96,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text('No user matches these keywords...'),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
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
  TextEditingController _controller;

  String _userNameQuery = '';

  final _selectedUsers = <User>{};

  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
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
        elevation: 2,
        backgroundColor: Colors.white,
        title: Text(
          'Add Group Members',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          if (_selectedUsers.isNotEmpty)
            IconButton(
              icon: Icon(
                StreamIcons.arrow_right,
                color: Colors.blue.shade700,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupChatDetailsScreen(
                      selectedUsers: _selectedUsers.toList(growable: false),
                    ),
                  ),
                );
              },
            )
        ],
      ),
      body: UsersBloc(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  prefixIcon: Icon(StreamIcons.search),
                  hintText: 'Search',
                  contentPadding: const EdgeInsets.all(8),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            if (_selectedUsers.isNotEmpty)
              Container(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedUsers.length,
                  padding: const EdgeInsets.all(8),
                  separatorBuilder: (_, __) => SizedBox(width: 16),
                  itemBuilder: (_, index) {
                    final user = _selectedUsers.elementAt(index);
                    return Column(
                      children: [
                        Stack(
                          children: [
                            UserAvatar(
                              user: user,
                              showOnlineStatus: true,
                              borderRadius: BorderRadius.circular(40),
                              constraints: BoxConstraints.tightFor(
                                height: 80,
                                width: 80,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  if (_selectedUsers.contains(user)) {
                                    setState(() => _selectedUsers.remove(user));
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: Colors.grey.shade100),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.clear_rounded,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          user.name.split(' ')[0],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  },
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
                      ? 'Matches for \"$_userNameQuery\"'
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
                    setState(() {
                      _selectedUsers.add(user);
                    });
                  }
                },
                pagination: PaginationParams(
                  limit: 25,
                ),
                emptyBuilder: (_) {
                  return LayoutBuilder(
                    builder: (context, viewportConstraints) {
                      return SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Icon(
                                    StreamIcons.search,
                                    size: 96,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text('No user matches these keywords...'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupChatDetailsScreen extends StatefulWidget {
  final List<User> selectedUsers;

  const GroupChatDetailsScreen({
    Key key,
    @required this.selectedUsers,
  }) : super(key: key);

  @override
  _GroupChatDetailsScreenState createState() => _GroupChatDetailsScreenState();
}

class _GroupChatDetailsScreenState extends State<GroupChatDetailsScreen> {
  final _selectedUsers = <User>[];

  TextEditingController _groupNameController;

  Channel _channel;

  bool _isGroupNameEmpty = true;

  int get _totalUsers => _selectedUsers.length;

  @override
  void initState() {
    super.initState();
    _channel = StreamChat.of(context).client.channel('messaging');
    _selectedUsers.addAll(widget.selectedUsers);
    _groupNameController = TextEditingController()
      ..addListener(() {
        final name = _groupNameController.text;
        setState(() {
          _isGroupNameEmpty = name.isEmpty;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: Text(
          'Name of Group Chat',
          style: TextStyle(color: Colors.black),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Text(
                  'NAME',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _groupNameController,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        hintText: 'Choose a group chat name',
                        hintStyle: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          NeumorphicButton(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: Icon(StreamIcons.check),
              color: Colors.blue.shade700,
              onPressed: _isGroupNameEmpty
                  ? null
                  : () async {
                      final groupName = _groupNameController.text;
                      final client = _channel.client;
                      _channel.extraData = {
                        'members': [
                          client.state.user.id,
                          ..._selectedUsers.map((e) => e.id),
                        ],
                        'name': groupName,
                      };
                      await _channel.watch();
                      Navigator.of(context)
                        ..pop()
                        ..pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return StreamChannel(
                                child: ChannelPage(),
                                channel: _channel,
                              );
                            },
                          ),
                        );
                    },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.maxFinite,
            color: Colors.grey.shade50,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              child: Text(
                '$_totalUsers ${_totalUsers > 1 ? 'Members' : 'Member'}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _selectedUsers.length,
              separatorBuilder: (_, __) => Container(
                height: 1,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.1),
              ),
              itemBuilder: (_, index) {
                final user = _selectedUsers[index];
                return UserItem(
                  key: ObjectKey(user),
                  user: user,
                  selected: true,
                  showLastSeen: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
