// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' hide Message;
import 'package:go_router/go_router.dart';
import 'package:sample_app/auth/auth_controller.dart';
import 'package:sample_app/config/sample_app_config.dart';
import 'package:sample_app/notification/notification_service.dart';
import 'package:sample_app/pages/splash_screen.dart';
import 'package:sample_app/routes/app_routes.dart';
import 'package:sample_app/routes/routes.dart';
import 'package:sample_app/widgets/custom_message_actions.dart';
import 'package:sample_app/widgets/location/location_attachment.dart';
import 'package:sample_app/widgets/location/location_detail_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

/// Root widget of the sample app: boots prefs + notifications, runs
/// the router, and owns the [StreamChat] ancestor.
///
/// [StreamChat] stays mounted whenever [AuthController.client] is
/// non-null so auth-gated routes keep their ancestor across
/// logout/login transitions. Before the first connect, the login
/// screens run under a plain [StreamChatTheme].
class StreamChatSampleApp extends StatefulWidget {
  const StreamChatSampleApp({super.key});

  @override
  State<StreamChatSampleApp> createState() => _StreamChatSampleAppState();
}

class _StreamChatSampleAppState extends State<StreamChatSampleApp>
    with SplashScreenStateMixin, TickerProviderStateMixin {
  final _localNotification = FlutterLocalNotificationsPlugin();
  late final _notificationService = NotificationService(_localNotification);

  StreamingSharedPreferences? _preferences;

  Future<void> _bootstrap() async {
    final results = await Future.wait<Object>([
      StreamingSharedPreferences.instance,
      authController.tryAutoConnect().then((_) => Object()),
    ]);
    _preferences = results[0] as StreamingSharedPreferences;
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

    if (authController.value is! Authenticated) {
      debugPrint('[notif-tap] not authenticated, cannot navigate');
      return;
    }
    final client = authController.client;
    if (client == null) {
      debugPrint('[notif-tap] no active client, cannot navigate');
      return;
    }

    unawaited(() async {
      final channel = client.channel(channelType, id: channelId);

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

  @override
  void initState() {
    super.initState();
    _notificationService.onNotificationTap = _onNotificationTap;
    _notificationService.initialize();

    final timeOfStartMs = DateTime.now().millisecondsSinceEpoch;

    _bootstrap().then((_) {
      if (!mounted) return;
      setState(() {}); // preferences are now loaded; rebuild to show the app

      final now = DateTime.now().millisecondsSinceEpoch;
      if (now - timeOfStartMs > 1500) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          forwardAnimations();
        });
      } else {
        Future.delayed(const Duration(milliseconds: 1500)).then((_) {
          forwardAnimations();
        });
      }
    });
  }

  @override
  void dispose() {
    _notificationService.dispose();
    super.dispose();
  }

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  GoRouter? router;

  /// Sets up the router for the current chat client.
  GoRouter _setupRouter() {
    return router ??= GoRouter(
      refreshListenable: authController,
      initialLocation: Routes.CHANNEL_LIST_PAGE.path,
      navigatorKey: _navigatorKey,
      redirect: (context, state) {
        final authed = authController.value is Authenticated;
        final loggingIn =
            state.matchedLocation == Routes.CHOOSE_USER.path || state.matchedLocation == Routes.ADVANCED_OPTIONS.path;

        if (!authed) {
          return loggingIn ? null : Routes.CHOOSE_USER.path;
        }

        // if the user is logged in but still on the login page, send them to
        // the home page
        if (authed && state.matchedLocation == Routes.CHOOSE_USER.path) {
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
        if (_preferences != null)
          SampleAppConfig(
            preferences: _preferences!,
            child: Builder(
              builder: (context) {
                final config = context.sampleAppConfig;

                StreamAppStyle appStyle() => switch (config.appStyle) {
                  SampleAppStyle.regular => .regular,
                  SampleAppStyle.floating => .floating,
                };

                ThemeData theme(Brightness brightness) => ThemeData(
                  brightness: brightness,
                  extensions: [
                    StreamTheme(
                      brightness: brightness,
                      appStyle: appStyle(),
                    ),
                  ],
                );

                return MaterialApp.router(
                  theme: theme(.light),
                  darkTheme: theme(.dark),
                  themeMode: config.themeMode,
                  locale: config.locale,
                  supportedLocales: supportedLocales,
                  localizationsDelegates: const [
                    GlobalStreamChatLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  builder: (context, child) {
                    return ListenableBuilder(
                      listenable: authController,
                      builder: (context, cachedChild) {
                        final wrapped = Directionality(
                          textDirection: config.forceRtl ? .rtl : .ltr,
                          child: cachedChild ?? const SizedBox.shrink(),
                        );

                        // StreamChat stays mounted as long as a client
                        // exists so `StreamChat.of(context)` remains
                        // valid across logout transitions.
                        final client = authController.client;
                        if (client != null) {
                          return StreamChat(
                            client: client,
                            componentBuilders: StreamComponentBuilders(
                              extensions: streamChatComponentBuilders(
                                messageItem: customMessageItemBuilder,
                              ),
                            ),
                            configData: config.toStreamChatConfigurationData(),
                            child: wrapped,
                          );
                        }

                        return StreamChatTheme(
                          data: StreamChatThemeData(),
                          child: wrapped,
                        );
                      },
                      child: child,
                    );
                  },
                  routerConfig: _setupRouter(),
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
  StreamChatConfigurationData toStreamChatConfigurationData() {
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
      messageListViewConfiguration: const StreamMessageListViewConfiguration(
        highlightInitialMessage: true,
        swipeToReply: true,
      ),
    );
  }
}
