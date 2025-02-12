import 'package:collection/collection.dart';
import 'package:sample_app/pages/advanced_options_page.dart';
import 'package:sample_app/pages/channel_list_page.dart';
import 'package:sample_app/pages/channel_page.dart';
import 'package:sample_app/pages/chat_info_screen.dart';
import 'package:sample_app/pages/group_chat_details_screen.dart';
import 'package:sample_app/pages/group_info_screen.dart';
import 'package:sample_app/pages/new_chat_screen.dart';
import 'package:sample_app/pages/new_group_chat_screen.dart';
import 'package:sample_app/pages/thread_page.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/state/new_group_chat_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../pages/choose_user_page.dart';

final appRoutes = [
  GoRoute(
    name: Routes.CHANNEL_LIST_PAGE.name,
    path: Routes.CHANNEL_LIST_PAGE.path,
    builder: (BuildContext context, GoRouterState state) =>
        const ChannelListPage(),
    routes: [
      GoRoute(
        name: Routes.CHANNEL_PAGE.name,
        path: Routes.CHANNEL_PAGE.path,
        builder: (context, state) {
          final channel = StreamChat.of(context)
              .client
              .state
              .channels[state.pathParameters['cid']];
          final messageId = state.uri.queryParameters['mid'];
          final parentId = state.uri.queryParameters['pid'];

          Message? parentMessage;
          if (parentId != null) {
            parentMessage = channel?.state!.messages
                .firstWhereOrNull((it) => it.id == parentId);
          }

          return StreamChannel(
            channel: channel!,
            initialMessageId: messageId,
            child: Builder(
              builder: (context) {
                return (parentMessage != null)
                    ? ThreadPage(parent: parentMessage)
                    : ChannelPage(
                        highlightInitialMessage: messageId != null,
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
              final channel = StreamChat.of(context)
                  .client
                  .state
                  .channels[state.pathParameters['cid']];
              return StreamChannel(
                channel: channel!,
                child: ChatInfoScreen(
                  user: state.extra as User?,
                  messageTheme: StreamChatTheme.of(context).ownMessageTheme,
                ),
              );
            },
          ),
          GoRoute(
            name: Routes.GROUP_INFO_SCREEN.name,
            path: Routes.GROUP_INFO_SCREEN.path,
            builder: (BuildContext context, GoRouterState state) {
              final channel = StreamChat.of(context)
                  .client
                  .state
                  .channels[state.pathParameters['cid']];
              return StreamChannel(
                channel: channel!,
                child: GroupInfoScreen(
                  messageTheme: StreamChatTheme.of(context).ownMessageTheme,
                ),
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
      final groupChatState = state.extra as NewGroupChatState;
      return GroupChatDetailsScreen(groupChatState: groupChatState);
    },
  ),
  GoRoute(
    name: Routes.CHOOSE_USER.name,
    path: Routes.CHOOSE_USER.path,
    builder: (BuildContext context, GoRouterState state) =>
        const ChooseUserPage(),
  ),
  GoRoute(
    name: Routes.ADVANCED_OPTIONS.name,
    path: Routes.ADVANCED_OPTIONS.path,
    builder: (BuildContext context, GoRouterState state) =>
        const AdvancedOptionsPage(),
  ),
];
