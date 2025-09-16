import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/typedef.dart';

/// Widget used to provide information about the chat to the widget tree.
/// This Widget is used to react to life cycle changes and system updates.
/// When the app goes into the background, the websocket connection is kept
/// alive for two minutes before being terminated.
///
/// Conversely, when app is resumed or restarted, a new connection is initiated.
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   final StreamChatClient client;
///
///   MyApp(this.client);
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: Container(
///         child: StreamChatCore(
///           client: client,
///           child: ChannelListPage(),
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
class StreamChatCore extends StatefulWidget {
  /// Constructor used for creating a new instance of [StreamChatCore].
  ///
  /// [StreamChatCore] is a stateful widget which reacts to system events and
  /// updates Stream's connection status accordingly.
  const StreamChatCore({
    super.key,
    required this.client,
    required this.child,
    this.onBackgroundEventReceived,
    this.backgroundKeepAlive = const Duration(minutes: 1),
    this.connectivityStream,
  });

  /// Instance of Stream Chat Client containing information about the current
  /// application.
  final StreamChatClient client;

  /// Widget descendant.
  final Widget child;

  /// The amount of time that will pass before disconnecting the client in
  /// the background
  final Duration backgroundKeepAlive;

  /// Handler called whenever the [client] receives a new [Event] while the app
  /// is in background. Can be used to display various notifications depending
  /// upon the [Event.type]
  final EventHandler? onBackgroundEventReceived;

  /// Stream of connectivity result
  /// Visible for testing
  @visibleForTesting
  final Stream<InternetStatus>? connectivityStream;

  @override
  StreamChatCoreState createState() => StreamChatCoreState();

  /// Finds the [StreamChatCoreState] from the closest [StreamChatCore] ancestor
  /// that encloses the given [context].
  ///
  /// This will throw a [FlutterError] if no [StreamChatCore] is found in the
  /// widget tree above the given context.
  ///
  /// Typical usage:
  ///
  /// ```dart
  /// final chatCoreState = StreamChatCore.of(context);
  /// ```
  ///
  /// If you're calling this in the same `build()` method that creates the
  /// `StreamChatCore`, consider using a `Builder` or refactoring into a
  /// separate widget to obtain a context below the [StreamChatCore].
  ///
  /// If you want to return null instead of throwing, use [maybeOf].
  static StreamChatCoreState of(BuildContext context) {
    final result = maybeOf(context);
    if (result != null) return result;

    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'StreamChatCore.of() called with a context that does not contain a '
        'StreamChatCore.',
      ),
      ErrorDescription(
        'No StreamChatCore ancestor could be found starting from the context '
        'that was passed to StreamChatCore.of(). This usually happens when the '
        'context used comes from the widget that creates the StreamChatCore '
        'itself.',
      ),
      ErrorHint(
        'To fix this, ensure that you are using a context that is a descendant '
        'of the StreamChatCore. You can use a Builder to get a new context '
        'that is under the StreamChatCore:\n\n'
        '  Builder(\n'
        '    builder: (context) {\n'
        '      final chatCoreState = StreamChatCore.of(context);\n'
        '      ...\n'
        '    },\n'
        '  )',
      ),
      ErrorHint(
        'Alternatively, split your build method into smaller widgets so that '
        'you get a new BuildContext that is below the StreamChatCore in the '
        'widget tree.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  /// Finds the [StreamChatCoreState] from the closest [StreamChatCore] ancestor
  /// that encloses the given context.
  ///
  /// Returns null if no such ancestor exists.
  ///
  /// See also:
  ///  * [of], which throws if no [StreamChatCore] is found.
  static StreamChatCoreState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<StreamChatCoreState>();
  }
}

/// State class associated with [StreamChatCore].
class StreamChatCoreState extends State<StreamChatCore> with WidgetsBindingObserver {
  /// The current user
  User? get currentUser => client.state.currentUser;

  /// The current user as a stream
  Stream<User?> get currentUserStream => client.state.currentUserStream;

  StreamSubscription<InternetStatus>? _connectivitySubscription;

  var _isInForeground = true;
  var _isConnectionAvailable = true;
  /// Initialized client used throughout the application.
  StreamChatClient get client => widget.client;

  Future<SystemEnvironment> get _getSystemEnvironment async {
    String? osVersion;
    String? deviceModel;

    try {
      switch (CurrentPlatform.type) {
        case PlatformType.android:
          final info = await DeviceInfoPlugin().androidInfo;
          osVersion = info.version.release;
          deviceModel = '${info.manufacturer} ${info.model}';
          break;

        case PlatformType.ios:
          final info = await DeviceInfoPlugin().iosInfo;
          osVersion = info.systemVersion;
          deviceModel = info.utsname.machine;
          break;

        case PlatformType.macOS:
          final info = await DeviceInfoPlugin().macOsInfo;
          osVersion = [info.majorVersion, info.minorVersion, info.patchVersion].join('.');
          deviceModel = info.model;
          break;

        case PlatformType.windows:
          final info = await DeviceInfoPlugin().windowsInfo;
          osVersion = [info.majorVersion, info.minorVersion, info.buildNumber].join('.');
          deviceModel = null;
          break;

        case PlatformType.linux:
          final info = await DeviceInfoPlugin().linuxInfo;
          osVersion = '${info.name} ${info.version}';
          deviceModel = null;
          break;

        default:
          osVersion = null;
          deviceModel = null;
          break;
      }
    } catch (_) {}

    String? appName;
    String? appVersion;

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appName = packageInfo.appName;
      appVersion = packageInfo.version;
    } catch (_) {}

    return SystemEnvironment(
      sdkName: 'stream-chat',
      sdkIdentifier: 'flutter',
      sdkVersion: StreamChatClient.packageVersion,
      appName: appName,
      appVersion: appVersion,
      osName: CurrentPlatform.name,
      osVersion: osVersion,
      deviceModel: deviceModel,
    );
  }

  late final _lifecycleManager = _ChatLifecycleManager(
    client: client,
    backgroundKeepAlive: widget.backgroundKeepAlive,
    onBackgroundEvent: widget.onBackgroundEventReceived,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscribeToConnectivityChange(widget.connectivityStream);

    // Update the client system environment.
    unawaited(_getSystemEnvironment.then(client.updateSystemEnvironment));
  }

  void _subscribeToConnectivityChange([
    Stream<InternetStatus>? connectivityStream,
  ]) {
    if (_connectivitySubscription == null) {
      connectivityStream ??= InternetConnection().onStatusChange;
      _connectivitySubscription = connectivityStream.listen((status) {
        _isConnectionAvailable = status == InternetStatus.connected;
        if (!_isInForeground) return;
        if (_isConnectionAvailable) {
          if (client.wsConnectionStatus == ConnectionStatus.disconnected &&
              currentUser != null) {
            client.openConnection();
          }
        } else {
          if (client.wsConnectionStatus == ConnectionStatus.connected) {
            client.closeConnection();
          }
        }
      });
    }
  }

  void _unsubscribeFromConnectivityChange() {
    if (_connectivitySubscription != null) {
      _connectivitySubscription?.cancel();
      _connectivitySubscription = null;
    }
  }

  @override
  void didUpdateWidget(StreamChatCore oldWidget) {
    super.didUpdateWidget(oldWidget);
    final connectivityStream = widget.connectivityStream;
    if (connectivityStream != oldWidget.connectivityStream) {
      _unsubscribeFromConnectivityChange();
      _subscribeToConnectivityChange(connectivityStream);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lifecycleManager.onAppLifecycleChanged(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _unsubscribeFromConnectivityChange();
    _lifecycleManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

final class _ChatLifecycleManager {
  _ChatLifecycleManager({
    required this.client,
    this.onBackgroundEvent,
    this.backgroundKeepAlive = const Duration(minutes: 1),
  });

  final StreamChatClient client;
  final EventHandler? onBackgroundEvent;
  final Duration backgroundKeepAlive;

  bool _isInBackground = false;
  void onAppLifecycleChanged(AppLifecycleState lifecycle) {
    final wasInBackground = _isInBackground;
    _isInBackground = !_isAppInForeground(lifecycle);

    if (wasInBackground && !_isInBackground) return _onForeground();
    if (!wasInBackground && _isInBackground) return _onBackground();
  }

  bool _isAppInForeground(AppLifecycleState state) {
    return switch (state) {
      AppLifecycleState.resumed || AppLifecycleState.inactive => true,
      _ => false,
    };
  }

  void _onForeground() {
    _cancelBackgroundTimer();
    _cancelEventSubscription();

    return client.maybeReconnect().ignore();
  }

  void _onBackground() {
    _cancelBackgroundTimer();

    final handler = onBackgroundEvent;
    if (handler == null) return client.maybeDisconnect();

    return _startBackgroundEventListening(handler);
  }

  Timer? _backgroundTimer;
  StreamSubscription? _eventSubscription;

  void _startBackgroundEventListening(EventHandler handler) {
    _cancelEventSubscription();
    _eventSubscription = client.on().listen(handler);

    _backgroundTimer = Timer(backgroundKeepAlive, () {
      _cancelEventSubscription();
      client.maybeDisconnect();
    });
  }

  void onConnectivityChanged(List<ConnectivityResult> results) {
    if (_isInBackground) return;

    final hasConnectivity = !results.contains(ConnectivityResult.none);

    if (hasConnectivity) return client.maybeReconnect().ignore();
    return client.maybeDisconnect();
  }

  void _cancelBackgroundTimer() {
    _backgroundTimer?.cancel();
    _backgroundTimer = null;
  }

  void _cancelEventSubscription() {
    _eventSubscription?.cancel();
    _eventSubscription = null;
  }

  void dispose() {
    _cancelBackgroundTimer();
    _cancelEventSubscription();
  }
}

/// Extension on [StreamChatClient] to provide a convenient method for
/// conditionally reconnecting the client if the user is logged in and
/// the connection is not yet established.
///
/// This helps ensure the client attempts to reconnect immediately
/// (bypassing any retry delays) when the app returns to the foreground
/// or when connectivity is restored.
extension MaybeReconnect on StreamChatClient {
  /// Optionally trigger a reconnect if the user is already logged in and the
  /// client is not yet connected.
  Future<void> maybeReconnect() async {
    if (state.currentUser == null) return;
    if (wsConnectionStatus == ConnectionStatus.connected) return;

    // Force immediate reconnection by resetting any ongoing retry delays
    // This ensures we don't wait up to 25s when user foregrounds the app
    closeConnection();
    await openConnection();
  }

  /// Optionally disconnect the client if the user is logged in and the
  /// connection is currently established.
  void maybeDisconnect() {
    if (state.currentUser == null) return;
    if (wsConnectionStatus == ConnectionStatus.disconnected) return;

    // Close the connection immediately
    return closeConnection();
  }
}
