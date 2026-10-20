// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' hide Message;
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart' show ShadTheme;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'auth/auth_controller.dart';
import 'config/sample_app_config.dart';
import 'fluent/fluent_component_builders.dart';
import 'fluent/fluent_stream_theme.dart';
import 'liquid_glass/liquid_glass_component_builders.dart';
import 'liquid_glass/liquid_glass_stream_theme.dart';
import 'notification/notification_service.dart';
import 'pages/splash_screen.dart';
import 'routes/app_routes.dart';
import 'routes/routes.dart';
import 'shadcn/shadcn_component_builders.dart';
import 'shadcn/shadcn_stream_theme.dart';
import 'widgets/custom_message_actions.dart';
import 'widgets/location/location_attachment.dart';
import 'widgets/location/location_aware_message_composer.dart';
import 'widgets/location/location_detail_dialog.dart';
import 'xp/xp_component_builders.dart';
import 'xp/xp_stream_theme.dart';
import 'yaru/yaru_component_builders.dart';
import 'yaru/yaru_stream_theme.dart';

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
    if (!isE2eTestRun) _notificationService.initialize();

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
                final surfaceStyle = config.surfaceStyle;

                final design = config.design;
                final chatExtensions = streamChatComponentBuilders(
                  messageItem: customMessageItemBuilder,
                  messageComposer: locationAwareMessageComposer,
                  messageComposerInput: design == .liquidGlass ? liquidGlassComposerInput : null,
                );
                final componentBuilders = switch (design) {
                  .windowsXp => xpComponentBuilders(extensions: chatExtensions),
                  .liquidGlass => liquidGlassComponentBuilders(extensions: chatExtensions),
                  .yaru => yaruComponentBuilders(extensions: chatExtensions),
                  .fluent => fluentComponentBuilders(extensions: chatExtensions),
                  .shadcn => shadcnComponentBuilders(extensions: chatExtensions),
                  _ => StreamComponentBuilders(extensions: chatExtensions),
                };

                ThemeData themeFor(Brightness brightness, ColorScheme? dynamicColor) => switch (design) {
                  .windowsXp => xpMaterialTheme(surfaceStyle: surfaceStyle),
                  .liquidGlass => liquidGlassMaterialTheme(brightness: brightness, surfaceStyle: surfaceStyle),
                  .yaru => yaruMaterialTheme(brightness: brightness, surfaceStyle: surfaceStyle),
                  .fluent => fluentMaterialTheme(brightness: brightness, surfaceStyle: surfaceStyle),
                  .shadcn => shadcnMaterialTheme(brightness: brightness, surfaceStyle: surfaceStyle),
                  _ => createTheme(
                    dynamicColor: config.enableDynamicColor ? dynamicColor : null,
                    brightness: brightness,
                    surfaceStyle: surfaceStyle,
                  ),
                };

                // Design-specific scopes that must sit below MaterialApp, so
                // they can read the resolved theme.
                Widget wrapDesign(Widget child) => switch (design) {
                  .fluent => Builder(
                    builder: (context) => fluent.FluentTheme(
                      data: fluentThemeData(Theme.of(context).brightness),
                      child: child,
                    ),
                  ),
                  .shadcn => Builder(
                    builder: (context) => ShadTheme(
                      data: shadcnThemeData(Theme.of(context).brightness),
                      child: child,
                    ),
                  ),
                  _ => child,
                };

                return DynamicColorBuilder(
                  builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
                    return MaterialApp.router(
                      theme: themeFor(Brightness.light, lightDynamic),
                      darkTheme: themeFor(Brightness.dark, darkDynamic),
                      // XP has no dark mode.
                      themeMode: design == .windowsXp ? ThemeMode.light : config.themeMode,
                      locale: config.locale,
                      supportedLocales: supportedLocales,
                      localizationsDelegates: const [
                        GlobalStreamChatLocalizations.delegate,
                        fluent.FluentLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                      ],
                      builder: (context, child) => wrapDesign(
                        _ComponentSurfaceStyleOverrides(
                          config: config,
                          child: ListenableBuilder(
                            listenable: authController,
                            builder: (context, cachedChild) {
                              final wrapped = Directionality(
                                textDirection: config.forceRtl ? .rtl : .ltr,
                                // Above the router so any screen — and the
                                // dialogs it pushes — can fire snackbars via
                                // `StreamSnackbarMessenger.of(context)`. Inside
                                // the Directionality, which its Stack needs.
                                child: StreamSnackbarScope(
                                  child: cachedChild ?? const SizedBox.shrink(),
                                ),
                              );

                              // StreamChat stays mounted as long as a client
                              // exists so `StreamChat.of(context)` remains
                              // valid across logout transitions.
                              final client = authController.client;
                              if (client != null) {
                                return StreamChat(
                                  client: client,
                                  // Null in production → the SDK uses the real
                                  // connectivity monitor; set only by e2e tests.
                                  connectivityStream: authController.debugConnectivityStream,
                                  componentBuilders: componentBuilders,
                                  themeData: config.toStreamChatThemeData(),
                                  configData: config.toStreamChatConfigurationData(),
                                  child: wrapped,
                                );
                              }

                              return StreamComponentFactory(
                                builders: componentBuilders,
                                child: StreamChatTheme(
                                  data: StreamChatThemeData(),
                                  child: wrapped,
                                ),
                              );
                            },
                            child: child,
                          ),
                        ),
                      ),
                      routerConfig: _setupRouter(),
                    );
                  },
                );
              },
            ),
          ),
        if (!animationCompleted) buildAnimation(),
      ],
    );
  }

  ThemeData createTheme({
    required ColorScheme? dynamicColor,
    required Brightness brightness,
    required StreamSurfaceStyle surfaceStyle,
  }) {
    return ThemeData(
      brightness: brightness,
      extensions: [
        StreamTheme(
          colorScheme: dynamicColor == null
              ? null
              : .fromSeed(
                  brand: dynamicColor.primary,
                  brightness: brightness,
                ),
          brightness: brightness,
          surfaceStyle: surfaceStyle,
        ),
      ],
    );
  }
}

