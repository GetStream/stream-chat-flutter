import 'package:example/routes/app_routes.dart';
import 'package:example/routes/routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class HomePageArgs {
  final StreamChatClient chatClient;

  HomePageArgs(this.chatClient);
}

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
    required this.chatClient,
  }) : super(key: key);

  final StreamChatClient chatClient;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: widget.chatClient,
      child: WillPopScope(
        onWillPop: () async {
          final canPop = await _navigatorKey.currentState?.maybePop() ?? false;
          return !canPop;
        },
        child: Navigator(
          key: _navigatorKey,
          onGenerateRoute: AppRoutes.generateRoute,
          initialRoute: Routes.CHANNEL_LIST_PAGE,
        ),
      ),
    );
  }
}
