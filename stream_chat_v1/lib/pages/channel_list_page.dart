import 'dart:async';

import 'package:example/app.dart';
import 'package:example/state/init_data.dart';
import 'package:example/pages/user_mentions_page.dart';
import 'package:example/routes/routes.dart';
import 'package:example/utils/app_config.dart';
import 'package:example/utils/localizations.dart';
import 'package:example/widgets/channel_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
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
                  ? StreamChatTheme.of(context).colorTheme.textHighEmphasis
                  : Colors.grey,
            ),
            const Positioned(
              top: -3,
              right: -16,
              child: StreamUnreadIndicator(),
            ),
          ],
        ),
        label: AppLocalizations.of(context).chats,
      ),
      BottomNavigationBarItem(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            StreamSvgIcon.mentions(
              color: _isSelected(1)
                  ? StreamChatTheme.of(context).colorTheme.textHighEmphasis
                  : Colors.grey,
            ),
          ],
        ),
        label: AppLocalizations.of(context).mentions,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print(">>>>>>>>>> ChannelListPage");
    final user = StreamChat.of(context).currentUser;
    if (user == null) {
      return const Offstage();
    }
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      appBar: StreamChannelListHeader(
        onNewChatButtonTap: () {
          print(">>>>>>>>>> onNewChatButtonTap");
          GoRouter.of(context).pushNamed(Routes.NEW_CHAT.name);
        },
        preNavigationCallback: () =>
            FocusScope.of(context).requestFocus(FocusNode()),
      ),
      drawer: LeftDrawer(
        user: user,
      ),
      drawerEdgeDragWidth: 50,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: StreamChatTheme.of(context).colorTheme.barsBg,
        currentIndex: _currentIndex,
        items: _navBarItems,
        selectedLabelStyle: StreamChatTheme.of(context).textTheme.footnoteBold,
        unselectedLabelStyle:
            StreamChatTheme.of(context).textTheme.footnoteBold,
        type: BottomNavigationBarType.fixed,
        selectedItemColor:
            StreamChatTheme.of(context).colorTheme.textHighEmphasis,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ChannelList(),
          UserMentionsPage(),
        ],
      ),
    );
  }

  StreamSubscription<int>? badgeListener;

  @override
  void initState() {
    if (!kIsWeb) {
      badgeListener = StreamChat.of(context)
          .client
          .state
          .totalUnreadCountStream
          .listen((count) {
        if (count > 0) {
          FlutterAppBadger.updateBadgeCount(count);
        } else {
          FlutterAppBadger.removeBadge();
        }
      });
      unawaited(_setupPushNotifications(StreamChat.of(context).client));
    }
    super.initState();
  }

  Future<void> _setupPushNotifications(StreamChatClient client) async {
    
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('[setupPushNotifications] #firebase; settings: ${settings.authorizationStatus}');

    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      final result = await client.addDevice(token, PushProvider.firebase);
      print('[setupPushNotifications] #firebase; token registered: $token');
    }
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      final result = await client.addDevice(token, PushProvider.firebase);
      print('[setupPushNotifications] #firebase; token refreshed: $token');
    });

  }

  @override
  void dispose() {
    badgeListener?.cancel();
    super.dispose();
  }
}

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: StreamChatTheme.of(context).colorTheme.barsBg,
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
                      StreamUserAvatar(
                        user: user,
                        showOnlineStatus: false,
                        constraints:
                            BoxConstraints.tight(const Size.fromRadius(20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          user.name,
                          style: const TextStyle(
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
                        .textHighEmphasis
                        .withOpacity(.5),
                  ),
                  onTap: () {
                    print(">>>>>>>>>> NEW_CHAT");
                    Navigator.of(context).pop();
                    GoRouter.of(context).pushNamed(Routes.NEW_CHAT.name);
                  },
                  title: Text(
                    AppLocalizations.of(context).newDirectMessage,
                    style: const TextStyle(
                      fontSize: 14.5,
                    ),
                  ),
                ),
                ListTile(
                  leading: StreamSvgIcon.contacts(
                    color: StreamChatTheme.of(context)
                        .colorTheme
                        .textHighEmphasis
                        .withOpacity(.5),
                  ),
                  onTap: () {
                    print(">>>>>>>>>> NEW_GROUP_CHAT");
                    Navigator.of(context).pop();
                    GoRouter.of(context).pushNamed(Routes.NEW_GROUP_CHAT.name);
                  },
                  title: Text(
                    AppLocalizations.of(context).newGroup,
                    style: const TextStyle(
                      fontSize: 14.5,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      onTap: () async {
                        print(">>>>>>>>>> CHOOSE_USER");
                        final client = StreamChat.of(context).client;
                        final router = GoRouter.of(context);
                        final initNotifier = context.read<InitNotifier>();

                        if (!kIsWeb) {
                          const secureStorage = FlutterSecureStorage();
                          await secureStorage.deleteAll();
                        }

                        await client.disconnectUser(flushChatPersistence: true);
                        await client.dispose();
                        initNotifier.initData = initNotifier.initData!.copyWith(
                            client:
                                buildStreamChatClient(kDefaultStreamApiKey));

                        router.goNamed(Routes.CHOOSE_USER.name);
                      },
                      leading: StreamSvgIcon.user(
                        color: StreamChatTheme.of(context)
                            .colorTheme
                            .textHighEmphasis
                            .withOpacity(.5),
                      ),
                      title: Text(
                        AppLocalizations.of(context).signOut,
                        style: const TextStyle(
                          fontSize: 14.5,
                        ),
                      ),
                      trailing: IconButton(
                        icon: StreamSvgIcon.iconMoon(
                          size: 24,
                        ),
                        color: StreamChatTheme.of(context)
                            .colorTheme
                            .textLowEmphasis,
                        onPressed: () async {
                          final theme = Theme.of(context);
                          final sp = await StreamingSharedPreferences.instance;
                          sp.setInt(
                            'theme',
                            theme.brightness == Brightness.dark ? 1 : -1,
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
