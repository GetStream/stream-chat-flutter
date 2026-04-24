// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' hide Message;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/config/sample_app_config.dart';
import 'package:sample_app/notification/notification_service.dart';
import 'package:sample_app/pages/choose_user_page.dart';
import 'package:sample_app/pages/splash_screen.dart';
import 'package:sample_app/push/push_provider.dart';
import 'package:sample_app/push/push_token_manager.dart';
import 'package:sample_app/routes/app_routes.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/state/init_data.dart';
import 'package:sample_app/utils/app_config.dart';
import 'package:sample_app/widgets/custom_message_actions.dart';
import 'package:sample_app/widgets/location/location_attachment.dart';
import 'package:sample_app/widgets/location/location_detail_dialog.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide PushProvider;
import 'package:stream_chat_localizations/stream_chat_localizations.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.SEVERE,
);

void _sampleAppLogHandler(LogRecord record) async {
  if (kDebugMode) StreamChatClient.defaultLogHandler(record);

  // report errors to sentry.io
  if (record.error != null || record.stackTrace != null) {
    await Sentry.captureException(
      record.error,
      stackTrace: record.stackTrace,
    );
  }
}

StreamChatClient buildStreamChatClient(String apiKey) {
  late Level logLevel;
  if (kDebugMode) {
    logLevel = Level.INFO;
  } else {
    logLevel = Level.SEVERE;
  }
  return StreamChatClient(
    apiKey,
    logLevel: logLevel,
    logHandlerFunction: _sampleAppLogHandler,
    retryPolicy: RetryPolicy(
      maxRetryAttempts: 3,
      shouldRetry: (client, attempt, error) {
        return error is StreamChatNetworkError && error.isRetriable;
      },
    ),
    //baseURL: 'http://<local-ip>:3030',
    //baseWsUrl: 'ws://<local-ip>:8800',
  )..chatPersistenceClient = chatPersistentClient;
}

class StreamChatSampleApp extends StatefulWidget {
  const StreamChatSampleApp({super.key});

  @override
  State<StreamChatSampleApp> createState() => _StreamChatSampleAppState();
}

