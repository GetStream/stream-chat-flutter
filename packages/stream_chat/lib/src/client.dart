import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart' show unawaited;
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/api/retry_policy.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:stream_chat/src/models/attachment_file.dart';
import 'package:stream_chat/src/models/channel_model.dart';
import 'package:stream_chat/src/models/own_user.dart';
import 'package:stream_chat/src/platform_detector/platform_detector.dart';
import 'package:stream_chat/version.dart';
import 'package:uuid/uuid.dart';

import 'attachment_file_uploader.dart';
import 'api/channel.dart';
import 'api/connection_status.dart';
import 'api/requests.dart';
import 'api/responses.dart';
import 'api/websocket.dart';
import 'db/chat_persistence_client.dart';
import 'exceptions.dart';
import 'models/channel_state.dart';
import 'models/event.dart';
import 'models/message.dart';
import 'models/user.dart';
import 'extensions/map_extension.dart';

/// Handler function used for logging records. Function requires a single [LogRecord]
/// as the only parameter.
typedef LogHandlerFunction = void Function(LogRecord record);

/// Used for decoding [Map] data to a generic type `T`.
typedef DecoderFunction<T> = T Function(Map<String, dynamic>);

/// A function which can be used to request a Stream Chat API token from your
/// own backend server. Function requires a single [userId].
typedef TokenProvider = Future<String> Function(String userId);

/// Provider used to send push notifications.
enum PushProvider {
  /// Send notifications using Google's Firebase Cloud Messaging
  firebase,

  /// Send notifications using Apple's Push Notification service
  apn
}

extension on PushProvider {
  /// Returns the string notion for [PushProvider].
  String get name {
    if (this == PushProvider.apn) {
      return 'apn';
    } else {
      return 'firebase';
    }
  }
}

/// The official Dart client for Stream Chat,
/// a service for building chat applications.
/// This library can be used on any Dart project and on both mobile and web apps with Flutter.
/// You can sign up for a Stream account at https://getstream.io/chat/
///
/// The Chat client will manage API call, event handling and manage the
/// websocket connection to Stream Chat servers.
///
/// ```dart
/// final client = StreamChatClient("stream-chat-api-key");
/// ```
class StreamChatClient {
  /// Create a client instance with default options.
  /// You should only create the client once and re-use it across your application.
  StreamChatClient(
    this.apiKey, {
    this.tokenProvider,
    this.baseURL = _defaultBaseURL,
    this.logLevel = Level.WARNING,
    this.logHandlerFunction,
    Duration connectTimeout = const Duration(seconds: 6),
    Duration receiveTimeout = const Duration(seconds: 6),
    Dio httpClient,
    RetryPolicy retryPolicy,
    this.attachmentFileUploader,
  }) {
    _retryPolicy ??= RetryPolicy(
      retryTimeout: (StreamChatClient client, int attempt, ApiError error) =>
          Duration(seconds: 1 * attempt),
      shouldRetry: (StreamChatClient client, int attempt, ApiError error) =>
          attempt < 5,
    );

    attachmentFileUploader ??= StreamAttachmentFileUploader(this);

    state = ClientState(this);

    _setupLogger();
    _setupDio(httpClient, receiveTimeout, connectTimeout);

    logger.info('instantiating new client');
  }

  /// Chat persistence client
  ChatPersistenceClient chatPersistenceClient;

  /// Attachment uploader
  AttachmentFileUploader attachmentFileUploader;

  /// Whether the chat persistence is available or not
  bool get persistenceEnabled => chatPersistenceClient != null;

  RetryPolicy _retryPolicy;

  bool _synced = false;

  /// The retry policy options getter
  RetryPolicy get retryPolicy => _retryPolicy;

  /// This client state
  ClientState state;

  /// By default the Chat client will write all messages with level Warn or Error to stdout.
  /// During development you might want to enable more logging information, you can change the default log level when constructing the client.
  ///
  /// ```dart
  /// final client = StreamChatClient("stream-chat-api-key", logLevel: Level.INFO);
  /// ```
  final Level logLevel;

  /// Client specific logger instance.
  /// Refer to the class [Logger] to learn more about the specific implementation.
  final Logger logger = Logger.detached('📡');

  /// A function that has a parameter of type [LogRecord].
  /// This is called on every new log record.
  /// By default the client will use the handler returned by [_getDefaultLogHandler].
  /// Setting it you can handle the log messages directly instead of have them written to stdout,
  /// this is very convenient if you use an error tracking tool or if you want to centralize your logs into one facility.
  ///
  /// ```dart
  /// myLogHandlerFunction = (LogRecord record) {
  ///  // do something with the record (ie. send it to Sentry or Fabric)
  /// }
  ///
  /// final client = StreamChatClient("stream-chat-api-key", logHandlerFunction: myLogHandlerFunction);
  ///```
  LogHandlerFunction logHandlerFunction;

  /// Your project Stream Chat api key.
  /// Find your API keys here https://getstream.io/dashboard/
  String apiKey;

