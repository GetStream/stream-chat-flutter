import 'dart:async';

import 'package:example/choose_user_page.dart';
import 'package:example/home_page.dart';
import 'package:example/localizations.dart';
import 'package:example/splash_screen.dart';
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

  // report errors to sentry
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

void main() async {
  const sentryDsn =
      'https://6381ef88de4140db8f5e25ab37e0f08c@o1213503.ingest.sentry.io/6352870';

  /// Captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      // In development mode, simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode, report to the application zone to report to sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  Future<void> _reportError(dynamic error, StackTrace stackTrace) async {
    // Print the exception to the console.
    if (kDebugMode) {
      // Print the full stacktrace in debug mode.
      print(stackTrace);
      return;
    } else {
      // Send the Exception and Stacktrace to sentry in Production mode.
      await Sentry.captureException(error, stackTrace: stackTrace);
    }
  }

  runZonedGuarded(
    () async {
      await SentryFlutter.init(
        (options) => options.dsn = sentryDsn,
      );
      runApp(MyApp());
    },
    _reportError,
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with SplashScreenStateMixin, TickerProviderStateMixin {
  InitData? _initData;

  Future<InitData> _initConnection() async {
    String? apiKey, userId, token;

    if (!kIsWeb) {
      final secureStorage = FlutterSecureStorage();
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
          Future.delayed(Duration(milliseconds: 1500)).then((value) {
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
                    RouteSettings(
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
