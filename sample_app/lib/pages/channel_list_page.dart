// ignore_for_file: deprecated_member_use, avoid_redundant_argument_values

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/auth/auth_controller.dart';
import 'package:sample_app/config/sample_app_config.dart';
import 'package:sample_app/config/sample_app_config_screen.dart';
import 'package:sample_app/pages/draft_list_page.dart';
import 'package:sample_app/pages/reminders_page.dart';
import 'package:sample_app/pages/thread_list_page.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/utils/shared_location_service.dart';
import 'package:sample_app/widgets/channel_list.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    super.key,
  });

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  int _currentIndex = 0;

  late final _locationService = SharedLocationService(
    client: StreamChat.of(context).client,
  );

  @override
  Widget build(BuildContext context) {
    final user = StreamChat.of(context).currentUser;
    if (user == null) return const Offstage();

    final icons = context.streamIcons;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    final config = context.sampleAppConfig;

    final allTabs = <_TabDef>[
      _TabDef(
        navItem: StreamBottomNavBarItem(
          icon: StreamUnreadIndicator(child: Icon(icons.messageBubble)),
          selectedIcon: StreamUnreadIndicator(child: Icon(icons.messageBubbleFill)),
          label: 'Chats',
        ),
        page: const ChannelList(),
      ),
      _TabDef(
        navItem: StreamBottomNavBarItem(
          icon: StreamUnreadIndicator.threads(child: Icon(icons.thread)),
          selectedIcon: StreamUnreadIndicator.threads(child: Icon(icons.threadFill)),
          label: 'Threads',
        ),
        page: const ThreadListPage(),
      ),
      _TabDef(
        navItem: const StreamBottomNavBarItem(
          icon: Icon(Icons.drafts_outlined),
          selectedIcon: Icon(Icons.drafts_rounded),
          label: 'Drafts',
        ),
        page: const DraftListPage(),
        enabled: config.draftMessagesEnabled,
      ),
      _TabDef(
        navItem: const StreamBottomNavBarItem(
          icon: Icon(Icons.bookmark_outline_rounded),
          selectedIcon: Icon(Icons.bookmark_rounded),
          label: 'Reminders',
        ),
        page: const RemindersPage(),
        enabled: config.enableReminderActions,
      ),
    ];

    final enabledTabs = allTabs.where((t) => t.enabled).toList();

    return StreamScaffold(
      backgroundColor: colorScheme.backgroundApp,
      appBar: StreamChannelListHeader(
        title: Text(enabledTabs[_currentIndex].navItem.label, style: textTheme.headingSm),
      ),
      drawer: LeftDrawer(user: user),
      bottom: StreamBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [for (final tab in enabledTabs) tab.navItem],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [for (final tab in enabledTabs) tab.page],
      ),
    );
  }

  StreamSubscription<int>? badgeListener;

  @override
  void initState() {
    super.initState();
    if (!CurrentPlatform.isWeb) {
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

// ---------------------------------------------------------------------------
// Tab definition
// ---------------------------------------------------------------------------

class _TabDef {
  const _TabDef({
    required this.navItem,
    required this.page,
    this.enabled = true,
  });

  final StreamBottomNavBarItem navItem;
  final Widget page;
  final bool enabled;
}

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    final textTheme = context.streamTextTheme;
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final config = context.sampleAppConfig;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      shape: const RoundedRectangleBorder(),
      backgroundColor: colorScheme.backgroundElevation1,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: spacing.lg),

            // ── Profile header ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.lg),
              child: Column(
                children: [
                  StreamUserAvatar(size: .xxl, user: user, showOnlineIndicator: false),
                  SizedBox(height: spacing.sm),
                  Text(
                    user.name,
                    style: textTheme.headingMd.copyWith(color: colorScheme.textPrimary),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: spacing.xxxs),
                  Text(
                    '@${user.id}',
                    style: textTheme.captionDefault.copyWith(color: colorScheme.textTertiary),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: spacing.lg),
            Divider(height: 1, indent: spacing.md, endIndent: spacing.md, color: colorScheme.borderSubtle),
            SizedBox(height: spacing.sm),

            // ── Navigation actions ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.xs),
              child: Column(
                children: [
                  StreamListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xxxs),
                    leading: Icon(icons.edit, size: 24),
                    title: const Text('New direct message'),
                    onTap: () {
                      Navigator.of(context).pop();
                      GoRouter.of(context).pushNamed(Routes.NEW_CHAT.name);
                    },
                  ),
                  StreamListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xxxs),
                    leading: Icon(icons.users, size: 24),
                    title: const Text('New group'),
                    onTap: () {
                      Navigator.of(context).pop();
                      GoRouter.of(context).pushNamed(Routes.NEW_GROUP_CHAT.name);
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: spacing.xs),
            Divider(height: 1, indent: spacing.md, endIndent: spacing.md, color: colorScheme.borderSubtle),
            SizedBox(height: spacing.xs),

            // ── Configuration ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.xs),
              child: StreamListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xxxs),
                leading: const Icon(Icons.tune_outlined, size: 24),
                title: const Text('Configuration'),
                trailing: Icon(Icons.chevron_right_outlined, size: 20, color: colorScheme.textTertiary),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const SampleAppConfigScreen()),
                  );
                },
              ),
            ),

            const Spacer(),

            // ── Bottom actions ──
            Divider(height: 1, indent: spacing.md, endIndent: spacing.md, color: colorScheme.borderSubtle),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: StreamListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xxxs),
                      leading: Icon(icons.leave, size: 24, color: colorScheme.accentError),
                      title: Text(
                        'Sign out',
                        style: textTheme.bodyDefault.copyWith(color: colorScheme.accentError),
                      ),
                      titleTextStyle: textTheme.bodyDefault.copyWith(color: colorScheme.accentError),
                      onTap: () async {
                        final router = GoRouter.of(context);
                        await authController.disconnect();
                        router.goNamed(Routes.CHOOSE_USER.name);
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                      color: colorScheme.textSecondary,
                    ),
                    onPressed: () {
                      final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
                      SampleAppConfig.update(context, config.copyWith(themeMode: newMode));
                    },
                  ),
                  SizedBox(width: spacing.xxs),
                ],
              ),
            ),

            SizedBox(height: spacing.md),
          ],
        ),
      ),
    );
  }
}
