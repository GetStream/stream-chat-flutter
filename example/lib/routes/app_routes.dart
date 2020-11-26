import 'routes.dart';
import 'package:flutter/material.dart';
import '../choose_user_page.dart';
import '../advanced_options_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../main.dart';
import '../group_chat_details_screen.dart';
import '../new_group_chat_screen.dart';
import '../new_chat_screen.dart';

class AppRoutes {
  /// Add entry for new route here
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.CHANNEL_LIST:
        return MaterialPageRoute(
            settings: const RouteSettings(name: Routes.CHANNEL_LIST),
            builder: (_) {
              return ChannelListPage();
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
              return StreamChannel(
                channel: args as Channel,
                child: ChannelPage(),
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
    }
  }
}
