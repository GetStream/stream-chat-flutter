import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../auth/auth_controller.dart';
import 'channel_list_tab.dart';
import 'reminders_tab.dart';
import 'thread_list_tab.dart';

/// The authenticated shell: channels, threads and reminders tabs, and a drawer
/// behind the user's avatar.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;

  static const _labels = ['Chats', 'Threads', 'Reminders'];

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final textTheme = context.streamTextTheme;

    return StreamScaffold(
      backgroundColor: context.streamColorScheme.backgroundApp,
      appBar: StreamChannelListHeader(title: Text(_labels[_currentIndex], style: textTheme.headingSm)),
      drawer: const _HomeDrawer(),
      bottom: StreamBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          StreamBottomNavBarItem(icon: Icon(icons.messageBubble), label: _labels[0]),
          StreamBottomNavBarItem(icon: Icon(icons.thread), label: _labels[1]),
          StreamBottomNavBarItem(icon: Icon(icons.bell), label: _labels[2]),
        ],
      ),
      // Built on demand rather than kept alive, so a tab queries its list when
      // it is opened, the way the native apps do.
      body: switch (_currentIndex) {
        1 => const ThreadListTab(),
        2 => const RemindersTab(),
        _ => const ChannelListTab(),
      },
    );
  }
}

class _HomeDrawer extends StatelessWidget {
  const _HomeDrawer();

  @override
  Widget build(BuildContext context) {
    final user = StreamChat.of(context).currentUser;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: StreamUserAvatar(size: .md, user: user!, showOnlineIndicator: false),
              title: Text(user.name),
            ),
            const Spacer(),
            ListTile(
              leading: Icon(context.streamIcons.leave),
              title: const Text('Sign out'),
              onTap: () {
                Navigator.of(context).pop();
                authController.disconnect().ignore();
              },
            ),
          ],
        ),
      ),
    );
  }
}