  /// Your project Stream Chat base url.
  final String baseURL;

  /// A function in which you send a request to your own backend to get a Stream Chat API token.
  /// The token will be the return value of the function.
  /// It's used by the client to refresh the token once expired or to connect the user without a predefined token using [connectUserWithProvider].
  final TokenProvider tokenProvider;

  /// [Dio] httpClient
  /// It's be chosen because it's easy to use and supports interesting features out of the box
  /// (Interceptors, Global configuration, FormData, File downloading etc.)
  @visibleForTesting
  Dio httpClient = Dio();

  static const _defaultBaseURL = 'chat-us-east-1.stream-io-api.com';
  static const _tokenExpiredErrorCode = 40;
  StreamSubscription<ConnectionStatus> _connectionStatusSubscription;
  Future<void> Function(ConnectionStatus) _connectionStatusHandler;

  final BehaviorSubject<Event> _controller = BehaviorSubject<Event>();

  /// Stream of [Event] coming from websocket connection
  /// Listen to this or use the [on] method to filter specific event types
  Stream<Event> get stream => _controller.stream;

  final _wsConnectionStatusController =
      BehaviorSubject.seeded(ConnectionStatus.disconnected);

  set _wsConnectionStatus(ConnectionStatus status) =>
      _wsConnectionStatusController.add(status);

  /// The current status value of the websocket connection
  ConnectionStatus get wsConnectionStatus =>
      _wsConnectionStatusController.value;

  /// This notifies the connection status of the websocket connection.
  /// Listen to this to get notified when the websocket tries to reconnect.
  Stream<ConnectionStatus> get wsConnectionStatusStream =>
      _wsConnectionStatusController.stream;

  /// The current user token
  String token;

  /// The id of the current websocket connection
  String get connectionId => _connectionId;

  bool _anonymous = false;
  String _connectionId;
  WebSocket _ws;

  bool get _hasConnectionId => _connectionId != null;

