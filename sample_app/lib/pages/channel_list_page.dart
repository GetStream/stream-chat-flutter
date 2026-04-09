// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/pages/draft_list_page.dart';
import 'package:sample_app/pages/reminders_page.dart';
import 'package:sample_app/pages/thread_list_page.dart';
import 'package:sample_app/pages/user_mentions_page.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/state/init_data.dart';
import 'package:sample_app/utils/localizations.dart';
import 'package:sample_app/utils/shared_location_service.dart';
import 'package:sample_app/widgets/channel_list.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    super.key,
  });

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  int _currentIndex = 0;

  bool _isSelected(int index) => _currentIndex == index;

  List<BottomNavigationBarItem> get _navBarItems {
    final icons = context.streamIcons;

    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              _isSelected(0) ? icons.messageBubbleFill20 : icons.messageBubble20,
              color: _isSelected(0) ? StreamChatTheme.of(context).colorTheme.textHighEmphasis : Colors.grey,
            ),
            const PositionedDirectional(
              top: -4,
              start: 12,
              child: StreamUnreadIndicator(),
            ),
          ],
        ),
        label: AppLocalizations.of(context).chats,
      ),
      BottomNavigationBarItem(
        icon: Icon(
          _isSelected(1) ? icons.mention32 : icons.mention20,
          color: _isSelected(1) ? StreamChatTheme.of(context).colorTheme.textHighEmphasis : Colors.grey,
        ),
        label: AppLocalizations.of(context).mentions,
      ),
      BottomNavigationBarItem(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              _isSelected(2) ? icons.threadFill20 : icons.thread20,
              color: _isSelected(2) ? StreamChatTheme.of(context).colorTheme.textHighEmphasis : Colors.grey,
            ),
            PositionedDirectional(
              top: -4,
              start: 12,
              child: StreamUnreadIndicator.threads(),
            ),
          ],
        ),
        label: 'Threads',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          _isSelected(3) ? icons.edit32 : icons.edit20,
          color: _isSelected(3) ? StreamChatTheme.of(context).colorTheme.textHighEmphasis : Colors.grey,
        ),
        label: 'Drafts',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          icons.save20,
          color: _isSelected(4) ? StreamChatTheme.of(context).colorTheme.textHighEmphasis : Colors.grey,
        ),
        label: 'Reminders',
      ),
    ];
  }

  late final _locationService = SharedLocationService(
    client: StreamChat.of(context).client,
  );

  @override
  Widget build(BuildContext context) {
    final user = StreamChat.of(context).currentUser;
    if (user == null) {
      return const Offstage();
    }
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      appBar: StreamChannelListHeader(
        titleBuilder: _currentIndex == 0
            ? null
            : (context, status, client) {
                return Text(
                  _navBarItems[_currentIndex].label!,
                  style: context.streamTextTheme.headingSm,
                );
              },
        onNewChatButtonTap: () {
          GoRouter.of(context).pushNamed(Routes.NEW_CHAT.name);
        },
        preNavigationCallback: () => FocusScope.of(context).requestFocus(FocusNode()),
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
        unselectedLabelStyle: StreamChatTheme.of(context).textTheme.footnoteBold,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: StreamChatTheme.of(context).colorTheme.textHighEmphasis,
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
          ThreadListPage(),
          DraftListPage(),
          RemindersPage(),
        ],
      ),
    );
  }

  StreamSubscription<int>? badgeListener;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      badgeListener = StreamChat.of(context).client.state.totalUnreadCountStream.listen((count) {
        if (count > 0) {
          FlutterAppBadger.updateBadgeCount(count);
        } else {
          FlutterAppBadger.removeBadge();
        }
      });
    }

    _locationService.initialize();
  }

  @override
  void dispose() {
    badgeListener?.cancel();
    _locationService.dispose();
    super.dispose();
  }
}

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ColoredBox(
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
                    bottom: 20,
                    left: 8,
                  ),
                  child: Row(
                    children: [
                      StreamUserAvatar(
                        size: .lg,
                        user: user,
                        showOnlineIndicator: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
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
                  leading: Icon(
                    context.streamIcons.edit20,
                    color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(.5),
                  ),
                  onTap: () {
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
                  leading: Icon(
                    context.streamIcons.users20,
                    color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(.5),
                  ),
                  onTap: () {
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
                PreferenceBuilder<bool>(
                  preference: context.read<InitNotifier>().initData!.preferences.getBool(
                    'forceRtl',
                    defaultValue: false,
                  ),
                  builder: (context, forceRtl) => SwitchListTile(
                    secondary: Icon(
                      Icons.format_textdirection_r_to_l,
                      color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(.5),
                    ),
                    title: const Text(
                      'Force RTL',
                      style: TextStyle(fontSize: 14.5),
                    ),
                    value: forceRtl,
                    onChanged: (value) async {
                      final sp = await StreamingSharedPreferences.instance;
                      sp.setBool('forceRtl', value);
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: ListTile(
                      onTap: () async {
                        final client = StreamChat.of(context).client;
                        final router = GoRouter.of(context);

                        if (!kIsWeb) {
                          const secureStorage = FlutterSecureStorage();
                          await secureStorage.deleteAll();
                        }

                        await client.disconnectUser(flushChatPersistence: true);

                        router.goNamed(Routes.CHOOSE_USER.name);
                      },
                      leading: Icon(
                        context.streamIcons.user20,
                        color: StreamChatTheme.of(context).colorTheme.textHighEmphasis.withOpacity(.5),
                      ),
                      title: Text(
                        AppLocalizations.of(context).signOut,
                        style: const TextStyle(
                          fontSize: 14.5,
                        ),
                      ),
                      trailing: IconButton(
                        iconSize: 24,
                        icon: const StreamSvgIcon(icon: StreamSvgIcons.moon),
                        color: StreamChatTheme.of(context).colorTheme.textLowEmphasis,
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
