import 'dart:async';

import 'package:example/pages/choose_user_page.dart';
import 'package:example/pages/home_page.dart';
import 'package:example/utils/localizations.dart';
import 'package:example/pages/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'routes/app_routes.dart';
import 'routes/routes.dart';

final chatPersistentClient = StreamChatPersistenceClient(
  logLevel: Level.SEVERE,
  connectionMode: ConnectionMode.regular,
);

void sampleAppLogHandler(LogRecord record) async {
  if (kDebugMode) StreamChatClient.defaultLogHandler(record);

  // report errors to setnry.io
  if (record.error != null || record.stackTrace != null) {
    await Sentry.captureException(
      record.error,
      stackTrace: record.stackTrace,
    );
  }
}

StreamChatClient buildStreamChatClient(
  String apiKey, {
  Level logLevel = Level.INFO,
}) {
  return StreamChatClient(
    apiKey,
    logLevel: logLevel,
    logHandlerFunction: sampleAppLogHandler,
  )..chatPersistenceClient = chatPersistentClient;
}

class StreamChatSampleApp extends StatefulWidget {
  const StreamChatSampleApp({super.key});

  @override
  State<StreamChatSampleApp> createState() => _StreamChatSampleAppState();
}

class _StreamChatSampleAppState extends State<StreamChatSampleApp>
    with SplashScreenStateMixin, TickerProviderStateMixin {
  InitData? _initData;

  Future<InitData> _initConnection() async {
    String? apiKey, userId, token;

    if (!kIsWeb) {
      const secureStorage = FlutterSecureStorage();
      apiKey = await secureStorage.read(key: kStreamApiKey);
      userId = await secureStorage.read(key: kStreamUserId);
      token = await secureStorage.read(key: kStreamToken);
    }

    final client = buildStreamChatClient(apiKey ?? kStreamApiKey);

    if (userId != null && token != null) {
      await client.connectUser(
        User(id: userId),
        token,
      );
    }

    final prefs = await StreamingSharedPreferences.instance;

    return InitData(client, prefs);
  }

  @override
  void initState() {
    final timeOfStartMs = DateTime.now().millisecondsSinceEpoch;

    _initConnection().then(
      (initData) {
        setState(() {
          _initData = initData;
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
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_initData != null)
          PreferenceBuilder<int>(
            preference: _initData!.preferences.getInt(
              'theme',
              defaultValue: 0,
            ),
            builder: (context, snapshot) => MaterialApp(
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: {
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
              builder: (context, child) => StreamChatConfiguration(
                data: StreamChatConfigurationData(),
                child: StreamChatTheme(
                  data: StreamChatThemeData(
                    brightness: Theme.of(context).brightness,
                  ),
                  child: child!,
                ),
              ),
              onGenerateRoute: AppRoutes.generateRoute,
              onGenerateInitialRoutes: (initialRouteName) {
                if (initialRouteName == Routes.HOME) {
                  return [
                    AppRoutes.generateRoute(
                      RouteSettings(
                        name: Routes.HOME,
                        arguments: HomePageArgs(_initData!.client),
                      ),
                    )!
                  ];
                }
                return [
                  AppRoutes.generateRoute(
                    const RouteSettings(
                      name: Routes.CHOOSE_USER,
                    ),
                  )!
                ];
              },
              initialRoute: _initData!.client.state.currentUser == null
                  ? Routes.CHOOSE_USER
                  : Routes.HOME,
            ),
          ),
        if (!animationCompleted) buildAnimation(),
      ],
    );
  }
}

class InitData {
  final StreamChatClient client;
  final StreamingSharedPreferences preferences;

  InitData(this.client, this.preferences);
}
