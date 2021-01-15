import 'routes.dart';
import 'package:flutter/material.dart';
import '../choose_user_page.dart';
import '../advanced_options_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../main.dart';
import '../group_chat_details_screen.dart';
import '../new_group_chat_screen.dart';
import '../new_chat_screen.dart';
import '../chat_info_screen.dart';
import '../group_info_screen.dart';

class AppRoutes {
  /// Add entry for new route here
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.HOME:
        return MaterialPageRoute(
            settings: const RouteSettings(name: Routes.HOME),
            builder: (_) {
              return HomePage();
            });
      case Routes.CHOOSE_USER:
        return MaterialPageRoute(
            settings: const RouteSettings(name: Routes.CHOOSE_USER),
            builder: (_) {
              return ChooseUserPage();
            });
      case Routes.ADVANCED_OPTIONS:
        return MaterialPageRoute(
          settings: const RouteSettings(name: Routes.ADVANCED_OPTIONS),
          builder: (_) => AdvancedOptionsPage(),
        );
      case Routes.CHANNEL_PAGE:
        return MaterialPageRoute(
            settings: const RouteSettings(name: Routes.CHANNEL_PAGE),
            builder: (_) {
              final arg = args as ChannelPageArgs;
              return StreamChannel(
                channel: arg.channel,
                initialMessageId: arg.initialMessage?.id,
                child: ChannelPage(
                  highlightInitialMessage: arg.initialMessage != null,
                ),
              );
            });
      case Routes.NEW_CHAT:
        return MaterialPageRoute(
            settings: const RouteSettings(name: Routes.NEW_CHAT),
            builder: (_) {
              return NewChatScreen();
            });
      case Routes.NEW_GROUP_CHAT:
        return MaterialPageRoute(
            settings: const RouteSettings(name: Routes.NEW_GROUP_CHAT),
            builder: (_) {
              return NewGroupChatScreen();
            });
      case Routes.NEW_GROUP_CHAT_DETAILS:
        return MaterialPageRoute(
            settings: const RouteSettings(name: Routes.NEW_GROUP_CHAT_DETAILS),
            builder: (_) {
              return GroupChatDetailsScreen(
                selectedUsers: args,
              );
            });
      case Routes.CHAT_INFO_SCREEN:
        return MaterialPageRoute(
            settings: const RouteSettings(name: Routes.CHAT_INFO_SCREEN),
            builder: (_) {
              return ChatInfoScreen(
                user: args,
              );
            });
      case Routes.GROUP_INFO_SCREEN:
        return MaterialPageRoute(
            settings: const RouteSettings(name: Routes.GROUP_INFO_SCREEN),
            builder: (_) {
              return GroupInfoScreen();
            });
      // Default case, should not reach here.
      default:
        return null;
    }
  }
}
