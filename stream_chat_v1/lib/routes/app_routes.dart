import 'package:collection/collection.dart';
import 'package:example/channel_list_page.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../advanced_options_page.dart';
import '../channel_page.dart';
import '../chat_info_screen.dart';
import '../choose_user_page.dart';
import '../group_chat_details_screen.dart';
import '../group_info_screen.dart';
import '../home_page.dart';
import '../main.dart';
import '../new_chat_screen.dart';
import '../new_group_chat_screen.dart';
import '../thread_page.dart';
import 'routes.dart';

class AppRoutes {
  /// Add entry for new route here
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.APP:
        return MaterialPageRoute(
            settings: RouteSettings(arguments: args, name: Routes.APP),
            builder: (_) {
              return MyApp();
            });
      case Routes.HOME:
        return MaterialPageRoute(
            settings: RouteSettings(arguments: args, name: Routes.HOME),
            builder: (_) {
              final homePageArgs = args as HomePageArgs;
              return HomePage(
                chatClient: homePageArgs.chatClient,
              );
            });
      case Routes.CHOOSE_USER:
        return MaterialPageRoute(
            settings: RouteSettings(arguments: args, name: Routes.CHOOSE_USER),
            builder: (_) {
              return ChooseUserPage();
            });
      case Routes.ADVANCED_OPTIONS:
        return MaterialPageRoute(
          settings:
              RouteSettings(arguments: args, name: Routes.ADVANCED_OPTIONS),
          builder: (_) => AdvancedOptionsPage(),
        );
      case Routes.CHANNEL_PAGE:
        return MaterialPageRoute(
          settings: RouteSettings(arguments: args, name: Routes.CHANNEL_PAGE),
          builder: (context) {
            final channelPageArgs = args as ChannelPageArgs;
            final initialMessage = channelPageArgs.initialMessage;

            return StreamChannel(
              channel: channelPageArgs.channel!,
              initialMessageId: initialMessage?.id,
              child: Builder(
                builder: (context) {
                  final parentId = initialMessage?.parentId;
                  Message? parentMessage;
                  if (parentId != null) {
                    final channel = StreamChannel.of(context).channel;
                    parentMessage = channel.state!.messages
                        .firstWhereOrNull((it) => it.id == parentId);
                  }
                  if (parentMessage != null) {
                    return ThreadPage(parent: parentMessage);
                  }
                  return ChannelPage(
                    highlightInitialMessage:
                        channelPageArgs.initialMessage != null,
                  );
                },
              ),
            );
          },
        );
      case Routes.NEW_CHAT:
        return MaterialPageRoute(
            settings: RouteSettings(arguments: args, name: Routes.NEW_CHAT),
            builder: (_) {
              return NewChatScreen();
            });
      case Routes.NEW_GROUP_CHAT:
        return MaterialPageRoute(
            settings:
                RouteSettings(arguments: args, name: Routes.NEW_GROUP_CHAT),
            builder: (_) {
              return NewGroupChatScreen();
            });
      case Routes.NEW_GROUP_CHAT_DETAILS:
        return MaterialPageRoute(
            settings: RouteSettings(
                arguments: args, name: Routes.NEW_GROUP_CHAT_DETAILS),
            builder: (_) {
              return GroupChatDetailsScreen(
                selectedUsers: args as List<User>?,
              );
            });
      case Routes.CHAT_INFO_SCREEN:
        return MaterialPageRoute(
            settings:
                RouteSettings(arguments: args, name: Routes.CHAT_INFO_SCREEN),
            builder: (context) {
              return ChatInfoScreen(
                user: args as User?,
                messageTheme: StreamChatTheme.of(context).ownMessageTheme,
              );
            });
      case Routes.GROUP_INFO_SCREEN:
        return MaterialPageRoute(
            settings:
                RouteSettings(arguments: args, name: Routes.GROUP_INFO_SCREEN),
            builder: (context) {
              return GroupInfoScreen(
                messageTheme: StreamChatTheme.of(context).ownMessageTheme,
              );
            });
      case Routes.CHANNEL_LIST_PAGE:
        return MaterialPageRoute(
            settings:
                RouteSettings(arguments: args, name: Routes.CHANNEL_LIST_PAGE),
            builder: (context) {
              return ChannelListPage();
            });
      // Default case, should not reach here.
      default:
        return null;
    }
  }
}
