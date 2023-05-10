import 'dart:async';

import 'package:example/pages/choose_user_page.dart';
import 'package:example/pages/splash_screen.dart';
import 'package:example/routes/app_routes.dart';
import 'package:example/routes/routes.dart';
import 'package:example/state/init_data.dart';
import 'package:example/utils/app_config.dart';
import 'package:example/utils/local_notification_observer.dart';
import 'package:example/utils/localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _onFirebaseBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final data = message.data;
  if (data['type'] != 'message.new') {
    return;
  }
  String? apiKey, userId, token;
  if (!kIsWeb) {
    const secureStorage = FlutterSecureStorage();
    apiKey = await secureStorage.read(key: kStreamApiKey);
    userId = await secureStorage.read(key: kStreamUserId);
    token = await secureStorage.read(key: kStreamToken);
  }
  if (userId == null || token == null) {
    return;
  }
  final client = buildStreamChatClient(apiKey ?? kDefaultStreamApiKey);
  final persistenceClient = StreamChatPersistenceClient();
  await persistenceClient.connect(userId);

  await client.connectUser(
    User(id: userId),
    token,
    connectWebSocket: false,
  );

  final messageId = data['id'];
  final cid = data['cid'];
  final response = await client.getMessage(messageId);
  await persistenceClient.updateMessages(cid, [response.message]);
}

final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.SEVERE,
  connectionMode: ConnectionMode.regular,
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

  final firebaseSubscriptions = <StreamSubscription<dynamic>>[];
  StreamSubscription<String?>? userIdSubscription;

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

  Future<void> _initFirebaseMessaging(StreamChatClient client) async {
    userIdSubscription?.cancel();
    userIdSubscription = client.state.currentUserStream
        .map((it) => it?.id)
        .distinct()
        .listen((userId) async {
      if (userId != null) {
        await FirebaseMessaging.instance.requestPermission();
        FirebaseMessaging.onBackgroundMessage(_onFirebaseBackgroundMessage);
        firebaseSubscriptions.add(FirebaseMessaging.onMessageOpenedApp
            .listen(_onFirebaseMessageOpenedApp(client)));
        firebaseSubscriptions.add(FirebaseMessaging.instance.onTokenRefresh
            .listen(_onFirebaseTokenRefresh(client)));
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await client.addDevice(token, PushProvider.firebase);
        }
      } else {
        firebaseSubscriptions.cancelAll();
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await client.removeDevice(token);
        }
      }
    });
  }

  OnRemoteMessage _onFirebaseMessageOpenedApp(StreamChatClient client) {
    return (message) async {
      final channelType = (message.data['channel_type'] as String?) ?? '';
      final channelId = (message.data['channel_id'] as String?) ?? '';
      final channelCid = (message.data['cid'] as String?) ?? '';
      var channel = client.state.channels[channelCid];
      if (channel == null) {
        channel = client.channel(
          channelType,
          id: channelId,
        );
        await channel.watch();
      }
      GoRouter.of(_navigatorKey.currentContext!).pushNamed(
        Routes.CHANNEL_PAGE.name,
        params: Routes.CHANNEL_PAGE.params(channel),
      );
    };
  }

  Future<void> Function(String) _onFirebaseTokenRefresh(
    StreamChatClient client,
  ) {
    return (token) async {
      await client.addDevice(token, PushProvider.firebase);
    };
  }

  @override
  void initState() {
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
        _initFirebaseMessaging(initData.client);
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    userIdSubscription?.cancel();
    firebaseSubscriptions.cancelAll();
  }

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  LocalNotificationObserver? localNotificationObserver;

  /// Conditionally sets up the router and adding an observer for the
  /// current chat client.
  GoRouter _setupRouter() {
    if (localNotificationObserver != null) {
      localNotificationObserver!.dispose();
    }
    localNotificationObserver = LocalNotificationObserver(
        _initNotifier.initData!.client, _navigatorKey);

    return GoRouter(
      refreshListenable: _initNotifier,
      initialLocation: Routes.CHANNEL_LIST_PAGE.path,
      navigatorKey: _navigatorKey,
      observers: [localNotificationObserver!],
      redirect: (context, state) {
        final loggedIn =
            _initNotifier.initData?.client.state.currentUser != null;
        final loggingIn = state.subloc == Routes.CHOOSE_USER.path ||
            state.subloc == Routes.ADVANCED_OPTIONS.path;

        if (!loggedIn) {
          return loggingIn ? null : Routes.CHOOSE_USER.path;
        }

        // if the user is logged in but still on the login page, send them to
        // the home page
        if (loggedIn && state.subloc == Routes.CHOOSE_USER.path) {
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
                return PreferenceBuilder<int>(
                  preference: _initNotifier.initData!.preferences.getInt(
                    'theme',
                    defaultValue: 0,
                  ),
                  builder: (context, snapshot) => MaterialApp.router(
                    theme: ThemeData.light(),
                    darkTheme: ThemeData.dark(),
                    themeMode: const {
                      -1: ThemeMode.dark,
                      0: ThemeMode.system,
                      1: ThemeMode.light,
                    }[snapshot],
                    supportedLocales: const [
                      Locale('en'),
                      Locale('it'),
                    ],
                    localizationsDelegates: const [
                      AppLocalizationsDelegate(),
                      GlobalStreamChatLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    builder: (context, child) => StreamChat(
                      client: _initNotifier.initData!.client,
                      child: child,
                    ),
                    routerConfig: _setupRouter(),
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

typedef OnRemoteMessage = Future<void> Function(RemoteMessage);

extension on List<StreamSubscription> {
  void cancelAll() {
    for (final subscription in this) {
      unawaited(subscription.cancel());
    }
    clear();
  }
}
