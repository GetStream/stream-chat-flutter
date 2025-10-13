import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/client/channel.dart';
import 'package:stream_chat/src/client/retry_policy.dart';
import 'package:stream_chat/src/core/api/attachment_file_uploader.dart';
import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/api/sort_order.dart';
import 'package:stream_chat/src/core/api/stream_chat_api.dart';
import 'package:stream_chat/src/core/error/error.dart';
import 'package:stream_chat/src/core/http/connection_id_manager.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/http/system_environment_manager.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:stream_chat/src/core/models/attachment_file.dart';
import 'package:stream_chat/src/core/models/banned_user.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/draft.dart';
import 'package:stream_chat/src/core/models/draft_message.dart';
import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/models/filter.dart';
import 'package:stream_chat/src/core/models/member.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/message_reminder.dart';
import 'package:stream_chat/src/core/models/own_user.dart';
import 'package:stream_chat/src/core/models/poll.dart';
import 'package:stream_chat/src/core/models/poll_option.dart';
import 'package:stream_chat/src/core/models/poll_vote.dart';
import 'package:stream_chat/src/core/models/push_preference.dart';
import 'package:stream_chat/src/core/models/thread.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/utils.dart';
import 'package:stream_chat/src/db/chat_persistence_client.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:stream_chat/src/system_environment.dart';
import 'package:stream_chat/src/ws/connection_status.dart';
import 'package:stream_chat/src/ws/websocket.dart';
import 'package:stream_chat/version.dart';
import 'package:synchronized/synchronized.dart';

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
    String? baseWsUrl,
    Duration connectTimeout = const Duration(seconds: 6),
    Duration receiveTimeout = const Duration(seconds: 6),
    StreamChatApi? chatApi,
    WebSocket? ws,
    AttachmentFileUploaderProvider attachmentFileUploaderProvider =
        StreamAttachmentFileUploader.new,
    Iterable<Interceptor>? chatApiInterceptors,
    HttpClientAdapter? httpClientAdapter,
  }) {
    logger.info('Initiating new StreamChatClient');

    final options = StreamHttpClientOptions(
      baseUrl: baseURL,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );

    _chatApi = chatApi ??
        StreamChatApi(
          apiKey,
          options: options,
          tokenManager: _tokenManager,
          connectionIdManager: _connectionIdManager,
          systemEnvironmentManager: _systemEnvironmentManager,
          attachmentFileUploaderProvider: attachmentFileUploaderProvider,
          logger: detachedLogger('🕸️'),
          interceptors: chatApiInterceptors,
          httpClientAdapter: httpClientAdapter,
        );

    _ws = ws ??
        WebSocket(
          apiKey: apiKey,
          baseUrl: baseWsUrl ?? options.baseUrl,
          tokenManager: _tokenManager,
          systemEnvironmentManager: _systemEnvironmentManager,
          handler: handleEvent,
          logger: detachedLogger('🔌'),
        );

    _retryPolicy = retryPolicy ??
        RetryPolicy(
          shouldRetry: (_, __, error) {
            return error is StreamChatNetworkError && error.isRetriable;
          },
        );

    _connectionStatusSubscription = wsConnectionStatusStream.pairwise().listen(
      (statusPair) {
        final [prevStatus, currStatus] = statusPair;
        return _onConnectionStatusChanged(prevStatus, currStatus);
      },
    );

    state = ClientState(this);
  }

  late final StreamChatApi _chatApi;
  late final WebSocket _ws;

  /// This client state
  late ClientState state;

  final _tokenManager = TokenManager();
  final _connectionIdManager = ConnectionIdManager();
  static final _systemEnvironmentManager = SystemEnvironmentManager();

  /// Updates the system environment information used by the client.
  ///
  /// It allows you to set environment-specific information that will be
  /// included in API requests, such as the application name, platform details,
  /// and version information.
  ///
  /// Example:
  /// ```dart
  /// client.updateSystemEnvironment(
  ///   SystemEnvironment(
  ///     name: 'my_app',
  ///     version: '1.0.0',
  ///   ),
  /// );
  /// ```
  ///
  /// See [SystemEnvironment] for more information on the available fields.
  void updateSystemEnvironment(SystemEnvironment environment) {
    _systemEnvironmentManager.updateEnvironment(environment);
  }

  /// Default user agent for all requests
  static String defaultUserAgent = _systemEnvironmentManager.userAgent;

  /// Additional headers for all requests
  static Map<String, Object?> additionalHeaders = {};

  /// The current package version
  static const packageVersion = PACKAGE_VERSION;

  /// Chat persistence client
  ChatPersistenceClient? chatPersistenceClient;

  /// Returns `True` if the [chatPersistenceClient] is available and connected.
  /// Otherwise, returns `False`.
  bool get persistenceEnabled {
    final client = chatPersistenceClient;
    return client != null && client.isConnected;
  }

  late final RetryPolicy _retryPolicy;

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

  StreamSubscription<List<ConnectionStatus>>? _connectionStatusSubscription;

  final _eventController = PublishSubject<Event>();

  /// Stream of [Event] coming from [_ws] connection
  /// Listen to this or use the [on] method to filter specific event types
  Stream<Event> get eventStream => _eventController.stream.map(
        // If the poll vote is an answer, we should emit a different event
        // to make it easier to handle in the state.
        (event) => switch ((event.type, event.pollVote?.isAnswer == true)) {
          (EventType.pollVoteCasted || EventType.pollVoteChanged, true) =>
            event.copyWith(type: EventType.pollAnswerCasted),
          (EventType.pollVoteRemoved, true) =>
            event.copyWith(type: EventType.pollAnswerRemoved),
          _ => event,
        },
      );

  /// The current status value of the [_ws] connection
  ConnectionStatus get wsConnectionStatus => _ws.connectionStatus;

  /// This notifies the connection status of the [_ws] connection.
  /// Listen to this to get notified when the [_ws] tries to reconnect.
  Stream<ConnectionStatus> get wsConnectionStatusStream {
    return _ws.connectionStatusStream.distinct();
  }

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

    try {
      // Connect to persistence client if its set.
      if (chatPersistenceClient != null) {
        await openPersistenceConnection(ownUser);
      }

      // Connect to websocket if [connectWebSocket] is true.
      //
      // This is useful when you want to connect to websocket
      // at a later stage or use the client in connection-less mode.
      if (connectWebSocket) {
        final connectedUser = await openConnection(
          includeUserDetailsInConnectCall: true,
        );
        state.currentUser = connectedUser;
      }

      return state.currentUser!;
    } catch (e, stk) {
      if (e is StreamWebSocketError && e.isRetriable) {
        final event = await chatPersistenceClient?.getConnectionInfo();
        if (event != null) return ownUser.merge(event.me);
      }
      logger.severe('error connecting user : ${ownUser.id}', e, stk);
      rethrow;
    }
  }

  /// Connects the [chatPersistenceClient] to the given [user].
  Future<void> openPersistenceConnection(User user) async {
    final client = chatPersistenceClient;
    if (client == null) {
      throw const StreamChatError('Chat persistence client is not set');
    }

    if (client.isConnected) {
      // If the persistence client is already connected to the userId,
      // we don't need to connect again.
      if (client.userId == user.id) return;

      throw const StreamChatError('''
        Chat persistence client is already connected to a different user,
        please close the connection before connecting a new one.''');
    }

    // Connect the persistence client to the userId.
    return client.connect(user.id);
  }

  /// Disconnects the [chatPersistenceClient] from the current user.
  Future<void> closePersistenceConnection({bool flush = false}) async {
    final client = chatPersistenceClient;
    // If the persistence client is never connected, we don't need to close it.
    if (client == null || !client.isConnected) {
      logger.info('Chat persistence client is not connected');
      return;
    }

    // Disconnect the persistence client.
    return client.disconnect(flush: flush);
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

    try {
      final event = await _ws.connect(
        user,
        includeUserDetails: includeUserDetailsInConnectCall,
      );

      // Start listening to events
      state.subscribeToEvents();

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
    logger.info('Closing web-socket connection for ${state.currentUser?.id}');

    // Stop listening to events
    state.cancelEventSubscription();

    _ws.disconnect();
  }

  void _handleHealthCheckEvent(Event event) {
    final user = event.me;
    if (user != null) state.currentUser = user;

    final connectionId = event.connectionId;
    if (connectionId != null) {
      _connectionIdManager.setConnectionId(connectionId);
      chatPersistenceClient?.updateConnectionInfo(event);
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

  void _onConnectionStatusChanged(
    ConnectionStatus prevStatus,
    ConnectionStatus currStatus,
  ) async {
    // If the status hasn't changed, we don't need to do anything.
    if (prevStatus == currStatus) return;

    final wasConnected = prevStatus == ConnectionStatus.connected;
    final isConnected = currStatus == ConnectionStatus.connected;

    // Notify the connection status change event
    handleEvent(Event(
      type: EventType.connectionChanged,
      online: isConnected,
    ));

    final connectionRecovered = !wasConnected && isConnected;

    if (connectionRecovered) {
      // connection recovered
      final cids = [...state.channels.keys.toSet()];
      if (cids.isNotEmpty) {
        await queryChannelsOnline(
          filter: Filter.in_('cid', cids),
          paginationParams: const PaginationParams(limit: 30),
        );

        // Sync the persistence client if available
        if (persistenceEnabled) await sync(cids: cids);
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
    if (eventType == null || eventType == EventType.any) return eventStream;
    return eventStream.where((event) =>
        event.type == eventType ||
        event.type == eventType2 ||
        event.type == eventType3 ||
        event.type == eventType4);
  }

  // Lock to make sure only one sync process is running at a time.
  final _syncLock = Lock();

  /// Get the events missed while offline to sync the offline storage
  /// Will automatically fetch [cids] and [lastSyncedAt] if [persistenceEnabled]
  Future<void> sync({List<String>? cids, DateTime? lastSyncAt}) {
    return _syncLock.synchronized(() async {
      final channels = cids ?? await chatPersistenceClient?.getChannelCids();
      if (channels == null || channels.isEmpty) return;

      final syncAt = lastSyncAt ?? await chatPersistenceClient?.getLastSyncAt();
      if (syncAt == null) {
        logger.info('Fresh sync start: lastSyncAt initialized to now.');
        return chatPersistenceClient?.updateLastSyncAt(DateTime.now());
      }

      try {
        logger.info('Syncing events since $syncAt for channels: $channels');

        final res = await _chatApi.general.sync(channels, syncAt);
        final events = res.events.sorted(
          (a, b) => a.createdAt.compareTo(b.createdAt),
        );

        for (final event in events) {
          logger.fine('Syncing event: ${event.type}');
          handleEvent(event);
        }

        final updatedSyncAt = events.lastOrNull?.createdAt ?? DateTime.now();
        return chatPersistenceClient?.updateLastSyncAt(updatedSyncAt);
      } catch (error, stk) {
        // If we got a 400 error, it means that either the sync time is too
        // old or the channel list is too long or too many events need to be
        // synced. In this case, we should just flush the persistence client
        // and start over.
        if (error is StreamChatNetworkError && error.statusCode == 400) {
          logger.warning(
            'Failed to sync events due to stale or oversized state. '
            'Resetting the persistence client to enable a fresh start.',
          );

          await chatPersistenceClient?.flush();
          return chatPersistenceClient?.updateLastSyncAt(DateTime.now());
        }

        logger.warning('Error syncing events', error, stk);
      }
    });
  }

  final _queryChannelsStreams = <String, Future<List<Channel>>>{};

  /// Requests channels with a given query.
  Stream<List<Channel>> queryChannels({
    Filter? filter,
    SortOrder<ChannelState>? channelStateSort,
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
      channelStateSort,
      state,
      watch,
      presence,
      memberLimit,
      messageLimit,
      paginationParams,
    ]);

    // Return results from cache if available
    if (_queryChannelsStreams.containsKey(hash)) {
      try {
        yield await _queryChannelsStreams[hash]!;
        return;
      } catch (e, stk) {
        logger.severe('Error retrieving cached query results', e, stk);
        // Cache is invalid, continue with fresh query
        _queryChannelsStreams.remove(hash);
      }
    }

    // Get offline results first
    var offlineChannels = <Channel>[];
    try {
      offlineChannels = await queryChannelsOffline(
        filter: filter,
        channelStateSort: channelStateSort,
        paginationParams: paginationParams,
      );

      if (offlineChannels.isNotEmpty) yield offlineChannels;
    } catch (e, stk) {
      logger.warning('Error querying channels offline', e, stk);
      // Continue to online query even if offline fails
    }

    try {
      final newQueryChannelsFuture = queryChannelsOnline(
        filter: filter,
        sort: channelStateSort,
        state: state,
        watch: watch,
        presence: presence,
        memberLimit: memberLimit,
        messageLimit: messageLimit,
        paginationParams: paginationParams,
        waitForConnect: waitForConnect,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          logger.warning('Online channel query timed out');
          throw TimeoutException('Channel query timed out');
        },
      ).whenComplete(() {
        // Always clean up cache reference when done
        _queryChannelsStreams.remove(hash);
      });

      // Store the future in cache
      _queryChannelsStreams[hash] = newQueryChannelsFuture;

      yield await newQueryChannelsFuture;
    } catch (e, stk) {
      logger.severe('Error querying channels online', e, stk);
      // Only rethrow if we have no channels to show the user
      if (offlineChannels.isEmpty) rethrow;
    }
  }

  /// Returns a token associated with the [callId].
  @Deprecated('Will be removed in the next major version')
  Future<CallTokenPayload> getCallToken(String callId) async =>
      _chatApi.call.getCallToken(callId);

  /// Creates a new call.
  @Deprecated('Will be removed in the next major version')
  Future<CreateCallPayload> createCall({
    required String callId,
    required String callType,
    required String channelType,
    required String channelId,
  }) {
    return _chatApi.call.createCall(
      callId: callId,
      callType: callType,
      channelType: channelType,
      channelId: channelId,
    );
  }

  /// Requests channels with a given query from the API.
  Future<List<Channel>> queryChannelsOnline({
    Filter? filter,
    SortOrder<ChannelState>? sort,
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

    await chatPersistenceClient?.updateChannelQueries(
      filter,
      channels.map((c) => c.channel!.cid).toList(),
      // Clear the query cache if we are refreshing.
      clearQueryCache: (paginationParams.offset ?? 0) == 0,
    );

    this.state.addChannels(updateData.key);
    return updateData.value;
  }

  /// Requests channels with a given query from the Persistence client.
  Future<List<Channel>> queryChannelsOffline({
    Filter? filter,
    SortOrder<ChannelState>? channelStateSort,
    PaginationParams paginationParams = const PaginationParams(),
  }) async {
    final offlineChannels = (await chatPersistenceClient?.getChannelStates(
          filter: filter,
          channelStateSort: channelStateSort,
          paginationParams: paginationParams,
        )) ??
        [];
    final updatedData = _mapChannelStateToChannel(offlineChannels);
    state.addChannels(updatedData.key);
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
    SortOrder<User>? sort,
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
    SortOrder<BannedUser>? sort,
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
    SortOrder? sort,
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

  /// Set push preferences for the current user.
  ///
  /// This method allows you to configure push notification settings
  /// at both global and channel-specific levels.
  ///
  /// [preferences] - List of push preferences to apply
  ///
  /// Returns [UpsertPushPreferencesResponse] with the updated preferences.
  ///
  /// Example:
  /// ```dart
  /// // Set global push preferences
  /// await client.setPushPreferences([
  ///   const PushPreferenceInput(
  ///     chatLevel: ChatLevelPushPreference.mentions,
  ///     callLevel: CallLevelPushPreference.all,
  ///   ),
  /// ]);
  ///
  /// // Set channel-specific preferences
  /// await client.setPushPreferences([
  ///   const PushPreferenceInput.channel(
  ///     channelCid: 'messaging:general',
  ///     chatLevel: ChatLevelPushPreference.none,
  ///   ),
  ///   const PushPreferenceInput.channel(
  ///     channelCid: 'messaging:support',
  ///     chatLevel: ChatLevelPushPreference.mentions,
  ///   ),
  /// ]);
  ///
  /// // Mix global and channel-specific preferences
  /// await client.setPushPreferences([
  ///   const PushPreferenceInput(
  ///     chatLevel: ChatLevelPushPreference.all,
  ///   ), // Global default
  ///   const PushPreferenceInput.channel(
  ///     channelCid: 'messaging:spam',
  ///     chatLevel: ChatLevelPushPreference.none,
  ///   ),
  /// ]);
  /// ```
  Future<UpsertPushPreferencesResponse> setPushPreferences(
    List<PushPreferenceInput> preferences,
  ) async {
    final res = await _chatApi.device.setPushPreferences(preferences);

    final currentUser = state.currentUser;
    final currentUserId = currentUser?.id;
    if (currentUserId == null) return res;

    // Emit events for updated preferences
    final updatedPushPreference = res.userPreferences[currentUserId];
    if (updatedPushPreference != null) {
      final pushPreferenceUpdatedEvent = Event(
        type: EventType.pushPreferenceUpdated,
        pushPreference: updatedPushPreference,
      );

      handleEvent(pushPreferenceUpdatedEvent);
    }

    // Emit events for updated channel-specific preferences
    final channelPushPreferences = res.userChannelPreferences[currentUserId];
    if (channelPushPreferences != null) {
      for (final MapEntry(:key, :value) in channelPushPreferences.entries) {
        final pushPreferenceUpdatedEvent = Event(
          type: EventType.channelPushPreferenceUpdated,
          cid: key,
          channelPushPreference: value,
        );

        handleEvent(pushPreferenceUpdatedEvent);
      }
    }

    return res;
  }

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
    SortOrder<Member>? sort,
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
    bool hideHistory = false,
  }) =>
      _chatApi.channel.addMembers(
        channelId,
        channelType,
        memberIds,
        message: message,
        hideHistory: hideHistory,
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

  /// Mark [channelId] of type [channelType] all messages as read
  /// Optionally provide a [messageId] if you want to mark a
  /// particular message as read
  Future<EmptyResponse> markChannelUnread(
    String channelId,
    String channelType,
    String messageId,
  ) =>
      _chatApi.channel.markUnread(
        channelId,
        channelType,
        messageId,
      );

  /// Mark the thread with [threadId] in the channel with [channelId] of type
  /// [channelType] as read.
  Future<EmptyResponse> markThreadRead(
    String channelId,
    String channelType,
    String threadId,
  ) =>
      _chatApi.channel.markThreadRead(
        channelId,
        channelType,
        threadId,
      );

  /// Mark the thread with [threadId] in the channel with [channelId] of type
  /// [channelType] as unread.
  Future<EmptyResponse> markThreadUnread(
    String channelId,
    String channelType,
    String threadId,
  ) =>
      _chatApi.channel.markThreadUnread(
        channelId,
        channelType,
        threadId,
      );

  /// Creates a new Poll
  Future<CreatePollResponse> createPoll(Poll poll) =>
      _chatApi.polls.createPoll(poll);

  /// Retrieves a Poll by [pollId]
  Future<GetPollResponse> getPoll(String pollId) =>
      _chatApi.polls.getPoll(pollId);

  /// Updates a Poll
  Future<UpdatePollResponse> updatePoll(Poll poll) =>
      _chatApi.polls.updatePoll(poll);

  /// Partially updates a Poll by [pollId].
  ///
  /// Use [set] to define values to be set.
  /// Use [unset] to define values to be unset.
  Future<UpdatePollResponse> partialUpdatePoll(
    String pollId, {
    Map<String, Object?>? set,
    List<String>? unset,
  }) =>
      _chatApi.polls.partialUpdatePoll(
        pollId,
        set: set,
        unset: unset,
      );

  /// Deletes the Poll by [pollId].
  Future<EmptyResponse> deletePoll(String pollId) =>
      _chatApi.polls.deletePoll(pollId);

  /// Marks the Poll [pollId] as closed.
  Future<UpdatePollResponse> closePoll(String pollId) =>
      partialUpdatePoll(pollId, set: {
        'is_closed': true,
      });

  /// Creates a new Poll Option for the Poll [pollId].
  Future<CreatePollOptionResponse> createPollOption(
    String pollId,
    PollOption option,
  ) =>
      _chatApi.polls.createPollOption(pollId, option);

  /// Retrieves a Poll Option by [optionId] for the Poll [pollId].
  Future<GetPollOptionResponse> getPollOption(
    String pollId,
    String optionId,
  ) =>
      _chatApi.polls.getPollOption(pollId, optionId);

  /// Updates a Poll Option for the Poll [pollId].
  Future<UpdatePollOptionResponse> updatePollOption(
    String pollId,
    PollOption option,
  ) =>
      _chatApi.polls.updatePollOption(pollId, option);

  /// Deletes a Poll Option by [optionId] for the Poll [pollId].
  Future<EmptyResponse> deletePollOption(
    String pollId,
    String optionId,
  ) =>
      _chatApi.polls.deletePollOption(pollId, optionId);

  /// Cast a [vote] for the Poll [pollId].
  Future<CastPollVoteResponse> castPollVote(
    String messageId,
    String pollId, {
    required String optionId,
  }) {
    final vote = PollVote(optionId: optionId);
    return _chatApi.polls.castPollVote(messageId, pollId, vote);
  }

  /// Adds a answer with [answerText] for the Poll [pollId].
  Future<CastPollVoteResponse> addPollAnswer(
    String messageId,
    String pollId, {
    required String answerText,
  }) {
    final vote = PollVote(answerText: answerText);
    return _chatApi.polls.castPollVote(messageId, pollId, vote);
  }

  /// Removes a vote by [voteId] for the Poll [pollId].
  Future<RemovePollVoteResponse> removePollVote(
    String messageId,
    String pollId,
    String voteId,
  ) =>
      _chatApi.polls.removePollVote(messageId, pollId, voteId);

  /// Queries Polls with the given [filter] and [sort] options.
  Future<QueryPollsResponse> queryPolls({
    Filter? filter,
    SortOrder<Poll>? sort,
    PaginationParams pagination = const PaginationParams(),
  }) =>
      _chatApi.polls.queryPolls(
        filter: filter,
        sort: sort,
        pagination: pagination,
      );

  /// Queries Poll Votes for the Poll [pollId] with the given [filter]
  /// and [sort] options.
  Future<QueryPollVotesResponse> queryPollVotes(
    String pollId, {
    Filter? filter,
    SortOrder<PollVote>? sort,
    PaginationParams pagination = const PaginationParams(),
  }) =>
      _chatApi.polls.queryPollVotes(
        pollId,
        filter: filter,
        sort: sort,
        pagination: pagination,
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

  final _userBlockLock = Lock();

  /// Blocks a user with the provided [userId].
  Future<UserBlockResponse> blockUser(String userId) async {
    try {
      final response = await _userBlockLock.synchronized(
        () => _chatApi.user.blockUser(userId),
      );

      final blockedUserId = response.blockedUserId;
      final currentBlockedUserIds = [...?state.currentUser?.blockedUserIds];
      if (!currentBlockedUserIds.contains(blockedUserId)) {
        // Add the new blocked user to the blocked user list.
        state.blockedUserIds = [...currentBlockedUserIds, blockedUserId];
      }

      return response;
    } catch (e, stk) {
      logger.severe('Error blocking user', e, stk);
      rethrow;
    }
  }

  /// Unblocks a previously blocked user with the provided [userId].
  Future<EmptyResponse> unblockUser(String userId) async {
    try {
      final response = await _userBlockLock.synchronized(
        () => _chatApi.user.unblockUser(userId),
      );

      final unblockedUserId = userId;
      final currentBlockedUserIds = [...?state.currentUser?.blockedUserIds];
      if (currentBlockedUserIds.contains(unblockedUserId)) {
        // Remove the unblocked user from the blocked user list.
        state.blockedUserIds = currentBlockedUserIds..remove(unblockedUserId);
      }

      return response;
    } catch (e, stk) {
      logger.severe('Error unblocking user', e, stk);
      rethrow;
    }
  }

  /// Retrieves a list of all users that the current user has blocked.
  Future<BlockedUsersResponse> queryBlockedUsers() async {
    try {
      final response = await _userBlockLock.synchronized(
        () => _chatApi.user.queryBlockedUsers(),
      );

      // Update the blocked user IDs with the latest data.
      final blockedUserIds = response.blocks.map((it) => it.blockedUserId);
      state.blockedUserIds = [...blockedUserIds.nonNulls];

      return response;
    } catch (e, stk) {
      logger.severe('Error querying blocked users', e, stk);
      rethrow;
    }
  }

  /// Returns the unread count information for the current user.
  Future<GetUnreadCountResponse> getUnreadCount() async {
    final response = await _chatApi.user.getUnreadCount();

    // Emit an local event with the unread count information as a side effect
    // in order to update the current user state.
    handleEvent(Event(
      totalUnreadCount: response.totalUnreadCount,
      unreadChannels: response.channels.length,
      unreadThreads: response.threads.length,
    ));

    return response;
  }

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
    bool skipPush = false,
    bool skipEnrichUrl = false,
  }) =>
      _chatApi.message.updateMessage(
        message,
        skipPush: skipPush,
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
  Future<EmptyResponse> deleteMessage(
    String messageId, {
    bool hard = false,
  }) async {
    final response = await _chatApi.message.deleteMessage(
      messageId,
      hard: hard,
    );

    if (hard) {
      await chatPersistenceClient?.deleteMessageById(messageId);
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

  /// Creates a draft for the given [channelId] of type [channelType].
  Future<CreateDraftResponse> createDraft(
    DraftMessage draft,
    String channelId,
    String channelType,
  ) =>
      _chatApi.message.createDraft(
        channelId,
        channelType,
        draft,
      );

  /// Retrieves a draft for the given [channelId] of type [channelType].
  ///
  /// Optionally, pass [parentId] to get the draft for a thread.
  Future<GetDraftResponse> getDraft(
    String channelId,
    String channelType, {
    String? parentId,
  }) =>
      _chatApi.message.getDraft(
        channelId,
        channelType,
        parentId: parentId,
      );

  /// Deletes a draft for the given [channelId] of type [channelType].
  ///
  /// Optionally, pass [parentId] to delete the draft for a thread.
  Future<EmptyResponse> deleteDraft(
    String channelId,
    String channelType, {
    String? parentId,
  }) =>
      _chatApi.message.deleteDraft(
        channelId,
        channelType,
        parentId: parentId,
      );

  /// Queries drafts for the current user.
  Future<QueryDraftsResponse> queryDrafts({
    Filter? filter,
    SortOrder<Draft>? sort,
    PaginationParams? pagination,
  }) =>
      _chatApi.message.queryDrafts(
        sort: sort,
        pagination: pagination,
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

  /// Queries threads with the given [options] and [pagination] params.
  ///
  /// Optionally, pass [filter] and [sort] to filter and sort the threads.
  Future<QueryThreadsResponse> queryThreads({
    Filter? filter,
    SortOrder<Thread>? sort,
    ThreadOptions options = const ThreadOptions(),
    PaginationParams pagination = const PaginationParams(),
  }) =>
      _chatApi.threads.queryThreads(
        filter: filter,
        sort: sort,
        options: options,
        pagination: pagination,
      );

  /// Retrieves a thread with the given [messageId].
  ///
  /// Optionally pass [options] to limit the response.
  Future<GetThreadResponse> getThread(
    String messageId, {
    ThreadOptions options = const ThreadOptions(),
  }) =>
      _chatApi.threads.getThread(
        messageId,
        options: options,
      );

  /// Partially updates the thread with the given [messageId].
  ///
  /// Use [set] to define values to be set.
  /// Use [unset] to define values to be unset.
  Future<UpdateThreadResponse> partialUpdateThread(
    String messageId, {
    Map<String, Object?>? set,
    List<String>? unset,
  }) =>
      _chatApi.threads.partialUpdateThread(
        messageId,
        set: set,
        unset: unset,
      );

  /// Pins the channel for the current user.
  Future<PartialUpdateMemberResponse> pinChannel({
    required String channelId,
    required String channelType,
  }) {
    return partialMemberUpdate(
      channelId: channelId,
      channelType: channelType,
      set: const MemberUpdatePayload(pinned: true).toJson(),
    );
  }

  /// Unpins the channel for the current user.
  Future<PartialUpdateMemberResponse> unpinChannel({
    required String channelId,
    required String channelType,
  }) {
    return partialMemberUpdate(
      channelId: channelId,
      channelType: channelType,
      unset: [MemberUpdateType.pinned.name],
    );
  }

  /// Archives the channel for the current user.
  Future<PartialUpdateMemberResponse> archiveChannel({
    required String channelId,
    required String channelType,
  }) {
    return partialMemberUpdate(
      channelId: channelId,
      channelType: channelType,
      set: const MemberUpdatePayload(archived: true).toJson(),
    );
  }

  /// Unarchives the channel for the current user.
  Future<PartialUpdateMemberResponse> unarchiveChannel({
    required String channelId,
    required String channelType,
  }) {
    return partialMemberUpdate(
      channelId: channelId,
      channelType: channelType,
      unset: [MemberUpdateType.archived.name],
    );
  }

  /// Partially updates the member of the given channel.
  ///
  /// Use [set] to define values to be set.
  /// Use [unset] to define values to be unset.
  /// When [userId] is not provided, the current user will be used.
  Future<PartialUpdateMemberResponse> partialMemberUpdate({
    required String channelId,
    required String channelType,
    Map<String, Object?>? set,
    List<String>? unset,
  }) {
    assert(set != null || unset != null, 'Set or unset must be provided.');

    return _chatApi.channel.updateMemberPartial(
      channelId: channelId,
      channelType: channelType,
      set: set,
      unset: unset,
    );
  }

  /// Queries reminders for the current user.
  ///
  /// Optionally, pass [filter], [sort] and [pagination] to filter, sort and
  /// paginate the reminders.
  Future<QueryRemindersResponse> queryReminders({
    Filter? filter,
    SortOrder<MessageReminder>? sort,
    PaginationParams pagination = const PaginationParams(),
  }) {
    return _chatApi.reminders.queryReminders(
      filter: filter,
      sort: sort,
      pagination: pagination,
    );
  }

  /// Creates a reminder for the given [messageId].
  ///
  /// Optionally, pass [remindAt] to set the reminder time.
  Future<CreateReminderResponse> createReminder(
    String messageId, {
    DateTime? remindAt,
  }) {
    return _chatApi.reminders.createReminder(
      messageId,
      remindAt: remindAt,
    );
  }

  /// Updates a reminder for the given [messageId].
  ///
  /// Optionally, pass [remindAt] to set the new reminder time.
  Future<UpdateReminderResponse> updateReminder(
    String messageId, {
    DateTime? remindAt,
  }) {
    return _chatApi.reminders.updateReminder(
      messageId,
      remindAt: remindAt,
    );
  }

  /// Deletes a reminder for the given [messageId].
  Future<EmptyResponse> deleteReminder(String messageId) {
    return _chatApi.reminders.deleteReminder(messageId);
  }

  /// Closes the [_ws] connection and resets the [state]
  /// If [flushChatPersistence] is true the client deletes all offline
  /// user's data.
  Future<void> disconnectUser({bool flushChatPersistence = false}) async {
    logger.info('Disconnecting user : ${state.currentUser?.id}');

    // closing web-socket connection
    closeConnection();

    // resetting state.
    state.dispose();
    state = ClientState(this);

    // resetting credentials.
    _tokenManager.reset();
    _connectionIdManager.reset();

    // closing persistence connection.
    return closePersistenceConnection(flush: flushChatPersistence);
  }

  /// Call this function to dispose the client
  Future<void> dispose() async {
    logger.info('Disposing StreamChatClient');

    await disconnectUser();
    await _ws.dispose();
    await _eventController.close();
    await _connectionStatusSubscription?.cancel();
  }
}

/// The class that handles the state of the channel listening to the events
class ClientState {
  /// Creates a new instance listening to events and updating the state
  ClientState(this._client);

  CompositeSubscription? _eventsSubscription;

  /// Starts listening to the client events.
  void subscribeToEvents() {
    if (_eventsSubscription != null) {
      cancelEventSubscription();
    }

    _eventsSubscription = CompositeSubscription()
      ..add(
        _client.on().listen((event) {
          // Update the current user only if the event is not a health check.
          if (event.me case final user?) {
            if (event.type != EventType.healthCheck) {
              currentUser = currentUser?.merge(user) ?? user;
            }
          }

          // Update the total unread count.
          if (event.totalUnreadCount case final count?) {
            currentUser = currentUser?.copyWith(totalUnreadCount: count);
          }

          // Update the unread channels count.
          if (event.unreadChannels case final count?) {
            currentUser = currentUser?.copyWith(unreadChannels: count);
          }

          // Update the unread threads count.
          if (event.unreadThreads case final count?) {
            currentUser = currentUser?.copyWith(unreadThreads: count);
          }

          // Update the push preferences.
          if (event.pushPreference case final preferences?) {
            currentUser = currentUser?.copyWith(pushPreferences: preferences);
          }
        }),
      );

    _listenChannelLeft();

    _listenChannelDeleted();

    _listenChannelHidden();

    _listenUserUpdated();

    _listenAllChannelsRead();

    _listenUserMessagesDeleted();
  }

  /// Stops listening to the client events.
  void cancelEventSubscription() {
    if (_eventsSubscription != null) {
      _eventsSubscription!.cancel();
      _eventsSubscription = null;
    }
  }

  /// Pauses listening to the client events.
  void pauseEventSubscription([Future<void>? resumeSignal]) {
    _eventsSubscription?.pause(resumeSignal);
  }

  /// Resumes listening to the client events.
  void resumeEventSubscription() {
    _eventsSubscription?.resume();
  }

  void _listenChannelHidden() {
    _eventsSubscription?.add(
      _client.on(EventType.channelHidden).listen((event) async {
        final eventChannel = event.channel!;
        await _client.chatPersistenceClient?.deleteChannels([eventChannel.cid]);
        channels.remove(eventChannel.cid)?.dispose();
      }),
    );
  }

  void _listenUserUpdated() {
    _eventsSubscription?.add(
      _client.on(EventType.userUpdated).listen((event) {
        var user = event.user;
        if (user == null) return;

        if (user.id == currentUser?.id) {
          final updatedUser = OwnUser.fromUser(user);
          currentUser = user = updatedUser.copyWith(
            // PRESERVE these fields (we don't get them in user.updated events)
            devices: currentUser?.devices,
            mutes: currentUser?.mutes,
            channelMutes: currentUser?.channelMutes,
            totalUnreadCount: currentUser?.totalUnreadCount,
            unreadChannels: currentUser?.unreadChannels,
            unreadThreads: currentUser?.unreadThreads,
            blockedUserIds: currentUser?.blockedUserIds,
            pushPreferences: currentUser?.pushPreferences,
          );
        }

        updateUser(user);
      }),
    );
  }

  void _listenAllChannelsRead() {
    _eventsSubscription?.add(
      _client.on(EventType.notificationMarkRead).listen((event) {
        if (event.cid == null) {
          channels.forEach((key, value) {
            value.state?.unreadCount = 0;
          });
        }
      }),
    );
  }

  void _listenChannelLeft() {
    _eventsSubscription?.add(
      _client
          .on(
        EventType.memberRemoved,
        EventType.notificationRemovedFromChannel,
      )
          .listen((event) async {
        final isCurrentUser = event.user!.id == currentUser!.id;
        if (isCurrentUser && event.channel != null) {
          final eventChannel = event.channel!;
          await _client.chatPersistenceClient
              ?.deleteChannels([eventChannel.cid]);
          channels.remove(eventChannel.cid)?.dispose();
        }
      }),
    );
  }

  void _listenChannelDeleted() {
    _eventsSubscription?.add(
      _client
          .on(
        EventType.channelDeleted,
        EventType.notificationChannelDeleted,
      )
          .listen((Event event) async {
        final eventChannel = event.channel!;
        await _client.chatPersistenceClient?.deleteChannels([eventChannel.cid]);
        channels.remove(eventChannel.cid)?.dispose();
      }),
    );
  }

  void _listenUserMessagesDeleted() {
    _eventsSubscription?.add(
      _client.on(EventType.userMessagesDeleted).listen((event) async {
        final cid = event.cid;
        // Only handle message deletions that are not channel specific
        // (i.e. user banned globally from the app)
        if (cid != null) return;

        // Iterate through all the available channels and send the event
        // to be handled by the respective channel instances.
        for (final cid in [...channels.keys]) {
          final channelEvent = event.copyWith(cid: cid);
          _client.handleEvent(channelEvent);
        }
      }),
    );
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
      for (final user in userList)
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

  /// The current user
  Map<String, User> get users => _usersController.value;

  /// The current user as a stream
  Stream<Map<String, User>> get usersStream => _usersController.stream;

  /// The current unread channels count
  int get unreadChannels => _unreadChannelsController.value;

  /// The current unread channels count as a stream
  Stream<int> get unreadChannelsStream => _unreadChannelsController.stream;

  /// The current unread thread count.
  int get unreadThreads => _unreadThreadsController.value;

  /// The current unread threads count as a stream.
  Stream<int> get unreadThreadsStream => _unreadThreadsController.stream;

  /// The current total unread messages count
  int get totalUnreadCount => _totalUnreadCountController.value;

  /// The current total unread messages count as a stream
  Stream<int> get totalUnreadCountStream => _totalUnreadCountController.stream;

  /// The current list of channels in memory as a stream
  Stream<Map<String, Channel>> get channelsStream => _channelsController.stream;

  /// The current list of channels in memory
  Map<String, Channel> get channels => _channelsController.value;

  set channels(Map<String, Channel> newChannels) {
    _channelsController.add(newChannels);
  }

  /// Adds a list of channels to the current list of cached channels
  void addChannels(Map<String, Channel> channelMap) {
    final newChannels = {
      ...channels,
      ...channelMap,
    };
    channels = newChannels;
  }

  /// Removes the channel from the cached list of [channels]
  void removeChannel(String channelCid) {
    channels = channels..remove(channelCid);
  }

  @visibleForTesting
  set blockedUserIds(List<String> blockedUserIds) {
    currentUser = currentUser?.copyWith(blockedUserIds: blockedUserIds);
  }

  /// Used internally for optimistic update of unread count
  set totalUnreadCount(int unreadCount) {
    _totalUnreadCountController.add(unreadCount);
  }

  void _computeUnreadCounts(OwnUser? user) {
    if (user?.totalUnreadCount case final count?) {
      _totalUnreadCountController.add(count);
    }

    if (user?.unreadChannels case final count?) {
      _unreadChannelsController.add(count);
    }

    if (user?.unreadThreads case final count?) {
      _unreadThreadsController.add(count);
    }
  }

  final _channelsController = BehaviorSubject<Map<String, Channel>>.seeded({});
  final _currentUserController = BehaviorSubject<OwnUser?>();
  final _usersController = BehaviorSubject<Map<String, User>>.seeded({});
  final _unreadChannelsController = BehaviorSubject<int>.seeded(0);
  final _unreadThreadsController = BehaviorSubject<int>.seeded(0);
  final _totalUnreadCountController = BehaviorSubject<int>.seeded(0);

  /// Call this method to dispose this object
  void dispose() {
    cancelEventSubscription();
    _currentUserController.close();
    _unreadChannelsController.close();
    _unreadThreadsController.close();
    _totalUnreadCountController.close();

    final channels = [...this.channels.keys];
    for (final channel in channels) {
      this.channels.remove(channel)?.dispose();
    }
    _channelsController.close();
  }
}