extension on SampleAppConfigData {
  /// Maps the per-header overrides onto the SDK's own header themes.
  ///
  /// Deliberately a different channel from [_ComponentSurfaceStyleOverrides]:
  /// these themes live on [StreamChatThemeData], which the pages read to decide
  /// the scaffold's inset, so both halves have to agree.
  StreamChatThemeData? toStreamChatThemeData() {
    final channelHeader = channelHeaderSurfaceStyle;
    final threadHeader = threadHeaderSurfaceStyle;
    if (channelHeader == null && threadHeader == null) return null;

    return StreamChatThemeData(
      channelHeaderTheme: switch (channelHeader) {
        final surfaceStyle? => StreamAppBarThemeData(
          style: .new(surfaceStyle: surfaceStyle),
        ),
        _ => null,
      },
      threadHeaderTheme: switch (threadHeader) {
        final surfaceStyle? => StreamAppBarThemeData(
          style: .new(surfaceStyle: surfaceStyle),
        ),
        _ => null,
      },
    );
  }

  /// Maps chat-relevant flags to a [StreamChatConfigurationData].
  StreamChatConfigurationData toStreamChatConfigurationData() {
    return StreamChatConfigurationData(
      draftMessagesEnabled: draftMessagesEnabled,
      enforceUniqueReactions: enforceUniqueReactions,
      reactionType: reactionType,
      reactionPosition: reactionPosition,
      messageTranslation: StreamMessageTranslationConfiguration(
        enabled: enableMessageTranslation,
        annotationEnabled: enableMessageTranslation,
      ),
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

// Applies the per-component surface style overrides from the sample app config,
// so each chrome component can be toggled independently of the app-wide style.
//
// A null override leaves that component unwrapped, falling back to the ambient
// StreamTheme.surfaceStyle.
class _ComponentSurfaceStyleOverrides extends StatelessWidget {
  const _ComponentSurfaceStyleOverrides({
    required this.config,
    required this.child,
  });

  final SampleAppConfigData config;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var scoped = child;

    if (config.appBarSurfaceStyle case final surfaceStyle?) {
      scoped = StreamAppBarTheme(
        data: .new(style: .new(surfaceStyle: surfaceStyle)),
        child: scoped,
      );
    }

    if (config.bottomAppBarSurfaceStyle case final surfaceStyle?) {
      scoped = StreamBottomAppBarTheme(
        data: .new(style: .new(surfaceStyle: surfaceStyle)),
        child: scoped,
      );
    }

    if (config.bottomNavBarSurfaceStyle case final surfaceStyle?) {
      scoped = StreamBottomNavBarTheme(
        data: .new(style: .new(surfaceStyle: surfaceStyle)),
        child: scoped,
      );
    }

    if (config.composerSurfaceStyle case final surfaceStyle?) {
      scoped = StreamMessageComposerTheme(
        data: .new(surfaceStyle: surfaceStyle),
        child: scoped,
      );
    }

    return scoped;
  }
}
