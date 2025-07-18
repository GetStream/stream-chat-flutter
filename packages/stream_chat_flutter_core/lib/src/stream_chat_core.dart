import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
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
  final Stream<List<ConnectivityResult>>? connectivityStream;

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
        'of the StreamChatCore. You can use a Builder to get a new context that '
        'is under the StreamChatCore:\n\n'
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
class StreamChatCoreState extends State<StreamChatCore>
    with WidgetsBindingObserver {
  /// Initialized client used throughout the application.
  StreamChatClient get client => widget.client;

  Timer? _disconnectTimer;

  @override
  Widget build(BuildContext context) => widget.child;

  /// The current user
  User? get currentUser => client.state.currentUser;

  /// The current user as a stream
  Stream<User?> get currentUserStream => client.state.currentUserStream;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  var _isInForeground = true;
  var _isConnectionAvailable = true;

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
          osVersion = [info.majorVersion, info.minorVersion, info.patchVersion]
              .join('.');
          deviceModel = info.model;
          break;

        case PlatformType.windows:
          final info = await DeviceInfoPlugin().windowsInfo;
          osVersion = [info.majorVersion, info.minorVersion, info.buildNumber]
              .join('.');
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscribeToConnectivityChange(widget.connectivityStream);

    // Update the client system environment.
    unawaited(_getSystemEnvironment.then(client.updateSystemEnvironment));
  }

  void _subscribeToConnectivityChange([
    Stream<List<ConnectivityResult>>? connectivityStream,
  ]) {
    if (_connectivitySubscription == null) {
      connectivityStream ??= Connectivity().onConnectivityChanged;
      _connectivitySubscription =
          connectivityStream.distinct().listen((result) {
        _isConnectionAvailable = !result.contains(ConnectivityResult.none);
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

  StreamSubscription? _eventSubscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isInForeground = [
      AppLifecycleState.resumed,
      AppLifecycleState.inactive,
    ].contains(state);
    if (currentUser != null) {
      if (_isInForeground) {
        _onForeground();
      } else {
        _onBackground();
      }
    }
  }

  void _onForeground() {
    if (_disconnectTimer?.isActive == true) {
      _eventSubscription?.cancel();
      _disconnectTimer?.cancel();
    } else if (client.wsConnectionStatus == ConnectionStatus.disconnected &&
        _isConnectionAvailable) {
      client.openConnection();
    }
  }

  void _onBackground() {
    if (widget.onBackgroundEventReceived == null) {
      if (client.wsConnectionStatus != ConnectionStatus.disconnected) {
        client.closeConnection();
      }
      return;
    }

    _eventSubscription?.cancel();
    _eventSubscription = client.on().listen(widget.onBackgroundEventReceived);

    void onTimerComplete() {
      _eventSubscription?.cancel();
      client.closeConnection();
    }

    _disconnectTimer?.cancel();
    _disconnectTimer = Timer(widget.backgroundKeepAlive, onTimerComplete);
    return;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _unsubscribeFromConnectivityChange();
    _eventSubscription?.cancel();
    _disconnectTimer?.cancel();
    super.dispose();
  }
}
