import 'package:example/routes/app_routes.dart';
import 'package:example/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class HomePageArgs {
  final StreamChatClient chatClient;

  HomePageArgs(this.chatClient);
}

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
    required this.chatClient,
  }) : super(key: key);

  final StreamChatClient chatClient;

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: chatClient,
      child: Navigator(
        onGenerateRoute: AppRoutes.generateRoute,
        initialRoute: Routes.CHANNEL_LIST_PAGE,
      ),
    );
  }
}
