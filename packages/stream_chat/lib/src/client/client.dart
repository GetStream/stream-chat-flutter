// ignore_for_file: unnecessary_getters_setters

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/client/channel.dart';
import 'package:stream_chat/src/client/retry_policy.dart';
import 'package:stream_chat/src/core/api/attachment_file_uploader.dart';
import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/api/stream_chat_api.dart';
import 'package:stream_chat/src/core/error/error.dart';
import 'package:stream_chat/src/core/http/connection_id_manager.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:stream_chat/src/core/models/attachment_file.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/models/filter.dart';
import 'package:stream_chat/src/core/models/member.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/own_user.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/platform_detector/platform_detector.dart';
import 'package:stream_chat/src/core/util/utils.dart';
import 'package:stream_chat/src/db/chat_persistence_client.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:stream_chat/src/ws/connection_status.dart';
import 'package:stream_chat/src/ws/websocket.dart';
import 'package:stream_chat/version.dart';

/// Handler function used for logging records. Function requires a single
/// [LogRecord] as the only parameter.
typedef LogHandlerFunction = void Function(LogRecord record);

final _levelEmojiMapper = {
  Level.INFO: 'ℹ️',
  Level.WARNING: '⚠️',
  Level.SEVERE: '🚨',
};

/// The official Dart client for Stream Chat,
/// a service for building chat applications.
/// This library can be used on any Dart project and on both mobile and web apps
/// with Flutter.
///
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
  /// You should only create the client once and re-use it across your
  /// application.
  StreamChatClient(
    String apiKey, {
    this.logLevel = Level.WARNING,
    this.logHandlerFunction = StreamChatClient.defaultLogHandler,
    RetryPolicy? retryPolicy,
    String? baseURL,
    Duration connectTimeout = const Duration(seconds: 6),
    Duration receiveTimeout = const Duration(seconds: 6),
    StreamChatApi? chatApi,
    WebSocket? ws,
    AttachmentFileUploader? attachmentFileUploader,
  }) {
    logger.info('Initiating new StreamChatClient');

    final options = StreamHttpClientOptions(
      baseUrl: baseURL,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: {'X-Stream-Client': defaultUserAgent},
    );

    _chatApi = chatApi ??
        StreamChatApi(
          apiKey,
          options: options,
          tokenManager: _tokenManager,
          connectionIdManager: _connectionIdManager,
          attachmentFileUploader: attachmentFileUploader,
          logger: detachedLogger('🕸️'),
        );

    _ws = ws ??
        WebSocket(
          apiKey: apiKey,
          baseUrl: options.baseUrl,
          tokenManager: _tokenManager,
          handler: handleEvent,
          logger: detachedLogger('🔌'),
          queryParameters: {'X-Stream-Client': defaultUserAgent},
        );

    _retryPolicy = retryPolicy ??
        RetryPolicy(
          shouldRetry: (_, attempt, __) => attempt < 5,
          retryTimeout: (_, attempt, __) => Duration(seconds: attempt),
        );

    state = ClientState(this);
  }

  late final StreamChatApi _chatApi;
  late final WebSocket _ws;

  /// This client state
  late ClientState state;

  final _tokenManager = TokenManager();
  final _connectionIdManager = ConnectionIdManager();

  set chatPersistenceClient(ChatPersistenceClient? value) {
    _originalChatPersistenceClient = value;
  }

  /// Default user agent for all requests
  static String defaultUserAgent = 'stream-chat-dart-client-'
      '${CurrentPlatform.name}-'
      '${PACKAGE_VERSION.split('+')[0]}';

  /// Additional headers for all requests
  static Map<String, Object?> additionalHeaders = {};

  ChatPersistenceClient? _originalChatPersistenceClient;

  /// Chat persistence client
  ChatPersistenceClient? get chatPersistenceClient => _chatPersistenceClient;

  ChatPersistenceClient? _chatPersistenceClient;

  /// Whether the chat persistence is available or not
  bool get persistenceEnabled => _chatPersistenceClient != null;

  late final RetryPolicy _retryPolicy;

  /// the last dateTime at the which all the channels were synced
  DateTime? _lastSyncedAt;

  /// The retry policy options getter
  RetryPolicy get retryPolicy => _retryPolicy;

  /// By default the Chat client will write all messages with level Warn or
  /// Error to stdout.
  ///
  /// During development you might want to enable more logging information,
  /// you can change the default log level when constructing the client.
  ///
  /// ```dart
  /// final client = StreamChatClient("stream-chat-api-key",
  /// logLevel: Level.INFO);
  /// ```
  final Level logLevel;

  /// Client specific logger instance.
  /// Refer to the class [Logger] to learn more about the specific
  /// implementation.
  late final Logger logger = detachedLogger('📡');

  /// A function that has a parameter of type [LogRecord].
  /// This is called on every new log record.
  /// By default the client will use the handler returned by
  /// [_getDefaultLogHandler].
  /// Setting it you can handle the log messages directly instead of have them
  /// written to stdout,
  /// this is very convenient if you use an error tracking tool or if you want
  /// to centralize your logs into one facility.
  ///
  /// ```dart
  /// myLogHandlerFunction = (LogRecord record) {
  ///  // do something with the record (ie. send it to Sentry or Fabric)
  /// }
  ///
  /// final client = StreamChatClient("stream-chat-api-key",
  /// logHandlerFunction: myLogHandlerFunction);
  ///```
  final LogHandlerFunction logHandlerFunction;

  StreamSubscription<ConnectionStatus>? _connectionStatusSubscription;

  final _eventController = BehaviorSubject<Event>();

  /// Stream of [Event] coming from [_ws] connection
  /// Listen to this or use the [on] method to filter specific event types
  Stream<Event> get eventStream => _eventController.stream;

  final _wsConnectionStatusController =
      BehaviorSubject.seeded(ConnectionStatus.disconnected);

  set _wsConnectionStatus(ConnectionStatus status) =>
      _wsConnectionStatusController.add(status);

  /// The current status value of the [_ws] connection
  ConnectionStatus get wsConnectionStatus =>
      _wsConnectionStatusController.value;

  /// This notifies the connection status of the [_ws] connection.
  /// Listen to this to get notified when the [_ws] tries to reconnect.
  Stream<ConnectionStatus> get wsConnectionStatusStream =>
      _wsConnectionStatusController.stream.distinct();

  /// Default log handler function for the [StreamChatClient] logger.
  static void defaultLogHandler(LogRecord record) {
    print(
      '${record.time} '
      '${_levelEmojiMapper[record.level] ?? record.level.name} '
      '${record.loggerName} ${record.message} ',
    );
    if (record.error != null) print(record.error);
    if (record.stackTrace != null) print(record.stackTrace);
  }

  /// Default logger for the [StreamChatClient].
  Logger detachedLogger(String name) => Logger.detached(name)
    ..level = logLevel
    ..onRecord.listen(logHandlerFunction);

  /// Connects the current user, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  /// Pass [connectWebSocket]: false, if you want to connect to websocket
  /// at a later stage or use the client in connection-less mode
  Future<OwnUser> connectUser(
    User user,
    String token, {
    bool connectWebSocket = true,
  }) =>
      _connectUser(
        user,
        token: Token.fromRawValue(token),
        connectWebSocket: connectWebSocket,
      );

  /// Connects the current user using the [tokenProvider] to fetch the token.
  /// It returns a [Future] that resolves when the connection is setup.
  Future<OwnUser> connectUserWithProvider(
    User user,
    TokenProvider tokenProvider, {
    bool connectWebSocket = true,
  }) =>
      _connectUser(
        user,
        provider: tokenProvider,
        connectWebSocket: connectWebSocket,
      );

  /// Connects the current user with an anonymous id, this triggers a connection
  /// to the API. It returns a [Future] that resolves when the connection is
  /// setup.
  Future<OwnUser> connectAnonymousUser({
    bool connectWebSocket = true,
  }) async {
    final token = Token.anonymous();
    final user = OwnUser(id: token.userId);
    return _connectUser(
      user,
      token: token,
      connectWebSocket: connectWebSocket,
    );
  }

  /// Connects the current user as guest, this triggers a connection to the API.
  /// It returns a [Future] that resolves when the connection is setup.
  Future<OwnUser> connectGuestUser(
    User user, {
    bool connectWebSocket = true,
  }) async {
    final userId = user.id;
    final anonymousToken = Token.anonymous(userId: userId);

    // setting anonymous token so that getGuestUser works
    _tokenManager.setTokenOrProvider(userId, token: anonymousToken);

    final guestUser = await _chatApi.guest.getGuestUser(user);

    // resetting tokenManager after successful request
    _tokenManager.reset();

    final guestUserToken = Token.fromRawValue(guestUser.accessToken);
    return _connectUser(
      guestUser.user,
      token: guestUserToken,
      connectWebSocket: connectWebSocket,
    );
  }

  Future<OwnUser> _connectUser(
    User user, {
    Token? token,
    TokenProvider? provider,
    bool connectWebSocket = true,
  }) async {
    if (_ws.connectionCompleter?.isCompleted == false) {
      throw const StreamChatError(
        'User already getting connected, try calling `disconnectUser` '
        'before trying to connect again',
      );
    }

    logger.info('setting user : ${user.id}');

    await _tokenManager.setTokenOrProvider(
      user.id,
      token: token,
      provider: provider,
    );

    final ownUser = OwnUser.fromUser(user);
    state.currentUser = ownUser;

    if (!connectWebSocket) return ownUser;

    try {
      if (_originalChatPersistenceClient != null) {
        _chatPersistenceClient = _originalChatPersistenceClient;
        await _chatPersistenceClient!.connect(ownUser.id);
      }
      final connectedUser = await openConnection(
        includeUserDetailsInConnectCall: true,
      );
      return state.currentUser = connectedUser;
    } catch (e, stk) {
      if (e is StreamWebSocketError && e.isRetriable) {
        final event = await _chatPersistenceClient?.getConnectionInfo();
        if (event != null) return ownUser.merge(event.me);
      }
      logger.severe('error connecting user : ${ownUser.id}', e, stk);
      rethrow;
    }
  }

  /// Creates a new WebSocket connection with the current user.
  /// If [includeUserDetailsInConnectCall] is true it will include the current
  /// user details in the connect call.
  Future<OwnUser> openConnection({
    bool includeUserDetailsInConnectCall = false,
  }) async {
    assert(
      state.currentUser != null,
      'User is not set on client, '
      'use `connectUser` or `connectAnonymousUser` instead',
    );

    final user = state.currentUser!;

    logger.info('Opening web-socket connection for ${user.id}');

    if (wsConnectionStatus == ConnectionStatus.connecting) {
      throw StreamChatError('Connection already in progress for ${user.id}');
    }

    if (wsConnectionStatus == ConnectionStatus.connected) {
      throw StreamChatError('Connection already available for ${user.id}');
    }

    _wsConnectionStatus = ConnectionStatus.connecting;

    // skipping `ws` seed connection status -> ConnectionStatus.disconnected
    // otherwise `client.wsConnectionStatusStream` will emit in order
    // 1. ConnectionStatus.disconnected -> client seed status
    // 2. ConnectionStatus.connecting -> client connecting status
    // 3. ConnectionStatus.disconnected -> ws seed status
    _connectionStatusSubscription =
        _ws.connectionStatusStream.skip(1).listen(_connectionStatusHandler);

    try {
      final event = await _ws.connect(
        user,
        includeUserDetails: includeUserDetailsInConnectCall,
      );
      return user.merge(event.me);
    } catch (e, stk) {
      logger.severe('error connecting ws', e, stk);
      rethrow;
    }
  }

  /// Disconnects the [_ws] connection,
  /// without removing the user set on client.
  ///
  /// This will not trigger default auto-retry mechanism for reconnection.
  /// You need to call [openConnection] to reconnect to [_ws].
  void closeConnection() {
    if (wsConnectionStatus == ConnectionStatus.disconnected) return;

    logger.info('Closing web-socket connection for ${state.currentUser?.id}');
    _wsConnectionStatus = ConnectionStatus.disconnected;

    _connectionStatusSubscription?.cancel();
    _connectionStatusSubscription = null;

    _ws.disconnect();
  }

  void _handleHealthCheckEvent(Event event) {
    final user = event.me;
    if (user != null) state.currentUser = user;

    final connectionId = event.connectionId;
    if (connectionId != null) {
      _connectionIdManager.setConnectionId(connectionId);
      _chatPersistenceClient?.updateConnectionInfo(event);
    }
  }

  /// Method called to add a new event to the [_eventController].
  void handleEvent(Event event) {
    if (event.type == EventType.healthCheck) {
      return _handleHealthCheckEvent(event);
    }
    state.updateUser(event.user);
    return _eventController.add(event);
  }

  void _connectionStatusHandler(ConnectionStatus status) async {
    final previousState = wsConnectionStatus;
    final currentState = _wsConnectionStatus = status;

    handleEvent(Event(
      type: EventType.connectionChanged,
      online: status == ConnectionStatus.connected,
    ));

    if (currentState == ConnectionStatus.connected &&
        previousState != ConnectionStatus.connected) {
      // connection recovered
      final cids = state.channels.keys.toList(growable: false);
      if (cids.isNotEmpty) {
        await queryChannelsOnline(
          filter: Filter.in_('cid', cids),
          paginationParams: const PaginationParams(limit: 30),
        );
        if (persistenceEnabled) {
          await sync(cids: cids, lastSyncAt: _lastSyncedAt);
        }
      }
      handleEvent(Event(
        type: EventType.connectionRecovered,
        online: true,
      ));
    }
  }

  /// Stream of [Event] coming from [_ws] connection
  /// Pass an eventType as parameter in order to filter just a type of event
  Stream<Event> on([
    String? eventType,
    String? eventType2,
    String? eventType3,
    String? eventType4,
  ]) {
    if (eventType == null) return eventStream;
    return eventStream.where((event) =>
        event.type == eventType ||
        event.type == eventType2 ||
        event.type == eventType3 ||
        event.type == eventType4);
  }

  /// Get the events missed while offline to sync the offline storage
  /// Will automatically fetch [cids] and [lastSyncedAt] if [persistenceEnabled]
  Future<void> sync({List<String>? cids, DateTime? lastSyncAt}) async {
    cids ??= await _chatPersistenceClient?.getChannelCids();
    if (cids == null || cids.isEmpty) {
      return;
    }

    lastSyncAt ??= await _chatPersistenceClient?.getLastSyncAt();
    if (lastSyncAt == null) {
      return;
    }

    try {
      final res = await _chatApi.general.sync(cids, lastSyncAt);
      final events = res.events
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      for (final event in events) {
        logger.fine('event.type: ${event.type}');
        final messageText = event.message?.text;
        if (messageText != null) {
          logger.fine('event.message.text: $messageText');
        }
        handleEvent(event);
      }

      final now = DateTime.now();
      _lastSyncedAt = now;
      _chatPersistenceClient?.updateLastSyncAt(now);
    } catch (e, stk) {
      logger.severe('Error during sync', e, stk);
    }
  }

  final _queryChannelsStreams = <String, Future<List<Channel>>>{};

  /// Requests channels with a given query.
  Stream<List<Channel>> queryChannels({
    Filter? filter,
    List<SortOption<ChannelModel>>? sort,
    bool state = true,
    bool watch = true,
    bool presence = false,
    int? memberLimit,
    int? messageLimit,
    PaginationParams paginationParams = const PaginationParams(),
    bool waitForConnect = true,
  }) async* {
    if (!_connectionIdManager.hasConnectionId) {
      // ignore: parameter_assignments
      watch = false;
    }

    final hash = generateHash([
      filter,
      sort,
      state,
      watch,
      presence,
      memberLimit,
      messageLimit,
      paginationParams,
    ]);

    if (_queryChannelsStreams.containsKey(hash)) {
      yield await _queryChannelsStreams[hash]!;
    } else {
      final channels = await queryChannelsOffline(
        filter: filter,
        sort: sort,
        paginationParams: paginationParams,
      );
      if (channels.isNotEmpty) yield channels;

      try {
        final newQueryChannelsFuture = queryChannelsOnline(
          filter: filter,
          sort: sort,
          state: state,
          watch: watch,
          presence: presence,
          memberLimit: memberLimit,
          messageLimit: messageLimit,
          paginationParams: paginationParams,
          waitForConnect: waitForConnect,
        ).whenComplete(() {
          _queryChannelsStreams.remove(hash);
        });

        _queryChannelsStreams[hash] = newQueryChannelsFuture;

        yield await newQueryChannelsFuture;
      } catch (_) {
        if (channels.isEmpty) rethrow;
      }
    }
  }

  /// Requests channels with a given query from the API.
  Future<List<Channel>> queryChannelsOnline({
    Filter? filter,
    List<SortOption<ChannelModel>>? sort,
    bool state = true,
    bool watch = true,
    bool presence = false,
    int? memberLimit,
    int? messageLimit,
    bool waitForConnect = true,
    PaginationParams paginationParams = const PaginationParams(),
  }) async {
    if (waitForConnect) {
      if (_ws.connectionCompleter?.isCompleted == false) {
        logger.info('awaiting connection completer');
        await _ws.connectionCompleter?.future;
      }
      if (wsConnectionStatus != ConnectionStatus.connected) {
        throw const StreamChatError(
          'You cannot use queryChannels without an active connection. '
          'Please call `connectUser` to connect the client.',
        );
      }
    }

    if (!_connectionIdManager.hasConnectionId) {
      // ignore: parameter_assignments
      watch = false;
    }

    logger.info('Query channel start');
    final res = await _chatApi.channel.queryChannels(
      filter: filter,
      sort: sort,
      state: state,
      watch: watch,
      presence: presence,
      memberLimit: memberLimit,
      messageLimit: messageLimit,
      paginationParams: paginationParams,
    );

    if (res.channels.isEmpty && paginationParams.offset == 0) {
      logger.warning('''
        We could not find any channel for this query.
        Please make sure to take a look at the Flutter tutorial: https://getstream.io/chat/flutter/tutorial
        If your application already has users and channels, you might need to adjust your query channel as explained in the docs https://getstream.io/chat/docs/query_channels/?language=dart
        ''');
      return <Channel>[];
    }

    final channels = res.channels;

    final users = channels
        .expand((it) => it.members ?? <Member>[])
        .map((it) => it.user)
        .toList(growable: false);

    this.state.updateUsers(users);

    logger.info('Got ${res.channels.length} channels from api');

    final updateData = _mapChannelStateToChannel(channels);

    await _chatPersistenceClient?.updateChannelQueries(
      filter,
      channels.map((c) => c.channel!.cid).toList(),
      clearQueryCache: paginationParams.offset == 0,
    );

    this.state.channels = updateData.key;
    return updateData.value;
  }

  /// Requests channels with a given query from the Persistence client.
  Future<List<Channel>> queryChannelsOffline({
    Filter? filter,
    List<SortOption<ChannelModel>>? sort,
    PaginationParams paginationParams = const PaginationParams(),
  }) async {
    final offlineChannels = (await _chatPersistenceClient?.getChannelStates(
          filter: filter,
          sort: sort,
          paginationParams: paginationParams,
        )) ??
        [];
    final updatedData = _mapChannelStateToChannel(offlineChannels);
    state.channels = updatedData.key;
    return updatedData.value;
  }

  MapEntry<Map<String, Channel>, List<Channel>> _mapChannelStateToChannel(
    List<ChannelState> channelStates,
  ) {
    final channels = {...state.channels};
    final newChannels = <Channel>[];
    for (final channelState in channelStates) {
      final channel = channels[channelState.channel!.cid];
      if (channel != null) {
        channel.state?.updateChannelState(channelState);
        newChannels.add(channel);
      } else {
        final newChannel = Channel.fromState(this, channelState);
        if (newChannel.cid != null) {
          channels[newChannel.cid!] = newChannel;
        }
        newChannels.add(newChannel);
      }
    }
    return MapEntry(channels, newChannels);
  }

  /// Requests users with a given query.
  Future<QueryUsersResponse> queryUsers({
    bool? presence,
    Filter? filter,
    List<SortOption>? sort,
    PaginationParams? pagination,
  }) async {
    final response = await _chatApi.user.queryUsers(
      presence: presence ?? _connectionIdManager.hasConnectionId,
      filter: filter,
      sort: sort,
      pagination: pagination,
    );
    state.updateUsers(response.users);
    return response;
  }

  /// Query banned users.
  Future<QueryBannedUsersResponse> queryBannedUsers({
    required Filter filter,
    List<SortOption>? sort,
    PaginationParams? pagination,
  }) =>
      _chatApi.moderation.queryBannedUsers(
        filter: filter,
        sort: sort,
        pagination: pagination,
      );

  /// A message search.
  Future<SearchMessagesResponse> search(
    Filter filter, {
    String? query,
    List<SortOption>? sort,
    PaginationParams? paginationParams,
    Filter? messageFilters,
  }) =>
      _chatApi.general.searchMessages(
        filter,
        query: query,
        sort: sort,
        pagination: paginationParams,
        messageFilters: messageFilters,
      );

  /// Send a [file] to the [channelId] of type [channelType]
  Future<SendFileResponse> sendFile(
    AttachmentFile file,
    String channelId,
    String channelType, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) =>
      _chatApi.fileUploader.sendFile(
        file,
        channelId,
        channelType,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        extraData: extraData,
      );

  /// Send a [image] to the [channelId] of type [channelType]
  Future<SendImageResponse> sendImage(
    AttachmentFile image,
    String channelId,
    String channelType, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) =>
      _chatApi.fileUploader.sendImage(
        image,
        channelId,
        channelType,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
        extraData: extraData,
      );

  /// Delete a file from this channel
  Future<EmptyResponse> deleteFile(
    String url,
    String channelId,
    String channelType, {
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) =>
      _chatApi.fileUploader.deleteFile(
        url,
        channelId,
        channelType,
        cancelToken: cancelToken,
        extraData: extraData,
      );

  /// Delete an image from this channel
  Future<EmptyResponse> deleteImage(
    String url,
    String channelId,
    String channelType, {
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) =>
      _chatApi.fileUploader.deleteImage(
        url,
        channelId,
        channelType,
        cancelToken: cancelToken,
        extraData: extraData,
      );

  /// Replaces the [channelId] of type [ChannelType] data with [data].
  ///
  /// Use [updateChannelPartial] for a partial update.
  Future<UpdateChannelResponse> updateChannel(
    String channelId,
    String channelType,
    Map<String, Object?> data, {
    Message? message,
  }) =>
      _chatApi.channel.updateChannel(
        channelId,
        channelType,
        data,
        message: message,
      );

  /// Partial update for the [channelId] of type [ChannelType]. Sets the
  /// data provided in [set], and removes the attributes given in [unset].
  ///
  /// Use [updateChannel] for a full update.
  Future<PartialUpdateChannelResponse> updateChannelPartial(
    String channelId,
    String channelType, {
    Map<String, Object?>? set,
    List<String>? unset,
  }) =>
      _chatApi.channel.updateChannelPartial(
        channelId,
        channelType,
        set: set,
        unset: unset,
      );

  /// Add a device for Push Notifications.
  Future<EmptyResponse> addDevice(
    String id,
    PushProvider pushProvider, {
    String? pushProviderName,
  }) =>
      _chatApi.device.addDevice(
        id,
        pushProvider,
        pushProviderName: pushProviderName,
      );

  /// Gets a list of user devices.
  Future<ListDevicesResponse> getDevices() => _chatApi.device.getDevices();

  /// Remove a user's device.
  Future<EmptyResponse> removeDevice(String id) =>
      _chatApi.device.removeDevice(id);

  /// Get a development token
  Token devToken(String userId) => Token.development(userId);

  /// Returns a channel client with the given type, id and custom data.
  Channel channel(
    String type, {
    String? id,
    Map<String, Object?>? extraData,
  }) {
    if (id != null && state.channels.containsKey('$type:$id')) {
      return state.channels['$type:$id']!;
    }
    return Channel(this, type, id, extraData: extraData);
  }

  /// Creates a new channel
  Future<ChannelState> createChannel(
    String channelType, {
    String? channelId,
    Map<String, Object?>? channelData,
  }) =>
      queryChannel(
        channelType,
        channelId: channelId,
        state: false,
        channelData: channelData,
      );

  /// watches the provided channel
  /// Creates first if not yet created
  Future<ChannelState> watchChannel(
    String channelType, {
    String? channelId,
    Map<String, Object?>? channelData,
  }) =>
      queryChannel(
        channelType,
        channelId: channelId,
        watch: true,
        channelData: channelData,
      );

  /// Query the API, get messages, members or other channel fields
  /// Creates the channel first if not yet created
  Future<ChannelState> queryChannel(
    String channelType, {
    bool state = true,
    bool watch = false,
    bool presence = false,
    String? channelId,
    Map<String, Object?>? channelData,
    PaginationParams? messagesPagination,
    PaginationParams? membersPagination,
    PaginationParams? watchersPagination,
  }) =>
      _chatApi.channel.queryChannel(
        channelType,
        channelId: channelId,
        channelData: channelData,
        state: state,
        watch: watch,
        presence: presence,
        messagesPagination: messagesPagination,
        membersPagination: membersPagination,
        watchersPagination: watchersPagination,
      );

  /// Query channel members
  Future<QueryMembersResponse> queryMembers(
    String channelType, {
    Filter? filter,
    String? channelId,
    List<Member>? members,
    List<SortOption>? sort,
    PaginationParams? pagination,
  }) =>
      _chatApi.general.queryMembers(
        channelType,
        channelId: channelId,
        filter: filter,
        members: members,
        sort: sort,
        pagination: pagination,
      );

  /// Hides the channel from [queryChannels] for the user
  /// until a message is added If [clearHistory] is set to true - all messages
  /// will be removed for the user
  Future<EmptyResponse> hideChannel(
    String channelId,
    String channelType, {
    bool clearHistory = false,
  }) =>
      _chatApi.channel.hideChannel(
        channelId,
        channelType,
        clearHistory: clearHistory,
      );

  /// Removes the hidden status for the channel
  Future<EmptyResponse> showChannel(
    String channelId,
    String channelType,
  ) =>
      _chatApi.channel.showChannel(
        channelId,
        channelType,
      );

  /// Delete this channel. Messages are permanently removed.
  Future<EmptyResponse> deleteChannel(
    String channelId,
    String channelType,
  ) =>
      _chatApi.channel.deleteChannel(
        channelId,
        channelType,
      );

  /// Removes all messages from the channel up to [truncatedAt] or now if
  /// [truncatedAt] is not provided.
  /// If [skipPush] is true, no push notification will be sent.
  /// [Message] is the system message that will be sent to the channel.
  Future<EmptyResponse> truncateChannel(
    String channelId,
    String channelType, {
    Message? message,
    bool? skipPush,
    DateTime? truncatedAt,
  }) =>
      _chatApi.channel.truncateChannel(
        channelId,
        channelType,
        message: message,
        skipPush: skipPush,
        truncatedAt: truncatedAt,
      );

  /// Mutes the channel
  Future<EmptyResponse> muteChannel(
    String channelCid, {
    Duration? expiration,
  }) =>
      _chatApi.moderation.muteChannel(
        channelCid,
        expiration: expiration,
      );

  /// Unmutes the channel
  Future<EmptyResponse> unmuteChannel(String channelCid) =>
      _chatApi.moderation.unmuteChannel(channelCid);

  /// Accept invitation to the channel
  Future<AcceptInviteResponse> acceptChannelInvite(
    String channelId,
    String channelType, {
    Message? message,
  }) =>
      _chatApi.channel.acceptChannelInvite(
        channelId,
        channelType,
        message: message,
      );

  /// Reject invitation to the channel
  Future<RejectInviteResponse> rejectChannelInvite(
    String channelId,
    String channelType, {
    Message? message,
  }) =>
      _chatApi.channel.rejectChannelInvite(
        channelId,
        channelType,
        message: message,
      );

  /// Add members to the channel
  Future<AddMembersResponse> addChannelMembers(
    String channelId,
    String channelType,
    List<String> memberIds, {
    Message? message,
  }) =>
      _chatApi.channel.addMembers(
        channelId,
        channelType,
        memberIds,
        message: message,
      );

  /// Remove members from the channel
  Future<RemoveMembersResponse> removeChannelMembers(
    String channelId,
    String channelType,
    List<String> memberIds, {
    Message? message,
  }) =>
      _chatApi.channel.removeMembers(
        channelId,
        channelType,
        memberIds,
        message: message,
      );

  /// Invite members to the channel
  Future<InviteMembersResponse> inviteChannelMembers(
    String channelId,
    String channelType,
    List<String> memberIds, {
    Message? message,
  }) =>
      _chatApi.channel.inviteChannelMembers(
        channelId,
        channelType,
        memberIds,
        message: message,
      );

  /// Stop watching the channel
  Future<EmptyResponse> stopChannelWatching(
    String channelId,
    String channelType,
  ) =>
      _chatApi.channel.stopWatching(
        channelId,
        channelType,
      );

  /// Send action for a specific message of this channel
  Future<SendActionResponse> sendAction(
    String channelId,
    String channelType,
    String messageId,
    Map<String, Object?> formData,
  ) =>
      _chatApi.message.sendAction(
        channelId,
        channelType,
        messageId,
        formData,
      );

  /// Mark [channelId] of type [channelType] all messages as read
  /// Optionally provide a [messageId] if you want to mark a
  /// particular message as read
  Future<EmptyResponse> markChannelRead(
    String channelId,
    String channelType, {
    String? messageId,
  }) =>
      _chatApi.channel.markRead(
        channelId,
        channelType,
        messageId: messageId,
      );

  /// Update or Create the given user object.
  Future<UpdateUsersResponse> updateUser(User user) => updateUsers([user]);

  /// Batch update a list of users
  Future<UpdateUsersResponse> updateUsers(List<User> users) =>
      _chatApi.user.updateUsers(users);

  /// Partially update the given user with [id].
  /// Use [set] to define values to be set.
  /// Use [unset] to define values to be unset.
  Future<UpdateUsersResponse> partialUpdateUser(
    String id, {
    Map<String, Object?>? set,
    List<String>? unset,
  }) {
    final user = PartialUpdateUserRequest(
      id: id,
      set: set,
      unset: unset,
    );
    return partialUpdateUsers([user]);
  }

  /// Batch partial updates the [users].
  Future<UpdateUsersResponse> partialUpdateUsers(
    List<PartialUpdateUserRequest> users,
  ) =>
      _chatApi.user.partialUpdateUsers(users);

  /// Bans a user from all channels
  Future<EmptyResponse> banUser(
    String targetUserId, [
    Map<String, dynamic> options = const {},
  ]) =>
      _chatApi.moderation.banUser(
        targetUserId,
        options: options,
      );

  /// Remove global ban for a user
  Future<EmptyResponse> unbanUser(
    String targetUserId, [
    Map<String, dynamic> options = const {},
  ]) =>
      _chatApi.moderation.unbanUser(
        targetUserId,
        options: options,
      );

  /// Shadow bans a user
  Future<EmptyResponse> shadowBan(
    String targetID, [
    Map<String, dynamic> options = const {},
  ]) =>
      banUser(targetID, {
        'shadow': true,
        ...options,
      });

  /// Removes shadow ban from a user
  Future<EmptyResponse> removeShadowBan(
    String targetID, [
    Map<String, dynamic> options = const {},
  ]) =>
      unbanUser(targetID, {
        'shadow': true,
        ...options,
      });

  /// Mutes a user
  Future<EmptyResponse> muteUser(String userId) =>
      _chatApi.moderation.muteUser(userId);

  /// Unmutes a user
  Future<EmptyResponse> unmuteUser(String userId) =>
      _chatApi.moderation.unmuteUser(userId);

  /// Flag a message
  Future<EmptyResponse> flagMessage(String messageId) =>
      _chatApi.moderation.flagMessage(messageId);

  /// Unflag a message
  Future<EmptyResponse> unflagMessage(String messageId) =>
      _chatApi.moderation.unflagMessage(messageId);

  /// Flag a user
  Future<EmptyResponse> flagUser(String userId) =>
      _chatApi.moderation.flagUser(userId);

  /// Unflag a message
  Future<EmptyResponse> unflagUser(String userId) =>
      _chatApi.moderation.unflagUser(userId);

  /// Mark all channels for this user as read
  Future<EmptyResponse> markAllRead() => _chatApi.channel.markAllRead();

  /// Send an event to a particular channel
  Future<EmptyResponse> sendEvent(
    String channelId,
    String channelType,
    Event event,
  ) =>
      _chatApi.channel.sendEvent(
        channelId,
        channelType,
        event,
      );

  /// Send a [reactionType] for this [messageId]
  /// Set [enforceUnique] to true to remove the existing user reaction
  Future<SendReactionResponse> sendReaction(
    String messageId,
    String reactionType, {
    int score = 1,
    Map<String, Object?> extraData = const {},
    bool enforceUnique = false,
  }) {
    final _extraData = {
      'score': score,
      ...extraData,
    };

    return _chatApi.message.sendReaction(
      messageId,
      reactionType,
      extraData: _extraData,
      enforceUnique: enforceUnique,
    );
  }

  /// Delete a [reactionType] from this [messageId]
  Future<EmptyResponse> deleteReaction(
    String messageId,
    String reactionType,
  ) =>
      _chatApi.message.deleteReaction(
        messageId,
        reactionType,
      );

  /// Sends the message to the given channel
  Future<SendMessageResponse> sendMessage(
    Message message,
    String channelId,
    String channelType, {
    bool skipPush = false,
    bool skipEnrichUrl = false,
  }) =>
      _chatApi.message.sendMessage(
        channelId,
        channelType,
        message,
        skipPush: skipPush,
        skipEnrichUrl: skipEnrichUrl,
      );

  /// Lists all the message replies for the [parentId]
  Future<QueryRepliesResponse> getReplies(
    String parentId, {
    PaginationParams? options,
  }) =>
      _chatApi.message.getReplies(
        parentId,
        options: options,
      );

  /// Get all the reactions for a [messageId]
  Future<QueryReactionsResponse> getReactions(
    String messageId, {
    PaginationParams? pagination,
  }) =>
      _chatApi.message.getReactions(
        messageId,
        pagination: pagination,
      );

  /// Update the given message
  Future<UpdateMessageResponse> updateMessage(
    Message message, {
    bool skipEnrichUrl = false,
  }) =>
      _chatApi.message.updateMessage(
        message,
        skipEnrichUrl: skipEnrichUrl,
      );

  /// Partially update the given [messageId]
  /// Use [set] to define values to be set
  /// Use [unset] to define values to be unset
  Future<UpdateMessageResponse> partialUpdateMessage(
    String messageId, {
    Map<String, Object?>? set,
    List<String>? unset,
    bool skipEnrichUrl = false,
  }) =>
      _chatApi.message.partialUpdateMessage(
        messageId,
        set: set,
        unset: unset,
        skipEnrichUrl: skipEnrichUrl,
      );

  /// Deletes the given message
  Future<EmptyResponse> deleteMessage(String messageId, {bool? hard}) async {
    final response =
        await _chatApi.message.deleteMessage(messageId, hard: hard);
    if (hard == true) {
      await _chatPersistenceClient?.deleteMessageById(messageId);
    }
    return response;
  }

  /// Get a message by [messageId]
  Future<GetMessageResponse> getMessage(String messageId) =>
      _chatApi.message.getMessage(messageId);

  /// Retrieves a list of messages by [messageIDs]
  /// from the given [channelId] of type [channelType]
  Future<GetMessagesByIdResponse> getMessagesById(
    String channelId,
    String channelType,
    List<String> messageIDs,
  ) =>
      _chatApi.message.getMessagesById(
        channelId,
        channelType,
        messageIDs,
      );

  /// Translates the [messageId] in provided [language]
  Future<TranslateMessageResponse> translateMessage(
    String messageId,
    String language,
  ) =>
      _chatApi.message.translateMessage(
        messageId,
        language,
      );

  /// Enables slow mode
  Future<PartialUpdateChannelResponse> enableSlowdown(
    String channelId,
    String channelType,
    int cooldown,
  ) async =>
      _chatApi.channel.enableSlowdown(
        channelId,
        channelType,
        cooldown,
      );

  /// Disables slow mode
  Future<PartialUpdateChannelResponse> disableSlowdown(
    String channelId,
    String channelType,
  ) async =>
      _chatApi.channel.disableSlowdown(
        channelId,
        channelType,
      );

  /// Pins provided message
  /// [timeoutOrExpirationDate] can either be a [DateTime] or a value in seconds
  /// to be added to [DateTime.now]
  Future<UpdateMessageResponse> pinMessage(
    String messageId, {
    Object? /*num|DateTime*/ timeoutOrExpirationDate,
  }) {
    assert(() {
      if (timeoutOrExpirationDate is! DateTime &&
          timeoutOrExpirationDate != null &&
          timeoutOrExpirationDate is! num) {
        throw ArgumentError('Invalid timeout or Expiration date');
      }
      return true;
    }(), 'Check for invalid timeout or expiration date');

    DateTime? pinExpires;
    if (timeoutOrExpirationDate is DateTime) {
      pinExpires = timeoutOrExpirationDate;
    } else if (timeoutOrExpirationDate is num) {
      pinExpires = DateTime.now().add(
        Duration(seconds: timeoutOrExpirationDate.toInt()),
      );
    }
    return partialUpdateMessage(
      messageId,
      set: {
        'pinned': true,
        'pin_expires': pinExpires?.toUtc().toIso8601String(),
      },
    );
  }

  /// Unpins provided message
  Future<UpdateMessageResponse> unpinMessage(String messageId) =>
      partialUpdateMessage(
        messageId,
        set: {
          'pinned': false,
        },
      );

  /// Get OpenGraph data of the given [url].
  Future<OGAttachmentResponse> enrichUrl(String url) =>
      _chatApi.general.enrichUrl(url);

  /// Closes the [_ws] connection and resets the [state]
  /// If [flushChatPersistence] is true the client deletes all offline
  /// user's data.
  Future<void> disconnectUser({bool flushChatPersistence = false}) async {
    logger.info('Disconnecting user : ${state.currentUser?.id}');

    // resetting state
    state.dispose();
    state = ClientState(this);
    _lastSyncedAt = null;

    // resetting credentials
    _tokenManager.reset();
    _connectionIdManager.reset();

    // disconnecting persistence client
    await _chatPersistenceClient?.disconnect(flush: flushChatPersistence);
    _chatPersistenceClient = null;

    // closing web-socket connection
    closeConnection();
  }

  /// Call this function to dispose the client
  Future<void> dispose() async {
    logger.info('Disposing new StreamChatClient');

    // disposing state
    state.dispose();

    // disconnecting persistence client
    await _chatPersistenceClient?.disconnect();

    // closing web-socket connection
    closeConnection();

    await _eventController.close();
    await _wsConnectionStatusController.close();
  }
}

/// The class that handles the state of the channel listening to the events
class ClientState {
  /// Creates a new instance listening to events and updating the state
  ClientState(this._client) {
    _subscriptions.addAll([
      _client
          .on()
          .where((event) =>
              event.me != null && event.type != EventType.healthCheck)
          .map((e) => e.me!)
          .listen((user) => currentUser = currentUser?.merge(user) ?? user),
      _client
          .on()
          .map((event) => event.unreadChannels)
          .whereType<int>()
          .listen((count) {
        currentUser = currentUser?.copyWith(unreadChannels: count);
      }),
      _client
          .on()
          .map((event) => event.totalUnreadCount)
          .whereType<int>()
          .listen((count) {
        currentUser = currentUser?.copyWith(totalUnreadCount: count);
      }),
    ]);

    _listenChannelDeleted();

    _listenChannelHidden();

    _listenUserUpdated();

    _listenAllChannelsRead();
  }

  final _subscriptions = <StreamSubscription>[];

  /// Used internally for optimistic update of unread count
  set totalUnreadCount(int unreadCount) {
    _totalUnreadCountController.add(unreadCount);
  }

  void _listenChannelHidden() {
    _subscriptions.add(_client.on(EventType.channelHidden).listen((event) {
      final cid = event.cid;

      if (cid != null) {
        _client.chatPersistenceClient?.deleteChannels([cid]);
      }
      channels = channels..removeWhere((cid, ch) => cid == event.cid);
    }));
  }

  void _listenUserUpdated() {
    _subscriptions.add(_client.on(EventType.userUpdated).listen((event) {
      if (event.user!.id == currentUser!.id) {
        currentUser = OwnUser.fromJson(event.user!.toJson());
      }
      updateUser(event.user);
    }));
  }

  void _listenAllChannelsRead() {
    _subscriptions
        .add(_client.on(EventType.notificationMarkRead).listen((event) {
      if (event.cid == null) {
        channels.forEach((key, value) {
          value.state?.unreadCount = 0;
        });
      }
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
      final eventChannel = event.channel!;
      await _client.chatPersistenceClient?.deleteChannels([eventChannel.cid]);
      channels[eventChannel.cid]?.dispose();
      channels = channels..remove(eventChannel.cid);
    }));
  }

  final StreamChatClient _client;

  /// Sets the user currently interacting with the client
  /// note: this fully overrides the [currentUser]
  set currentUser(OwnUser? user) {
    _computeUnreadCounts(user);
    _currentUserController.add(user);
  }

  /// Update all the [users] with the provided [userList]
  void updateUsers(List<User?> userList) {
    final newUsers = {
      ...users,
      for (var user in userList)
        if (user != null) user.id: user,
    };
    _usersController.add(newUsers);
  }

  /// Update the passed [user] in state
  void updateUser(User? user) => updateUsers([user]);

  /// The current user
  OwnUser? get currentUser => _currentUserController.valueOrNull;

  /// The current user as a stream
  Stream<OwnUser?> get currentUserStream => _currentUserController.stream;

  // coverage:ignore-end

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

  set channels(Map<String, Channel> channelMap) {
    final newChannels = {...channels, ...channelMap};
    _channelsController.add(newChannels);
  }

  void _computeUnreadCounts(OwnUser? user) {
    final totalUnreadCount = user?.totalUnreadCount;
    if (totalUnreadCount != null) {
      _totalUnreadCountController.add(totalUnreadCount);
    }

    final unreadChannels = user?.unreadChannels;
    if (unreadChannels != null) {
      _unreadChannelsController.add(unreadChannels);
    }
  }

  final _channelsController = BehaviorSubject<Map<String, Channel>>.seeded({});
  final _currentUserController = BehaviorSubject<OwnUser?>();
  final _usersController = BehaviorSubject<Map<String, User>>.seeded({});
  final _unreadChannelsController = BehaviorSubject<int>.seeded(0);
  final _totalUnreadCountController = BehaviorSubject<int>.seeded(0);

  /// Call this method to dispose this object
  void dispose() {
    _subscriptions.forEach((s) => s.cancel());
    _currentUserController.close();
    _unreadChannelsController.close();
    _totalUnreadCountController.close();
    channels.values.forEach((c) => c.dispose());
    _channelsController.close();
  }
}