  void _setupDio(
    Dio httpClient,
    Duration receiveTimeout,
    Duration connectTimeout,
  ) {
    logger.info('http client setup');

    this.httpClient = httpClient ?? Dio();

    String url;
    if (!baseURL.startsWith('https') && !baseURL.startsWith('http')) {
      url = Uri.https(baseURL, '').toString();
    } else {
      url = baseURL;
    }

    this.httpClient.options.baseUrl = url;
    this.httpClient.options.receiveTimeout = receiveTimeout.inMilliseconds;
    this.httpClient.options.connectTimeout = connectTimeout.inMilliseconds;
    this.httpClient.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options) async {
              options.queryParameters.addAll(_commonQueryParams);
              options.headers.addAll(_httpHeaders);

              if (_connectionId != null &&
                  (options.data is Map || options.data == null)) {
                options.data = {
                  'connection_id': _connectionId,
                  ...(options.data ?? {}),
                };
              }

              var stringData = options.data.toString();

              if (options.data is FormData) {
                final multiPart = (options.data as FormData).files[0]?.value;
                stringData =
                    '${multiPart?.filename} - ${multiPart?.contentType}';
              }

              logger.info('''
    
          method: ${options.method}
          url: ${options.uri} 
          headers: ${options.headers}
          data: $stringData
    
        ''');

              return options;
            },
            onError: _tokenExpiredInterceptor,
          ),
        );
  }

  Future<void> _tokenExpiredInterceptor(DioError err) async {
    final apiError = ApiError(
      err.response?.data,
      err.response?.statusCode,
    );

    if (apiError.code == _tokenExpiredErrorCode) {
      logger.info('token expired');

      if (tokenProvider != null) {
        httpClient.lock();
        final userId = state.user.id;

        await _disconnect();

        final newToken = await tokenProvider(userId);
        await Future.delayed(Duration(seconds: 4));
        token = newToken;

        httpClient.unlock();

        await connectUser(User(id: userId), newToken);

        try {
          return await httpClient.request(
            err.request.path,
            cancelToken: err.request.cancelToken,
            data: err.request.data,
            onReceiveProgress: err.request.onReceiveProgress,
            onSendProgress: err.request.onSendProgress,
            queryParameters: err.request.queryParameters,
            options: err.request,
          );
        } catch (err) {
          return err;
        }
      }
    }

    return err;
  }

  LogHandlerFunction _getDefaultLogHandler() {
    final levelEmojiMapper = {
      Level.INFO.name: 'ℹ️',
      Level.WARNING.name: '⚠️',
      Level.SEVERE.name: '🚨',
    };
    return (LogRecord record) {
      print(
          '(${record.time}) ${levelEmojiMapper[record.level.name] ?? record.level.name} ${record.loggerName} ${record.message}');
      if (record.stackTrace != null) {
        print(record.stackTrace);
      }
    };
  }

  Logger _detachedLogger(
    String name,
  ) {
    return Logger.detached(name)
      ..level = logLevel
      ..onRecord.listen(logHandlerFunction ?? _getDefaultLogHandler());
  }

  void _setupLogger() {
    logger.level = logLevel;

    logHandlerFunction ??= _getDefaultLogHandler();

    logger.onRecord.listen(logHandlerFunction);

    logger.info('logger setup');
  }

  /// Call this function to dispose the client
  void dispose() async {
    await chatPersistenceClient?.disconnect();
    await _disconnect();
    httpClient.close();
    await _controller.close();
    state.dispose();
    await _wsConnectionStatusController.close();
  }

  Map<String, String> get _httpHeaders => {
        'Authorization': token,
        'stream-auth-type': _authType,
        'x-stream-client': _userAgent,
        'Content-Encoding': 'gzip',
      };

  /// Set the current user, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  @Deprecated('Use `connectUser` instead. Will be removed in Future releases')
  Future<Event> setUser(User user, String token) => connectUser(user, token);

  /// Connects the current user, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  Future<Event> connectUser(User user, String token) async {
    if (_connectCompleter != null && !_connectCompleter.isCompleted) {
      logger.warning('Already connecting');
      throw Exception('Already connecting');
    }

    _connectCompleter = Completer();

    logger.info('connect user');
    state.user = OwnUser.fromJson(user.toJson());
    this.token = token;
    _anonymous = false;

    return connect().then((event) {
      _connectCompleter.complete(event);
      return event;
    }).catchError((e, s) {
      _connectCompleter.completeError(e, s);
      throw e;
    });
  }

  /// Set the current user using the [tokenProvider] to fetch the token.
  /// It returns a [Future] that resolves when the connection is setup.
  @Deprecated(
      'Use `connectUserWithProvider` instead. Will be removed in Future releases')
  Future<Event> setUserWithProvider(User user) => connectUserWithProvider(user);

  /// Connects the current user using the [tokenProvider] to fetch the token.
  /// It returns a [Future] that resolves when the connection is setup.
  Future<Event> connectUserWithProvider(User user) async {
    if (tokenProvider == null) {
      throw Exception('''
      TokenProvider must be provided in the constructor in order to use `connectUserWithProvider` method.
      Use `connectUser` providing a token.
      ''');
    }
    final token = await tokenProvider(user.id);
    return connectUser(user, token);
  }

  /// Stream of [Event] coming from websocket connection
  /// Pass an eventType as parameter in order to filter just a type of event
  Stream<Event> on([
    String eventType,
    String eventType2,
    String eventType3,
    String eventType4,
  ]) =>
      stream.where((event) =>
          eventType == null ||
          (event.type != null &&
              (event.type == eventType ||
                  event.type == eventType2 ||
                  event.type == eventType3 ||
                  event.type == eventType4)));

  /// Method called to add a new event to the [_controller].
  void handleEvent(Event event) async {
    logger.info('handle new event: ${event.toJson()}');
    if (event.connectionId != null) {
      _connectionId = event.connectionId;
    }

    if (!event.isLocal) {
      if (_synced && event.createdAt != null) {
        await chatPersistenceClient?.updateConnectionInfo(event);
        await chatPersistenceClient?.updateLastSyncAt(event.createdAt);
      }
    }

    if (event.user != null) {
      state._updateUser(event.user);
    }

    if (event.me != null) {
      state.user = event.me;
    }
    _controller.add(event);
  }

  Completer<Event> _connectCompleter;

  /// Connect the client websocket
  Future<Event> connect() async {
    logger.info('connecting');
    if (wsConnectionStatus == ConnectionStatus.connecting) {
      logger.warning('Already connecting');
      throw Exception('Already connecting');
    }

    if (wsConnectionStatus == ConnectionStatus.connected) {
      logger.warning('Already connected');
      throw Exception('Already connected');
    }

    _wsConnectionStatus = ConnectionStatus.connecting;

    if (persistenceEnabled) {
      await chatPersistenceClient.connect(state.user.id);
    }

    _ws = WebSocket(
      baseUrl: baseURL,
      user: state.user,
      connectParams: {
        'api_key': apiKey,
        'authorization': token,
        'stream-auth-type': _authType,
        'x-stream-client': _userAgent,
      },
      connectPayload: {
        'user_id': state.user.id,
        'server_determines_connection_id': true,
      },
      handler: handleEvent,
      logger: _detachedLogger('🔌'),
    );

    _connectionStatusHandler = (ConnectionStatus status) async {
      _wsConnectionStatus = status;
      handleEvent(
        Event(
          type: EventType.connectionChanged,
          online: status == ConnectionStatus.connected,
        ),
      );

      if (status == ConnectionStatus.connected &&
          state.channels?.isNotEmpty == true) {
        unawaited(queryChannelsOnline(filter: {
          'cid': {
            '\$in': state.channels.keys.toList(),
          },
        }).then(
          (_) async {
            await resync();
            handleEvent(Event(
              type: EventType.connectionRecovered,
              online: true,
            ));
          },
        ));
      } else {
        _synced = false;
      }
    };

    _connectionStatusSubscription =
        _ws.connectionStatusStream.listen(_connectionStatusHandler);

    var event = await chatPersistenceClient?.getConnectionInfo();

    await _ws.connect().then((e) async {
      await chatPersistenceClient?.updateConnectionInfo(e);
      event = e;
      await resync();
    }).catchError((err, stacktrace) {
      logger.severe('error connecting ws', err, stacktrace);
      if (err is Map) {
        throw err;
      }
    });

    return event;
  }

  /// Get the events missed while offline to sync the offline storage
  Future<void> resync([List<String> cids]) async {
    final lastSyncAt = await chatPersistenceClient?.getLastSyncAt();

    if (lastSyncAt == null) {
      _synced = true;
      return;
    }

    cids ??= await chatPersistenceClient?.getChannelCids();

    if (cids?.isEmpty == true) {
      return;
    }

    try {
      final rawRes = await post('/sync', data: {
        'channel_cids': cids,
        'last_sync_at': lastSyncAt.toUtc().toIso8601String(),
      });
      logger.fine('rawRes: $rawRes');

      final res = decode<SyncResponse>(
        rawRes.data,
        SyncResponse.fromJson,
      );

      res.events.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      res.events.forEach((element) {
        logger.fine('element.type: ${element.type}');
        logger.fine('element.message.text: ${element.message?.text}');
      });

      res.events.forEach((event) {
        handleEvent(event);
      });

      await chatPersistenceClient?.updateLastSyncAt(DateTime.now());
      _synced = true;
    } catch (error) {
      logger.severe('Error during resync $error');
    }
  }

  String _asMap(sort) {
    return sort?.map((s) => s.toJson().toString())?.join('');
  }

  final _queryChannelsStreams = <String, Future<List<Channel>>>{};

  /// Requests channels with a given query.
  Stream<List<Channel>> queryChannels({
    Map<String, dynamic> filter,
    List<SortOption<ChannelModel>> sort,
    Map<String, dynamic> options,
    PaginationParams paginationParams = const PaginationParams(limit: 10),
    int messageLimit,
    bool preferOffline = false,
    bool waitForConnect = true,
  }) async* {
    final hash = base64.encode(utf8.encode(
      '$filter${_asMap(sort)}$options${paginationParams?.toJson()}$messageLimit$preferOffline',
    ));

    if (_queryChannelsStreams.containsKey(hash)) {
      yield await _queryChannelsStreams[hash];
    } else {
      if (preferOffline) {
        final channels = await queryChannelsOffline(
          filter: filter,
          sort: sort,
          paginationParams: paginationParams,
        );
        if (channels.isNotEmpty) yield channels;
      }

      final newQueryChannelsFuture = queryChannelsOnline(
        filter: filter,
        sort: sort,
        options: options,
        paginationParams: paginationParams,
        messageLimit: messageLimit,
      ).whenComplete(() {
        _queryChannelsStreams.remove(hash);
      });

      _queryChannelsStreams[hash] = newQueryChannelsFuture;

      yield await newQueryChannelsFuture;
    }
  }

  /// Requests channels with a given query from the API.
  Future<List<Channel>> queryChannelsOnline({
    @required Map<String, dynamic> filter,
    List<SortOption<ChannelModel>> sort,
    Map<String, dynamic> options,
    int messageLimit,
    PaginationParams paginationParams = const PaginationParams(limit: 10),
    bool waitForConnect = true,
  }) async {
    if (waitForConnect) {
      if (_connectCompleter != null && !_connectCompleter.isCompleted) {
        logger.info('awaiting connection completer');
        await _connectCompleter.future;
      }
      if (wsConnectionStatus != ConnectionStatus.connected) {
        throw Exception(
          'You cannot use queryChannels without an active connection.'
          ' Please call `connectUser` to connect the client.',
        );
      }
    }

    logger.info('Query channel start');
    final defaultOptions = {
      'state': true,
      'watch': true,
      'presence': false,
    };

    var payload = <String, dynamic>{
      'filter_conditions': filter,
      'sort': sort,
    };

    if (messageLimit != null) {
      payload['message_limit'] = messageLimit;
    }

    payload.addAll(defaultOptions);

    if (options != null) {
      payload.addAll(options);
    }

    if (paginationParams != null) {
      payload.addAll(paginationParams.toJson());
    }

    final response = await get(
      '/channels',
      queryParameters: {
        'payload': jsonEncode(payload),
      },
    );

    final res = decode<QueryChannelsResponse>(
      response.data,
      QueryChannelsResponse.fromJson,
    );

    if ((res.channels ?? []).isEmpty && (paginationParams?.offset ?? 0) == 0) {
      logger.warning('''We could not find any channel for this query.
          Please make sure to take a look at the Flutter tutorial: https://getstream.io/chat/flutter/tutorial
          If your application already has users and channels, you might need to adjust your query channel as explained in the docs https://getstream.io/chat/docs/query_channels/?language=dart''');
      return <Channel>[];
    }

    final channels = res.channels;

    final users = channels
        .expand((it) => it.members)
        .map((it) => it.user)
        .toList(growable: false);

    state._updateUsers(users);

    logger.info('Got ${res.channels?.length} channels from api');

    final updateData = _mapChannelStateToChannel(channels);

    await chatPersistenceClient?.updateChannelQueries(
      filter,
      channels.map((c) => c.channel.cid).toList(),
      paginationParams?.offset == null || paginationParams.offset == 0,
    );

    state.channels = updateData.key;
    return updateData.value;
  }

  /// Requests channels with a given query from the Persistence client.
  Future<List<Channel>> queryChannelsOffline({
    @required Map<String, dynamic> filter,
    @required List<SortOption<ChannelModel>> sort,
    PaginationParams paginationParams = const PaginationParams(limit: 10),
  }) async {
    final offlineChannels = await chatPersistenceClient?.getChannelStates(
      filter: filter,
      sort: sort,
      paginationParams: paginationParams,
    );
    final updatedData = _mapChannelStateToChannel(offlineChannels);
    state.channels = updatedData.key;
    return updatedData.value;
  }

  MapEntry<Map<String, Channel>, List<Channel>> _mapChannelStateToChannel(
    List<ChannelState> channelStates,
  ) {
    final channels = {...state.channels ?? {}};
    final newChannels = <Channel>[];
    if (channelStates != null) {
      for (final channelState in channelStates) {
        final channel = channels[channelState.channel.cid];
        if (channel != null) {
          channel.state?.updateChannelState(channelState);
          newChannels.add(channel);
        } else {
          final newChannel = Channel.fromState(this, channelState);
          channels[newChannel.cid] = newChannel;
          newChannels.add(newChannel);
        }
      }
    }
    return MapEntry(channels, newChannels);
  }

  Object _parseError(DioError error) {
    if (error.type == DioErrorType.RESPONSE) {
      final apiError =
          ApiError(error.response?.data, error.response?.statusCode);
      logger.severe('apiError: ${apiError.toString()}');
      return apiError;
    }

    return error;
  }

  /// Handy method to make http GET request with error parsing.
  Future<Response<String>> get(
    String path, {
    Map<String, dynamic> queryParameters,
  }) async {
    try {
      final response = await httpClient.get<String>(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http POST request with error parsing.
  Future<Response<String>> post(
    String path, {
    dynamic data,
    ProgressCallback onSendProgress,
    CancelToken cancelToken,
  }) async {
    try {
      final response = await httpClient.post<String>(
        path,
        data: data,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http DELETE request with error parsing.
  Future<Response<String>> delete(
    String path, {
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
  }) async {
    try {
      final response = await httpClient.delete<String>(
        path,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http PATCH request with error parsing.
  Future<Response<String>> patch(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
  }) async {
    try {
      final response = await httpClient.patch<String>(
        path,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Handy method to make http PUT request with error parsing.
  Future<Response<String>> put(
    String path, {
    Map<String, dynamic> queryParameters,
    dynamic data,
  }) async {
    try {
      final response = await httpClient.put<String>(
        path,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } on DioError catch (error) {
      throw _parseError(error);
    }
  }

  /// Used to log errors and stacktrace in case of bad json deserialization
  T decode<T>(String j, DecoderFunction<T> decoderFunction) {
    try {
      if (j == null) {
        return null;
      }
      return decoderFunction(json.decode(j));
    } catch (error, stacktrace) {
      logger.severe('Error decoding response', error, stacktrace);
      rethrow;
    }
  }

  String get _authType => _anonymous ? 'anonymous' : 'jwt';

  String get _userAgent =>
      'stream-chat-dart-client-${CurrentPlatform.name}-${PACKAGE_VERSION.split('+')[0]}';

  Map<String, String> get _commonQueryParams => {
        'user_id': state.user?.id,
        'api_key': apiKey,
        'connection_id': _connectionId,
      };

  /// Set the current user with an anonymous id, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  @Deprecated(
      'Use `connectAnonymousUser` instead. Will be removed in Future releases')
  Future<Event> setAnonymousUser() => connectAnonymousUser();

  /// Connects the current user with an anonymous id, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  Future<Event> connectAnonymousUser() async {
    if (_connectCompleter != null && !_connectCompleter.isCompleted) {
      logger.warning('Already connecting');
      throw Exception('Already connecting');
    }

    _connectCompleter = Completer();

    _anonymous = true;
    final uuid = Uuid();
    state.user = OwnUser(id: uuid.v4());

    return connect().then((event) {
      _connectCompleter.complete(event);
      return event;
    }).catchError((e, s) {
      _connectCompleter.completeError(e, s);
      throw e;
    });
  }

  /// Set the current user as guest, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  @Deprecated(
      'Use `connectGuestUser` instead. Will be removed in Future releases')
  Future<Event> setGuestUser(User user) => connectGuestUser(user);

  /// Connects the current user as guest, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  Future<Event> connectGuestUser(User user) async {
    _anonymous = true;
    final response = await post('/guest', data: {'user': user.toJson()})
        .then((res) => decode<ConnectGuestUserResponse>(
            res.data, ConnectGuestUserResponse.fromJson))
        .whenComplete(() => _anonymous = false);
    return connectUser(
      response.user,
      response.accessToken,
    );
  }

  /// Closes the websocket connection and resets the client
  /// If [flushChatPersistence] is true the client deletes all offline user's data
  /// If [clearUser] is true the client unsets the current user
  Future<void> disconnect({
    bool flushChatPersistence = false,
    bool clearUser = false,
  }) async {
    logger.info(
        'Disconnecting flushOfflineStorage: $flushChatPersistence; clearUser: $clearUser');

    await chatPersistenceClient?.disconnect(flush: flushChatPersistence);
    chatPersistenceClient = null;

    _connectCompleter = null;

    if (clearUser == true) {
      state.dispose();
      state = ClientState(this);
    }

    await _disconnect();
  }

  Future<void> _disconnect() async {
    logger.info('Client disconnecting');

    await _ws?.disconnect();
    await _connectionStatusSubscription?.cancel();
  }

  /// Requests users with a given query.
  Future<QueryUsersResponse> queryUsers({
    Map<String, dynamic> filter,
    List<SortOption> sort,
    Map<String, dynamic> options,
    PaginationParams pagination,
  }) async {
    final defaultOptions = {
      'presence': _hasConnectionId,
    };

    final payload = <String, dynamic>{
      'filter_conditions': filter ?? {},
      'sort': sort,
    };

    payload.addAll(defaultOptions);

    if (pagination != null) {
      payload.addAll(pagination.toJson());
    }

    if (options != null) {
      payload.addAll(options);
    }

    final rawRes = await get(
      '/users',
      queryParameters: {
        'payload': jsonEncode(payload),
      },
    );

    final response = decode<QueryUsersResponse>(
      rawRes.data,
      QueryUsersResponse.fromJson,
    );

    state?._updateUsers(response.users);

    return response;
  }

  /// A message search.
  Future<SearchMessagesResponse> search(
    Map<String, dynamic> filters, {
    String query,
    List<SortOption> sort,
    PaginationParams paginationParams,
    Map<String, dynamic> messageFilters,
  }) async {
    assert(() {
      if (filters == null || filters.isEmpty) {
        throw ArgumentError('`filters` cannot be set as null or empty');
      }
      if (query == null && messageFilters == null) {
        throw ArgumentError('Provide at least `query` or `messageFilters`');
      }
      if (query != null && messageFilters != null) {
        throw ArgumentError(
          "Can't provide both `query` and `messageFilters` at the same time",
        );
      }
      return true;
    }());

    final payload = {
      'filter_conditions': filters,
      'message_filter_conditions': messageFilters,
      'query': query,
      'sort': sort,
      if (paginationParams != null) ...paginationParams.toJson(),
    }.nullProtected;

    final response = await get('/search', queryParameters: {
      'payload': json.encode(payload),
    });

    return decode<SearchMessagesResponse>(
        response.data, SearchMessagesResponse.fromJson);
  }

  /// Send a [file] to the [channelId] of type [channelType]
  Future<SendFileResponse> sendFile(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback onSendProgress,
    CancelToken cancelToken,
  }) {
    return attachmentFileUploader.sendFile(
      file,
      channelId,
      channelType,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }

  /// Send a [image] to the [channelId] of type [channelType]
  Future<SendImageResponse> sendImage(
    AttachmentFile image,
    String channelId,
    String channelType, {
    ProgressCallback onSendProgress,
    CancelToken cancelToken,
  }) {
    return attachmentFileUploader.sendImage(
      image,
      channelId,
      channelType,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }

  /// Delete a file from this channel
  Future<EmptyResponse> deleteFile(
    String url,
    String channelId,
    String channelType, {
    CancelToken cancelToken,
  }) {
    return attachmentFileUploader.deleteFile(
      url,
      channelId,
      channelType,
      cancelToken: cancelToken,
    );
  }

  /// Delete an image from this channel
  Future<EmptyResponse> deleteImage(
    String url,
    String channelId,
    String channelType, {
    CancelToken cancelToken,
  }) {
    return attachmentFileUploader.deleteImage(
      url,
      channelId,
      channelType,
      cancelToken: cancelToken,
    );
  }

  /// Add a device for Push Notifications.
  Future<EmptyResponse> addDevice(String id, PushProvider pushProvider) async {
    final response = await post('/devices', data: {
      'id': id,
      'push_provider': pushProvider.name,
    });
    return decode<EmptyResponse>(response.data, EmptyResponse.fromJson);
  }

  /// Gets a list of user devices.
  Future<ListDevicesResponse> getDevices() async {
    final response = await get('/devices');
    return decode<ListDevicesResponse>(
        response.data, ListDevicesResponse.fromJson);
  }

  /// Remove a user's device.
  Future<EmptyResponse> removeDevice(String id) async {
    final response = await delete('/devices', queryParameters: {
      'id': id,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Get a development token
  String devToken(String userId) {
    final payload = json.encode({'user_id': userId});
    final payloadBytes = utf8.encode(payload);
    final payloadB64 = base64.encode(payloadBytes);
    return 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.$payloadB64.devtoken';
  }

  /// Returns a channel client with the given type, id and custom data.
  Channel channel(
    String type, {
    String id,
    Map<String, dynamic> extraData,
  }) {
    if (type != null &&
        id != null &&
        state.channels?.containsKey('$type:$id') == true) {
      return state.channels['$type:$id'];
    }

    return Channel(this, type, id, extraData);
  }

  /// Update or Create the given user object.
  Future<UpdateUsersResponse> updateUser(User user) async {
    return updateUsers([user]);
  }

  /// Batch update a list of users
  Future<UpdateUsersResponse> updateUsers(List<User> users) async {
    final response = await post('/users', data: {
      'users': users.asMap().map((_, u) => MapEntry(u.id, u.toJson())),
    });
    return decode<UpdateUsersResponse>(
      response.data,
      UpdateUsersResponse.fromJson,
    );
  }

  /// Bans a user from all channels
  Future<EmptyResponse> banUser(
    String targetUserID, [
    Map<String, dynamic> options = const {},
  ]) async {
    final data = Map<String, dynamic>.from(options)
      ..addAll({
        'target_user_id': targetUserID,
      });
    final response = await post(
      '/moderation/ban',
      data: data,
    );
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Remove global ban for a user
  Future<EmptyResponse> unbanUser(
    String targetUserID, [
    Map<String, dynamic> options = const {},
  ]) async {
    final data = Map<String, dynamic>.from(options)
      ..addAll({
        'target_user_id': targetUserID,
      });
    final response = await delete(
      '/moderation/ban',
      queryParameters: data,
    );
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Shadow bans a user
  Future<EmptyResponse> shadowBan(
    String targetID, [
    Map<String, dynamic> options = const {},
  ]) async {
    return banUser(targetID, {
      'shadow': true,
      ...options,
    });
  }

  /// Removes shadow ban from a user
  Future<EmptyResponse> removeShadowBan(
    String targetID, [
    Map<String, dynamic> options = const {},
  ]) async {
    return unbanUser(targetID, {
      'shadow': true,
      ...options,
    });
  }

  /// Mutes a user
  Future<EmptyResponse> muteUser(String targetID) async {
    final response = await post('/moderation/mute', data: {
      'target_id': targetID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Unmutes a user
  Future<EmptyResponse> unmuteUser(String targetID) async {
    final response = await post('/moderation/unmute', data: {
      'target_id': targetID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Flag a message
  Future<EmptyResponse> flagMessage(String messageID) async {
    final response = await post('/moderation/flag', data: {
      'target_message_id': messageID,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Unflag a message
  Future<EmptyResponse> unflagMessage(String messageId) async {
    final response = await post('/moderation/unflag', data: {
      'target_message_id': messageId,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Flag a user
  Future<EmptyResponse> flagUser(String userId) async {
    final response = await post('/moderation/flag', data: {
      'target_user_id': userId,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Unflag a message
  Future<EmptyResponse> unflagUser(String userId) async {
    final response = await post('/moderation/unflag', data: {
      'target_user_id': userId,
    });
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Mark all channels for this user as read
  Future<EmptyResponse> markAllRead() async {
    final response = await post('/channels/read');
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Sends the message to the given channel
  Future<SendMessageResponse> sendMessage(
      Message message, String channelId, String channelType) async {
    final response = await post(
      '/channels/$channelType/$channelId/message',
      data: {'message': message.toJson()},
    );
    return decode(response.data, SendMessageResponse.fromJson);
  }

  /// Update the given message
  Future<UpdateMessageResponse> updateMessage(Message message) async {
    final response = await post(
      '/messages/${message.id}',
      data: {'message': message.toJson()},
    );
    return decode(response.data, UpdateMessageResponse.fromJson);
  }

  /// Deletes the given message
  Future<EmptyResponse> deleteMessage(Message message) async {
    final response = await delete('/messages/${message.id}');
    return decode(response.data, EmptyResponse.fromJson);
  }

  /// Get a message by id
  Future<GetMessageResponse> getMessage(String messageId) async {
    final response = await get('/messages/$messageId');
    return decode(response.data, GetMessageResponse.fromJson);
  }

  /// Pins provided message
  Future<UpdateMessageResponse> pinMessage(
    Message message,
    Object timeoutOrExpirationDate,
  ) {
    assert(() {
      if (timeoutOrExpirationDate is! DateTime &&
          timeoutOrExpirationDate is! num &&
          timeoutOrExpirationDate != null) {
        throw ArgumentError('Invalid timeout or Expiration date');
      }
      return true;
    }());

    DateTime pinExpires;
    if (timeoutOrExpirationDate is DateTime) {
      pinExpires = timeoutOrExpirationDate.toUtc();
    } else if (timeoutOrExpirationDate is num) {
      pinExpires = DateTime.now().add(
        Duration(seconds: timeoutOrExpirationDate.toInt()),
      );
    }
    return updateMessage(
      message.copyWith(pinned: true, pinExpires: pinExpires),
    );
  }

  /// Unpins provided message
  Future<UpdateMessageResponse> unpinMessage(Message message) {
    return updateMessage(message.copyWith(pinned: false));
  }
}

/// The class that handles the state of the channel listening to the events
class ClientState {
  final _subscriptions = <StreamSubscription>[];

  /// Creates a new instance listening to events and updating the state
  ClientState(this._client) {
    _subscriptions.addAll([
      _client
          .on()
          .where((event) => event.me != null)
          .map((e) => e.me)
          .listen((user) {
        _userController.add(user);
        if (user.totalUnreadCount != null) {
          _totalUnreadCountController.add(user.totalUnreadCount);
        }

        if (user.unreadChannels != null) {
          _unreadChannelsController.add(user.unreadChannels);
        }
      }),
      _client
          .on()
          .where((event) => event.unreadChannels != null)
          .map((e) => e.unreadChannels)
          .listen((unreadChannels) {
        _unreadChannelsController.add(unreadChannels);
      }),
      _client
          .on()
          .where((event) => event.totalUnreadCount != null)
          .map((e) => e.totalUnreadCount)
          .listen((totalUnreadCount) {
        _totalUnreadCountController.add(totalUnreadCount);
      }),
    ]);

    _listenChannelDeleted();

    _listenChannelHidden();

    _listenUserUpdated();
  }

  /// Used internally for optimistic update of unread count
  set totalUnreadCount(int unreadCount) {
    _totalUnreadCountController?.add(unreadCount ?? 0);
  }

  void _listenChannelHidden() {
    _subscriptions.add(_client.on(EventType.channelHidden).listen((event) {
      _client.chatPersistenceClient?.deleteChannels([event.cid]);
      if (channels != null) {
        channels = channels..removeWhere((cid, ch) => cid == event.cid);
      }
    }));
  }

  void _listenUserUpdated() {
    _subscriptions.add(_client.on(EventType.userUpdated).listen((event) {
      if (event.user.id == user.id) {
        user = OwnUser.fromJson(event.user.toJson());
      }
      _updateUser(event.user);
    }));
  }

  void _listenChannelDeleted() {
    _subscriptions.add(_client
        .on(
      EventType.channelDeleted,
      EventType.notificationRemovedFromChannel,
      EventType.notificationChannelDeleted,
    )
        .listen((Event event) async {
      final eventChannel = event.channel;
      await _client.chatPersistenceClient?.deleteChannels([eventChannel.cid]);
      if (channels != null) {
        channels = channels..remove(eventChannel.cid);
      }
    }));
  }

  final StreamChatClient _client;

  /// Update user information
  set user(OwnUser user) {
    _userController.add(user);
  }

  void _updateUsers(List<User> userList) {
    final newUsers = {
      ...users ?? {},
      for (var user in userList) user.id: user,
    };
    _usersController.add(newUsers);
  }

  void _updateUser(User user) => _updateUsers([user]);

  /// The current user
  OwnUser get user => _userController.value;

  /// The current user as a stream
  Stream<OwnUser> get userStream => _userController.stream;

  /// The current user
  Map<String, User> get users => _usersController.value;

  /// The current user as a stream
  Stream<Map<String, User>> get usersStream => _usersController.stream;

  /// The current unread channels count
  int get unreadChannels => _unreadChannelsController.value;

  /// The current unread channels count as a stream
  Stream<int> get unreadChannelsStream => _unreadChannelsController.stream;

  /// The current total unread messages count
  int get totalUnreadCount => _totalUnreadCountController.value;

  /// The current total unread messages count as a stream
  Stream<int> get totalUnreadCountStream => _totalUnreadCountController.stream;

  /// The current list of channels in memory as a stream
  Stream<Map<String, Channel>> get channelsStream => _channelsController.stream;

  /// The current list of channels in memory
  Map<String, Channel> get channels => _channelsController.value;

  set channels(Map<String, Channel> v) {
    _channelsController.add(v);
  }

  final BehaviorSubject<Map<String, Channel>> _channelsController =
      BehaviorSubject.seeded({});
  final BehaviorSubject<OwnUser> _userController = BehaviorSubject();
  final BehaviorSubject<Map<String, User>> _usersController =
      BehaviorSubject.seeded({});
  final BehaviorSubject<int> _unreadChannelsController = BehaviorSubject();
  final BehaviorSubject<int> _totalUnreadCountController = BehaviorSubject();

  /// Call this method to dispose this object
  void dispose() {
    _subscriptions.forEach((s) => s.cancel());
    _userController.close();
    _unreadChannelsController.close();
    _totalUnreadCountController.close();
    channels.values.forEach((c) => c.dispose());
    _channelsController.close();
  }
}
