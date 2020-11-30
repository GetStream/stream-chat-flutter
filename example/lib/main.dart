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
import 'search_text_field.dart';
import 'dart:async';

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
    backgroundKeepAlive: Duration(seconds: 3),
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
        initialRoute:
            client.state.user == null ? Routes.CHOOSE_USER : Routes.HOME,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  bool _isSelected(int index) => _currentIndex == index;

  List<BottomNavigationBarItem> get _navBarItems {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Stack(
          overflow: Overflow.visible,
          children: [
            StreamSvgIcon.message(
              color: _isSelected(0) ? Colors.black : Colors.grey,
            ),
            Positioned(
              top: -3,
              right: -16,
              child: UnreadIndicator(),
            ),
          ],
        ),
        label: 'Chats',
      ),
      BottomNavigationBarItem(
        icon: Stack(
          overflow: Overflow.visible,
          children: [
            StreamSvgIcon.mentions(
              color: _isSelected(1) ? Colors.black : Colors.grey,
            ),
          ],
        ),
        label: 'Mentions',
      ),
    ];
  }

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: _navBarItems,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ChannelListPage(),
          UserMentionPage(),
        ],
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

class UserMentionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('On Pause Right Now!'),
    );
  }
}

class ChannelListPage extends StatefulWidget {
  @override
  _ChannelListPageState createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  TextEditingController _controller;

  String _channelQuery = '';

  bool _isSearchActive = false;

  Timer _debounce;

  void _channelQueryListener() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _channelQuery = _controller.text;
          _isSearchActive = _channelQuery.isNotEmpty;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_channelQueryListener);
  }

  @override
  void dispose() {
    _controller?.removeListener(_channelQueryListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = StreamChat.of(context).user;
    return ChannelsBloc(
      child: MessageSearchBloc(
        child: Column(
          children: [
            SearchTextField(
              controller: _controller,
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: (_) => FocusScope.of(context).unfocus(),
                  child: _isSearchActive
                      ? MessageSearchListView(
                          messageQuery: _channelQuery,
                          filters: {
                            'members': {
                              r'$in': [user.id]
                            }
                          },
                          sortOptions: [
                            SortOption(
                              'created_at',
                              direction: SortOption.ASC,
                            ),
                          ],
                          paginationParams: PaginationParams(limit: 20),
                          onItemTap: (message) {},
                        )
                      : ChannelListView(
                          onStartChatPressed: () {
                            Navigator.pushNamed(context, Routes.NEW_CHAT);
                          },
                          swipeToAction: true,
                          filter: {
                            'members': {
                              r'$in': [user.id],
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChannelQuerySearchResultPage extends StatelessWidget {
  final Stream<List<Message>> searchResultStream;

  const ChannelQuerySearchResultPage({
    Key key,
    @required this.searchResultStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      initialData: const <Message>[],
      stream: searchResultStream,
      builder: (context, snapshot) {
        final result = snapshot.data;
        return Column(
          children: [
            if (result.isNotEmpty)
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.02),
                      Colors.white.withOpacity(0.05),
                    ],
                    stops: [0, 1],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Text(
                    '${result.length} results',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: UserAvatar(),
                    title: Text(result[index].toJson().toString()),
                  );
                },
              ),
            ),
          ],
        );
      },
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
      backgroundColor: Color.fromRGBO(252, 252, 252, 1),
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
