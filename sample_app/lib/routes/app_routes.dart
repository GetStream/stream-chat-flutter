import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/pages/advanced_options_page.dart';
import 'package:sample_app/pages/channel_list_page.dart';
import 'package:sample_app/pages/chat_info_screen.dart';
import 'package:sample_app/pages/choose_user_page.dart';
import 'package:sample_app/pages/group_chat_details_screen.dart';
import 'package:sample_app/pages/group_info_screen.dart';
import 'package:sample_app/pages/new_chat_screen.dart';
import 'package:sample_app/pages/new_group_chat_screen.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/state/new_group_chat_state.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

final appRoutes = [
  GoRoute(
    name: Routes.CHANNEL_LIST_PAGE.name,
    path: Routes.CHANNEL_LIST_PAGE.path,
    builder: (BuildContext context, GoRouterState state) => const ChannelListPage(),
    routes: [
      GoRoute(
        name: Routes.CHANNEL_PAGE.name,
        path: Routes.CHANNEL_PAGE.path,
        builder: (context, state) {
          final channel = _resolveChannel(context, state);
          final messageId = state.uri.queryParameters['mid'];
          final parentId = state.uri.queryParameters['pid'];

          // Thread deep-links require the parent message to already be in
          // channel state. On cold cids (e.g. notification-tap into an
          // unwatched channel) the state is null and we fall through to
          // ChannelPage; the user lands on the channel rather than the
          // thread, which is a degraded but functional UX.
          Message? parentMessage;
          if (parentId != null) {
            parentMessage = channel.state?.messages.firstWhereOrNull((it) => it.id == parentId);
          }

          return StreamChannel(
            channel: channel,
            initialMessageId: messageId,
            child: Builder(
              builder: (context) {
                return (parentMessage != null)
                    ? StreamThreadPage(parent: parentMessage)
                    : StreamChannelPage(
                        onChannelAvatarPressed: (context, channel) {
                          final isOneToOne = channel.isOneToOne;
                          final currentUserId = StreamChat.of(context).currentUser?.id;

                          final channelMembers = channel.state?.members ?? [];
                          final otherUser = isOneToOne
                              ? channelMembers.firstWhere((m) => m.userId != currentUserId).user
                              : null;

                          final router = GoRouter.of(context);

                          if (otherUser != null) {
                            router.pushNamed(
                              Routes.CHAT_INFO_SCREEN.name,
                              pathParameters: Routes.CHAT_INFO_SCREEN.params(channel),
                              extra: otherUser,
                            );
                            return;
                          }

                          router.pushNamed(
                            Routes.GROUP_INFO_SCREEN.name,
                            pathParameters: Routes.GROUP_INFO_SCREEN.params(channel),
                          );
                        },
                      );
              },
            ),
          );
        },
        routes: [
          GoRoute(
            name: Routes.CHAT_INFO_SCREEN.name,
            path: Routes.CHAT_INFO_SCREEN.path,
            builder: (BuildContext context, GoRouterState state) {
              return StreamChannel.value(
                channel: _resolveChannel(context, state),
                child: ChatInfoScreen(
                  user: state.extra as User?,
                ),
              );
            },
          ),
          GoRoute(
            name: Routes.GROUP_INFO_SCREEN.name,
            path: Routes.GROUP_INFO_SCREEN.path,
            builder: (BuildContext context, GoRouterState state) {
              return StreamChannel.value(
                channel: _resolveChannel(context, state),
                child: const GroupInfoScreen(),
              );
            },
          ),
        ],
      ),
    ],
  ),
  GoRoute(
    name: Routes.NEW_CHAT.name,
    path: Routes.NEW_CHAT.path,
    builder: (BuildContext context, GoRouterState state) {
      return const NewChatScreen();
    },
  ),
  GoRoute(
    name: Routes.NEW_GROUP_CHAT.name,
    path: Routes.NEW_GROUP_CHAT.path,
    builder: (BuildContext context, GoRouterState state) {
      return const NewGroupChatScreen();
    },
  ),
  GoRoute(
    name: Routes.NEW_GROUP_CHAT_DETAILS.name,
    path: Routes.NEW_GROUP_CHAT_DETAILS.path,
    builder: (BuildContext context, GoRouterState state) {
      final groupChatState = state.extra! as NewGroupChatState;
      return GroupChatDetailsScreen(groupChatState: groupChatState);
    },
  ),
  GoRoute(
    name: Routes.CHOOSE_USER.name,
    path: Routes.CHOOSE_USER.path,
    builder: (BuildContext context, GoRouterState state) => const ChooseUserPage(),
  ),
  GoRoute(
    name: Routes.ADVANCED_OPTIONS.name,
    path: Routes.ADVANCED_OPTIONS.path,
    builder: (BuildContext context, GoRouterState state) => const AdvancedOptionsPage(),
  ),
];

// Resolves the channel for a `:cid`-bearing route. Returns the existing
// watched instance from client state when available; otherwise returns
// an unwatched shell — `StreamChannel` will watch it on mount, which is
// what triggers the unread-anchoring / `initialMessageId` behaviour.
Channel _resolveChannel(BuildContext context, GoRouterState state) {
  final [type, id] = state.pathParameters['cid']!.split(':');
  return StreamChat.of(context).client.channel(type, id: id);
}
