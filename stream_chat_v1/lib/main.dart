import 'dart:async';

import 'package:example/chat_info_screen.dart';
import 'package:example/choose_user_page.dart';
import 'package:example/group_info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'app_config.dart';
import 'notifications_service.dart';
import 'routes/app_routes.dart';
import 'routes/routes.dart';
import 'search_text_field.dart';

final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.SEVERE,
  connectionMode: ConnectionMode.background,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  InitData _initData;
  bool _animCompleted = false;
  Animation<double> _animation, _scaleAnimation;
  AnimationController _animationController, _scaleAnimationController;
  Animation<Color> _colorAnimation;
  int timeOfStartMs;

  Future<InitData> _initConnection() async {
    String apiKey, userId, token;

    if (!kIsWeb) {
      final secureStorage = FlutterSecureStorage();
      apiKey = await secureStorage.read(key: kStreamApiKey);
      userId = await secureStorage.read(key: kStreamUserId);
      token = await secureStorage.read(key: kStreamToken);
    }

    final client = StreamChatClient(
      apiKey ?? kDefaultStreamApiKey,
      logLevel: Level.SEVERE,
    )..chatPersistenceClient = chatPersistentClient;

    if (userId != null) {
      await client.connectUser(
        User(id: userId),
        token,
      );
    }

    final prefs = await StreamingSharedPreferences.instance;

    return InitData(client, prefs);
  }

  void _createAnimations() {
    _scaleAnimationController = AnimationController(
      vsync: this,
      value: 0,
      duration: Duration(
        milliseconds: 500,
      ),
    );
    _scaleAnimation = Tween(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.easeInOutBack,
    ));

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1000,
      ),
    );
    _animation = Tween(
      begin: 0.0,
      end: 1000.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _colorAnimation = ColorTween(
      begin: Color(0xff005FFF),
      end: Color(0xff005FFF),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _colorAnimation = ColorTween(
      begin: Color(0xff005FFF),
      end: Colors.transparent,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void initState() {
    timeOfStartMs = DateTime.now().millisecondsSinceEpoch;

    _createAnimations();

    _initConnection().then(
      (initData) {
        setState(() {
          _initData = initData;
        });

        var now = DateTime.now().millisecondsSinceEpoch;

        if (now - timeOfStartMs > 1500) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            _scaleAnimationController.forward().whenComplete(() {
              _animationController.forward();
            });
          });
        } else {
          Future.delayed(Duration(milliseconds: 1500)).then((value) {
            _scaleAnimationController.forward().whenComplete(() {
              _animationController.forward();
            });
          });
        }

        if (!kIsWeb) {
          _initData.client.state?.totalUnreadCountStream?.listen((count) {
            if (count > 0) {
              FlutterAppBadger.updateBadgeCount(count);
            } else {
              FlutterAppBadger.removeBadge();
            }
          });
        }
      },
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _animCompleted = true;
        });
      }
    });

    super.initState();
  }

  Widget _buildAnimation() {
    return MaterialApp(
      home: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, _) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: AnimatedBuilder(
                    animation: _colorAnimation,
                    builder: (context, snapshot) {
                      return Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints.expand(),
                        color: _colorAnimation == null
                            ? Color(0xff005FFF)
                            : _colorAnimation.value,
                        child: !_animationController.isAnimating
                            ? Lottie.asset(
                                'assets/floating_boat.json',
                                alignment: Alignment.center,
                              )
                            : SizedBox(),
                      );
                    }),
              );
            },
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, snapshot) {
              return Transform.scale(
                scale: _animation.value,
                child: Container(
                  width: 1.0,
                  height: 1.0,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(1 - _animationController.value),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_initData != null)
          PreferenceBuilder<int>(
            preference: _initData.preferences.getInt(
              'theme',
              defaultValue: 0,
            ),
            builder: (context, snapshot) => MaterialApp(
              builder: (context, child) {
                return StreamChat(
                  client: _initData.client,
                  onBackgroundEventReceived: (e) =>
                      showLocalNotification(e, _initData.client.state.user.id),
                  child: Builder(
                    builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
                      child: child,
                      value: SystemUiOverlayStyle(
                        systemNavigationBarColor:
                            StreamChatTheme.of(context).colorTheme.white,
                        systemNavigationBarIconBrightness:
                            Theme.of(context).brightness == Brightness.dark
                                ? Brightness.light
                                : Brightness.dark,
                      ),
                    ),
                  ),
                );
              },
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: {
                -1: ThemeMode.dark,
                0: ThemeMode.system,
                1: ThemeMode.light,
              }[snapshot],
              onGenerateRoute: AppRoutes.generateRoute,
              initialRoute: _initData.client.state.user == null
                  ? Routes.CHOOSE_USER
                  : Routes.HOME,
            ),
          ),
        if (!_animCompleted) _buildAnimation(),
      ],
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
          clipBehavior: Clip.none,
          children: [
            StreamSvgIcon.message(
              color: _isSelected(0)
                  ? StreamChatTheme.of(context).colorTheme.black
                  : Colors.grey,
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
          clipBehavior: Clip.none,
          children: [
            StreamSvgIcon.mentions(
              color: _isSelected(1)
                  ? StreamChatTheme.of(context).colorTheme.black
                  : Colors.grey,
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
      backgroundColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
      appBar: ChannelListHeader(
        onNewChatButtonTap: () {
          Navigator.pushNamed(context, Routes.NEW_CHAT);
        },
        preNavigationCallback: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      ),
      drawer: _buildDrawer(context, user),
      drawerEdgeDragWidth: 50,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: StreamChatTheme.of(context).colorTheme.white,
        currentIndex: _currentIndex,
        items: _navBarItems,
        selectedLabelStyle: StreamChatTheme.of(context).textTheme.footnoteBold,
        unselectedLabelStyle:
            StreamChatTheme.of(context).textTheme.footnoteBold,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: StreamChatTheme.of(context).colorTheme.black,
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
      child: Container(
        color: StreamChatTheme.of(context).colorTheme.white,
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
                    color: StreamChatTheme.of(context)
                        .colorTheme
                        .black
                        .withOpacity(.5),
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
                    color: StreamChatTheme.of(context)
                        .colorTheme
                        .black
                        .withOpacity(.5),
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
                        Navigator.pop(context);

                        if (!kIsWeb) {
                          final secureStorage = FlutterSecureStorage();
                          await secureStorage.deleteAll();
                        }

                        StreamChat.of(context).client.disconnect(
                              clearUser: true,
                            );

                        await Navigator.pushReplacementNamed(
                          context,
                          Routes.CHOOSE_USER,
                        );
                      },
                      leading: StreamSvgIcon.user(
                        color: StreamChatTheme.of(context)
                            .colorTheme
                            .black
                            .withOpacity(.5),
                      ),
                      title: Text(
                        'Sign out',
                        style: TextStyle(
                          fontSize: 14.5,
                        ),
                      ),
                      trailing: IconButton(
                        icon: StreamSvgIcon.iconMoon(
                          size: 24,
                        ),
                        color: StreamChatTheme.of(context).colorTheme.grey,
                        onPressed: () async {
                          final sp = await StreamingSharedPreferences.instance;
                          sp.setInt(
                            'theme',
                            Theme.of(context).brightness == Brightness.dark
                                ? 1
                                : -1,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserMentionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = StreamChat.of(context).user;
    return MessageSearchBloc(
      child: MessageSearchListView(
        filters: {
          'members': {
            r'$in': [user.id],
          },
        },
        messageFilters: {
          'mentioned_users.id': {
            r'$contains': user.id,
          },
        },
        sortOptions: [
          SortOption(
            'created_at',
            direction: SortOption.ASC,
          ),
        ],
        paginationParams: PaginationParams(limit: 20),
        showResultCount: false,
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
                          child: StreamSvgIcon.mentions(
                            size: 96,
                            color: StreamChatTheme.of(context)
                                .colorTheme
                                .greyGainsboro,
                          ),
                        ),
                        Text(
                          'No mentions exist yet...',
                          style: StreamChatTheme.of(context)
                              .textTheme
                              .body
                              .copyWith(
                                color:
                                    StreamChatTheme.of(context).colorTheme.grey,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        onItemTap: (messageResponse) async {
          final client = StreamChat.of(context).client;
          final message = messageResponse.message;
          final channel = client.channel(
            messageResponse.channel.type,
            id: messageResponse.channel.id,
          );
          if (channel.state == null) {
            await channel.watch();
          }
          Navigator.pushNamed(
            context,
            Routes.CHANNEL_PAGE,
            arguments: ChannelPageArgs(
              channel: channel,
              initialMessage: message,
            ),
          );
        },
      ),
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
    return WillPopScope(
      onWillPop: () async {
        if (_isSearchActive) {
          _controller.clear();
          setState(() => _isSearchActive = false);
          return false;
        }
        return true;
      },
      child: ChannelsBloc(
        child: MessageSearchBloc(
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (_, __) => [
              SliverToBoxAdapter(
                child: SearchTextField(
                  controller: _controller,
                  showCloseButton: _isSearchActive,
                ),
              ),
            ],
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanDown: (_) => FocusScope.of(context).unfocus(),
                child: _isSearchActive
                    ? MessageSearchListView(
                        showErrorTile: true,
                        messageQuery: _channelQuery,
                        filters: {
                          'members': {
                            r'$in': [user.id]
                          },
                        },
                        sortOptions: [
                          SortOption(
                            'created_at',
                            direction: SortOption.ASC,
                          ),
                        ],
                        pullToRefresh: false,
                        paginationParams: PaginationParams(limit: 20),
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
                                          child: StreamSvgIcon.search(
                                            size: 96,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          'No results...',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        onItemTap: (messageResponse) async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final client = StreamChat.of(context).client;
                          final message = messageResponse.message;
                          final channel = client.channel(
                            messageResponse.channel.type,
                            id: messageResponse.channel.id,
                          );
                          if (channel.state == null) {
                            await channel.watch();
                          }
                          Navigator.pushNamed(
                            context,
                            Routes.CHANNEL_PAGE,
                            arguments: ChannelPageArgs(
                              channel: channel,
                              initialMessage: message,
                            ),
                          );
                        },
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
                        onViewInfoTap: (channel) {
                          Navigator.pop(context);
                          if (channel.memberCount == 2 && channel.isDistinct) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StreamChannel(
                                  channel: channel,
                                  child: ChatInfoScreen(
                                    user: channel.state.members
                                        .where((m) =>
                                            m.userId !=
                                            channel.client.state.user.id)
                                        .first
                                        .user,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StreamChannel(
                                  channel: channel,
                                  child: GroupInfoScreen(),
                                ),
                              ),
                            );
                          }
                        },
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChannelPageArgs {
  final Channel channel;
  final Message initialMessage;

  const ChannelPageArgs({
    this.channel,
    this.initialMessage,
  });
}

class ChannelPage extends StatefulWidget {
  final int initialScrollIndex;
  final double initialAlignment;
  final bool highlightInitialMessage;

  const ChannelPage({
    Key key,
    this.initialScrollIndex,
    this.initialAlignment,
    this.highlightInitialMessage = false,
  }) : super(key: key);

  @override
  _ChannelPageState createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  Message _quotedMessage;
  FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _reply(Message message) {
    setState(() => _quotedMessage = message);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
      appBar: ChannelHeader(
        showTypingIndicator: false,
        onImageTap: () async {
          var channel = StreamChannel.of(context).channel;

          if (channel.memberCount == 2 && channel.isDistinct) {
            final currentUser = StreamChat.of(context).user;
            final otherUser = channel.state.members.firstWhere(
              (element) => element.user.id != currentUser.id,
              orElse: () => null,
            );
            if (otherUser != null) {
              final pop = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StreamChannel(
                    child: ChatInfoScreen(
                      user: otherUser.user,
                    ),
                    channel: channel,
                  ),
                ),
              );

              if (pop == true) {
                Navigator.pop(context);
              }
            }
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StreamChannel(
                  child: GroupInfoScreen(),
                  channel: channel,
                ),
              ),
            );
          }
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                MessageListView(
                  initialScrollIndex: widget.initialScrollIndex,
                  initialAlignment: widget.initialAlignment,
                  highlightInitialMessage: widget.highlightInitialMessage,
                  onMessageSwiped: _reply,
                  onReplyTap: _reply,
                  threadBuilder: (_, parentMessage) {
                    return ThreadPage(
                      parent: parentMessage,
                    );
                  },
                  onShowMessage: (m, c) async {
                    final client = StreamChat.of(context).client;
                    final message = m;
                    final channel = client.channel(
                      c.type,
                      id: c.id,
                    );
                    if (channel.state == null) {
                      await channel.watch();
                    }
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.CHANNEL_PAGE,
                      arguments: ChannelPageArgs(
                        channel: channel,
                        initialMessage: message,
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    color: StreamChatTheme.of(context)
                        .colorTheme
                        .whiteSnow
                        .withOpacity(.9),
                    child: TypingIndicator(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      style: StreamChatTheme.of(context)
                          .textTheme
                          .footnote
                          .copyWith(
                              color:
                                  StreamChatTheme.of(context).colorTheme.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          MessageInput(
            focusNode: _focusNode,
            quotedMessage: _quotedMessage,
            onQuotedMessageCleared: () {
              setState(() => _quotedMessage = null);
              _focusNode.unfocus();
            },
          ),
        ],
      ),
    );
  }
}

class ThreadPage extends StatefulWidget {
  final Message parent;
  final int initialScrollIndex;
  final double initialAlignment;

  ThreadPage({
    Key key,
    this.parent,
    this.initialScrollIndex,
    this.initialAlignment,
  }) : super(key: key);

  @override
  _ThreadPageState createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  Message _quotedMessage;
  FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _reply(Message message) {
    setState(() => _quotedMessage = message);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.whiteSnow,
      appBar: ThreadHeader(
        parent: widget.parent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(
              parentMessage: widget.parent,
              initialScrollIndex: widget.initialScrollIndex,
              initialAlignment: widget.initialAlignment,
              onMessageSwiped: _reply,
              onReplyTap: _reply,
            ),
          ),
          if (widget.parent.type != 'deleted')
            MessageInput(
              parentMessage: widget.parent,
              focusNode: _focusNode,
              quotedMessage: _quotedMessage,
              onQuotedMessageCleared: () {
                setState(() => _quotedMessage = null);
                _focusNode.unfocus();
              },
            ),
        ],
      ),
    );
  }
}

class InitData {
  final StreamChatClient client;
  final StreamingSharedPreferences preferences;

  InitData(this.client, this.preferences);
}

class HolePainter extends CustomPainter {
  HolePainter({
    @required this.color,
    @required this.holeSize,
  });

  Color color;
  double holeSize;

  @override
  void paint(Canvas canvas, Size size) {
    double radius = holeSize / 2;
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    Rect outerCircleRect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius);
    Rect innerCircleRect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2), radius: radius / 2);

    Path transparentHole = Path.combine(
      PathOperation.difference,
      Path()..addRect(rect),
      Path()
        ..addOval(outerCircleRect)
        ..close(),
    );

    Path halfTransparentRing = Path.combine(
      PathOperation.difference,
      Path()
        ..addOval(outerCircleRect)
        ..close(),
      Path()
        ..addOval(innerCircleRect)
        ..close(),
    );

    canvas.drawPath(transparentHole, Paint()..color = color);
    canvas.drawPath(
        halfTransparentRing, Paint()..color = color.withOpacity(0.5));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
