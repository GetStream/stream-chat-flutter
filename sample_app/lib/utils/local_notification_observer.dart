import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/utils/notifications_service.dart' as pn;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class LocalNotificationObserver extends NavigatorObserver {
  LocalNotificationObserver(
    StreamChatClient client,
    GlobalKey<NavigatorState> navigatorKey,
  ) {
    _subscription = client
        .on(
      EventType.messageNew,
      EventType.notificationMessageNew,
    )
        .listen((event) {
      _handleEvent(event, client, navigatorKey);
    });
  }
  Route? currentRoute;
  late final StreamSubscription _subscription;

  void _handleEvent(Event event, StreamChatClient client,
      GlobalKey<NavigatorState> navigatorKey) {
    if (event.message?.user?.id == client.state.currentUser?.id) {
      return;
    }
    final channelId = event.cid;
    if (currentRoute?.settings.name == Routes.CHANNEL_PAGE.name) {
      final args = currentRoute!.settings.arguments! as Map<String, String>;
      if (args['cid'] == channelId) {
        return;
      }
    }

    pn.showLocalNotification(
      event,
      client.state.currentUser!.id,
      navigatorKey.currentState!.context,
    );
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
