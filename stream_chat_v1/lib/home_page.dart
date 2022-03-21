import 'dart:async';

import 'package:example/channel_page.dart';
import 'package:example/notifications_service.dart';
import 'package:example/routes/app_routes.dart';
import 'package:example/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MyObserver extends NavigatorObserver {
  Route? currentRoute;
  late final StreamSubscription _subscription;

  MyObserver(
    StreamChatClient client,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    _subscription = client
        .on(
      EventType.messageNew,
      EventType.notificationMessageNew,
    )
        .listen((event) {
      if (event.message?.user?.id == client.state.currentUser?.id) {
        return;
      }
      final channelId = event.channelId;
      if (currentRoute?.settings.name == Routes.CHANNEL_PAGE) {
        final args = currentRoute?.settings.arguments as ChannelPageArgs;
        if (args.channel?.id == channelId) {
          return;
        }
      }

      showLocalNotification(
        event,
        client.state.currentUser!.id,
        navigatorKey.currentState!.context,
      );
    });
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    currentRoute = route;
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    currentRoute = route;
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    currentRoute = route;
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    currentRoute = newRoute;
  }

  void dispose() {
    _subscription.cancel();
  }
}

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
  MyObserver? _observer;

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
          observers: [_observer!],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _observer?.dispose();
    _observer = MyObserver(widget.chatClient, _navigatorKey);
    super.didChangeDependencies();
  }
}
