import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' hide Priority;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sample_app/firebase_options.dart';
import 'package:sample_app/pages/choose_user_page.dart';
import 'package:sample_app/pages/splash_screen.dart';
import 'package:sample_app/routes/app_routes.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/state/init_data.dart';
import 'package:sample_app/utils/app_config.dart';
import 'package:sample_app/utils/local_notification_observer.dart';
import 'package:sample_app/utils/localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'firebase_options.dart';

// Define supported notification types
const expectedNotificationTypes = [
  EventType.messageNew,
  EventType.messageUpdated,
  EventType.reactionNew,
  EventType.reactionUpdated,
];

const notificationChannelId = 'stream_GetStreamFlutterClient';
const notificationChannelName = 'Stream Notifications';
const notificationChannelDescription = 'Notifications for Stream messages';

// Define platform constants
const bool kIsIOS = bool.fromEnvironment('dart.io.is_ios');

// Initialize FlutterLocalNotificationsPlugin for background messages
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Constructs callback for background notification handling.
///
/// Will be invoked from another Isolate, that's why it's required to
/// initialize everything again:
/// - Firebase
/// - StreamChatClient
/// - StreamChatPersistenceClient
@pragma('vm:entry-point')
Future<void> _onFirebaseBackgroundMessage(RemoteMessage message) async {
  debugPrint('[onBackgroundMessage] #firebase; message: ${message.toMap()}');
  final data = message.data;
  // ensure that Push Notification was sent by Stream.
  if (data['sender'] != 'stream.chat') {
    debugPrint('[onBackgroundMessage] #firebase; not sent by Stream');
    return;
  }
  final eventType = data['type'];
  // ensure that Push Notification relates to a supported event type
  if (!expectedNotificationTypes.contains(eventType)) {
    debugPrint('[onBackgroundMessage] #firebase; unexpected type: $eventType');
    return;
  }
  // If you're going to use Firebase services in the background, make sure
  // you call `initializeApp` before using Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // read existing user info.
  String? apiKey, userId, token;
  if (!kIsWeb) {
    const secureStorage = FlutterSecureStorage();
    apiKey = await secureStorage.read(key: kStreamApiKey);
    userId = await secureStorage.read(key: kStreamUserId);
    token = await secureStorage.read(key: kStreamToken);
  }
  if (userId == null) {
    debugPrint('[onBackgroundMessage] #firebase; user not found');
    return;
  }
  if (token == null) {
    debugPrint('[onBackgroundMessage] #firebase; token not found');
    return;
  }
  final chatClient = buildStreamChatClient(apiKey ?? kDefaultStreamApiKey);
  try {
    await chatClient.connectUser(
      User(id: userId),
      token,
      // do not open WS connection
      connectWebSocket: false,
    );
    // initialize persistence with current user
    if (!chatPersistentClient.isConnected) {
      await chatPersistentClient.connect(userId);
    }

    final messageId = data['message_id'];
    if (messageId == null) {
      debugPrint('[onBackgroundMessage] #firebase; messageId not found');
      return;
    }
    final cid = data['cid'];
    if (cid == null) {
      debugPrint('[onBackgroundMessage] #firebase; cid not found');
      return;
    }
    // pre-cache the new message using client and persistence.
    final response = await chatClient.getMessage(messageId);
    await chatPersistentClient.updateMessages(cid, [response.message]);

    final title = data['title'];
    final body = data['body'];

    // Show Android notification
    if (!kIsWeb && !kIsIOS) {
      await _showAndroidNotification(
        eventType: eventType,
        cid: cid,
        messageId: messageId,
        title: message.notification?.title ?? title ?? 'Fallback title',
        body: message.notification?.body ?? body ?? 'Fallback body',
      );
    }
  } catch (e, stk) {
    debugPrint('[onBackgroundMessage] #firebase; failed: $e; $stk');
  }
}