class _StreamChatSampleAppState extends State<StreamChatSampleApp>
    with SplashScreenStateMixin, TickerProviderStateMixin {
  final InitNotifier _initNotifier = InitNotifier();

  final _localNotification = FlutterLocalNotificationsPlugin();
  late final _notificationService = NotificationService(_localNotification);
  // Use Firebase on both platforms.
  //
  // On iOS we specifically avoid PushProvider.apn (raw APNs) because when
  // Stream sends directly via APNs, the payload has no FCM metadata, and
  // `firebase_messaging.onMessageOpenedApp` never fires on tap — so
  // `_onNotificationTap` never runs. Firebase bridges FCM → APNs internally
  // and embeds the metadata the plugin needs to surface the tap.
  static const _iosPushProvider = PushProvider.firebase(name: 'firebase');
  static const _androidPushProvider = PushProvider.firebase(name: 'firebase');

  PushTokenManager? _pushTokenManager;
  StreamSubscription<String?>? _userIdSubscription;

  Future<InitData> _initConnection() async {
    String? apiKey, userId, token;

    if (!kIsWeb) {
      const secureStorage = FlutterSecureStorage();
      apiKey = await secureStorage.read(key: kStreamApiKey);
      userId = await secureStorage.read(key: kStreamUserId);
      token = await secureStorage.read(key: kStreamToken);
    }
    final client = buildStreamChatClient(apiKey ?? kDefaultStreamApiKey);

    if (userId != null && token != null) {
      await client.connectUser(
        User(id: userId),
        token,
      );
    }

    final prefs = await StreamingSharedPreferences.instance;

    return InitData(client, prefs);
  }

  void _onNotificationTap(NotificationInfo info) {
    final notification = info.notification;
    debugPrint(
      '[notif-tap] type=${notification.type} state=${info.deviceState} '
      'cid=${notification.cid}',
    );

    // Only message notifications carry a channel we can navigate to.
    final cid = notification.cid;
    if (cid.isEmpty) {
      debugPrint('[notif-tap] no cid, skipping navigation');
      return;
    }

    final parts = cid.split(':');
    if (parts.length != 2) {
      debugPrint('[notif-tap] malformed cid=$cid');
      return;
    }

    final channelType = parts[0];
    final channelId = parts[1];

    final client = _initNotifier.initData?.client;
    if (client == null) {
      debugPrint('[notif-tap] client not ready yet');
      return;
    }

    unawaited(() async {
      var channel = client.state.channels[cid];
      if (channel == null) {
        channel = client.channel(channelType, id: channelId);
        await channel.watch();
      }

      final ctx = _navigatorKey.currentContext;
      if (ctx == null) {
        debugPrint('[notif-tap] navigator context not available');
        return;
      }
      debugPrint('[notif-tap] navigating to channel=$cid');
      GoRouter.of(ctx).pushNamed(
        Routes.CHANNEL_PAGE.name,
        pathParameters: Routes.CHANNEL_PAGE.params(channel),
      );
    }());
  }

  void _listenUserChanges(StreamChatClient client) {
    _userIdSubscription?.cancel();
    _userIdSubscription = client.state.currentUserStream.map((it) => it?.id).distinct().listen((userId) async {
      debugPrint('[push] currentUser changed: $userId');
      if (userId != null) {
        // User logged in — start listening for push token refreshes and
        // mirror them to Stream Chat.
        _pushTokenManager?.dispose();
        _pushTokenManager = PushTokenManager(
          client: client,
          iosPushProvider: _iosPushProvider,
          androidPushProvider: _androidPushProvider,
        )..registerDevice();
      } else {
        // User logged out — unregister device and tear down manager.
        debugPrint('[push] user logged out; unregistering device');
        await _pushTokenManager?.unregisterDevice();
        await _pushTokenManager?.dispose();
        _pushTokenManager = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _notificationService.onNotificationTap = _onNotificationTap;
    _notificationService.initialize();

    final timeOfStartMs = DateTime.now().millisecondsSinceEpoch;

    _initConnection().then(
      (initData) {
        setState(() {
          _initNotifier.initData = initData;
        });

        final now = DateTime.now().millisecondsSinceEpoch;

        if (now - timeOfStartMs > 1500) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            forwardAnimations();
          });
        } else {
          Future.delayed(const Duration(milliseconds: 1500)).then((value) {
            forwardAnimations();
          });
        }
        _listenUserChanges(initData.client);
      },
    );
  }

  @override
  void dispose() {
    _userIdSubscription?.cancel();
    _pushTokenManager?.dispose();
    _notificationService.dispose();
    _initNotifier.initData?.client.dispose();
    super.dispose();
  }

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  GoRouter? router;

  /// Sets up the router for the current chat client.
  GoRouter _setupRouter() {
    return router ??= GoRouter(
      refreshListenable: _initNotifier,
      initialLocation: Routes.CHANNEL_LIST_PAGE.path,
      navigatorKey: _navigatorKey,
      redirect: (context, state) {
        final loggedIn = _initNotifier.initData?.client.state.currentUser != null;
        final loggingIn =
            state.matchedLocation == Routes.CHOOSE_USER.path || state.matchedLocation == Routes.ADVANCED_OPTIONS.path;

        if (!loggedIn) {
          return loggingIn ? null : Routes.CHOOSE_USER.path;
        }

        // if the user is logged in but still on the login page, send them to
        // the home page
        if (loggedIn && state.matchedLocation == Routes.CHOOSE_USER.path) {
          return Routes.CHANNEL_LIST_PAGE.path;
        }

        return null;
      },
      routes: appRoutes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_initNotifier.initData != null)
          ChangeNotifierProvider.value(
            value: _initNotifier,
            builder: (context, child) => Builder(
              builder: (context) {
                context.watch<InitNotifier>(); // rebuild on change
                return SampleAppConfig(
                  preferences: _initNotifier.initData!.preferences,
                  child: Builder(
                    builder: (context) {
                      final config = context.sampleAppConfig;
                      return MaterialApp.router(
                        theme: ThemeData(
                          brightness: .light,
                          extensions: [StreamTheme.light()],
                        ),
                        darkTheme: ThemeData(
                          brightness: .dark,
                          extensions: [StreamTheme.dark()],
                        ),
                        themeMode: config.themeMode,
                        locale: config.locale,
                        supportedLocales: supportedLocales,
                        localizationsDelegates: const [
                          GlobalStreamChatLocalizations.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                        ],
                        builder: (context, child) => Directionality(
                          textDirection: config.forceRtl ? .rtl : .ltr,
                          child: StreamChat(
                            client: _initNotifier.initData!.client,
                            componentBuilders: StreamComponentBuilders(
                              extensions: streamChatComponentBuilders(
                                messageWidget: customMessageWidgetBuilder,
                              ),
                            ),
                            streamChatConfigData: config.toStreamChatConfigData(),
                            child: child,
                          ),
                        ),
                        routerConfig: _setupRouter(),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        if (!animationCompleted) buildAnimation(),
      ],
    );
  }
}

extension on SampleAppConfigData {
  /// Maps chat-relevant flags to a [StreamChatConfigurationData].
  StreamChatConfigurationData toStreamChatConfigData() {
    return StreamChatConfigurationData(
      draftMessagesEnabled: draftMessagesEnabled,
      enforceUniqueReactions: enforceUniqueReactions,
      reactionType: reactionType,
      reactionPosition: reactionPosition,
      attachmentBuilders: [
        if (enableLocationSharing)
          LocationAttachmentBuilder(
            onAttachmentTap: (context, location) {
              showLocationDetailDialog(context: context, location: location);
            },
          ),
      ],
    );
  }
}