/// Shows an Android notification for a background message
Future<void> _showAndroidNotification({
  required String eventType,
  required String cid,
  required String messageId,
  required String title,
  required String body,
}) async {
  try {
    // Create notification channel for Android
    await _createNotificationChannel();

    // Initialize the Android notification channel
    const androidNotificationDetails = AndroidNotificationDetails(
      notificationChannelId,
      notificationChannelName,
      channelDescription: notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      // Using default sound instead of custom sound resource
      // sound: RawResourceAndroidNotificationSound('notification_sound'),
      // Using default app icon instead of custom icon
      // icon: 'ic_notification',
    );

    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // Initialize the plugin with click handler
    // Use the default app icon for notifications
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'ic_notification_in_app',
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Initialize the plugin with a notification click handler
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        debugPrint(
            '[onBackgroundMessage] #firebase; notification clicked: ${response.payload}');
        // The payload contains the channel information (channelType:channelId)
        // This will be handled when the app is opened
      },
    );

    // Generate a unique notification ID
    final notificationId = (eventType + cid + messageId).hashCode;

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      notificationId, // Notification ID
      title, // Notification title
      body, // Notification body
      notificationDetails,
      payload: cid,
    );

    debugPrint(
        '[onBackgroundMessage] #firebase; android notification shown successfully: ID=$notificationId, Title="$title"');
  } catch (e) {
    debugPrint(
        '[onBackgroundMessage] #firebase; failed to show notification: $e');
  }
}

/// Creates the notification channel for Android
Future<void> _createNotificationChannel() async {
  try {
    const channel = AndroidNotificationChannel(
      notificationChannelId,
      notificationChannelName,
      description: notificationChannelDescription,
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    );

    // Create the channel
    final androidPlugin =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
      debugPrint(
          '[onBackgroundMessage] #firebase; notification channel created');
    } else {
      debugPrint(
          '[onBackgroundMessage] #firebase; failed to resolve Android plugin');
    }
  } catch (e) {
    debugPrint(
        '[onBackgroundMessage] #firebase; notification channel failed: $e');
  }
}

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
      // User logged in
      if (userId != null) {
        // Requests notification permission.
        await FirebaseMessaging.instance.requestPermission();
        // Sets callback for background messages.
        FirebaseMessaging.onBackgroundMessage(_onFirebaseBackgroundMessage);
        // Sets callback for the notification click event.
        firebaseSubscriptions.add(FirebaseMessaging.onMessageOpenedApp
            .listen(_onFirebaseMessageOpenedApp(client)));
        // Sets callback for foreground messages
        firebaseSubscriptions.add(FirebaseMessaging.onMessage
            .listen(_onFirebaseForegroundMessage(client)));
        // Sets callback for the token refresh event.
        firebaseSubscriptions.add(FirebaseMessaging.instance.onTokenRefresh
            .listen(_onFirebaseTokenRefresh(client)));

        final token = await FirebaseMessaging.instance.getToken();
        debugPrint('[onTokenInit] #firebase; token: $token');
        if (token != null) {
          // replace with your push provider, e.g., 'PushProvider.xiaomi'
          const pushProvider = PushProvider.firebase;

          // add Token to Stream
          await client.addDevice(token, pushProvider);
        }
      }
      // User logged out
      else {
        firebaseSubscriptions.cancelAll();
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          // remove token from Stream
          await client.removeDevice(token);
        }
      }
    });
  }

  /// Constructs callback for notification click event.
  OnRemoteMessage _onFirebaseMessageOpenedApp(StreamChatClient client) {
    return (message) async {
      debugPrint('[onMessageOpenedApp] #firebase; message: ${message.toMap()}');
      // This callback is getting invoked when the user clicks
      // on the notification in case if notification was shown by OS.
      final channelCid = (message.data['cid'] as String?) ?? '';
      final parts = channelCid.split(':');
      final channelType = parts[0];
      final channelId = parts[1];
      var channel = client.state.channels[channelCid];
      if (channel == null) {
        channel = client.channel(
          channelType,
          id: channelId,
        );
        await channel.watch();
      }
      // Navigates to Channel page, which is associated with the notification.
      GoRouter.of(_navigatorKey.currentContext!).pushNamed(
        Routes.CHANNEL_PAGE.name,
        pathParameters: Routes.CHANNEL_PAGE.params(channel),
      );
    };
  }

  /// Constructs callback for foreground notification handling.
  OnRemoteMessage _onFirebaseForegroundMessage(StreamChatClient client) {
    return (message) async {
      debugPrint(
          '[onForegroundMessage] #firebase; message: ${message.toMap()}');
    };
  }

  /// Constructs callback for notification refresh event.
  Future<void> Function(String) _onFirebaseTokenRefresh(
    StreamChatClient client,
  ) {
    return (token) async {
      debugPrint('[onTokenRefresh] #firebase; token: $token');
      // This callback is getting invoked when the token got refreshed.
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
        final loggingIn = state.matchedLocation == Routes.CHOOSE_USER.path ||
            state.matchedLocation == Routes.ADVANCED_OPTIONS.path;

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
