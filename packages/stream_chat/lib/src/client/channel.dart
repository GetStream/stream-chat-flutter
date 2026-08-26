// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:synchronized/synchronized.dart';

// Re-exported so that importing this file directly keeps resolving the
// extensions that used to be declared here.
export 'channel_capability_check.dart';
export 'channel_client_state.dart';
export 'channel_read_helper.dart';

/// The maximum time the incoming [Event.typingStart] event is valid before a
/// [Event.typingStop] event is emitted automatically.
const incomingTypingStartEventTimeout = 7;

/// Class that manages a specific channel.
///
/// #### Channel name
///
/// {@template name}
/// If an optional [name] argument is provided in the constructor then it
/// will be set on [extraData] with a key of 'name'.
///
/// ```dart
/// final channel = Channel(client, type, id, name: 'Channel name');
/// print(channel.name == channel.extraData['name']); // true
/// ```
///
/// Before the channel is initialized the name can be set directly:
/// ```dart
/// channel.name = 'New channel name';
/// ```
///
/// To update the name after the channel has been initialized, call:
/// ```dart
/// channel.updateName('Updated channel name');
/// ```
///
/// This will do a partial update to update the name.
/// {@endtemplate}
///
/// #### Channel image
///
/// {@template image}
/// If an optional [image] argument is provided in the constructor then it
/// will be set on [extraData] with a key of 'image'.
///
/// ```dart
/// final channel = Channel(client, type, id, image: 'https://getstream.io/image.png');
/// print(channel.image == channel.extraData['image']); // true
/// ```
///
/// Before the channel is initialized the image can be set directly:
/// ```dart
/// channel.image = 'https://getstream.io/new-image';
/// ```
///
/// To update the image after the channel has been initialized, call:
/// ```dart
/// channel.updateImage('https://getstream.io/new-image');
/// ```
///
/// This will do a partial update to update the image.
/// {@endtemplate}
class Channel {
  /// Class that manages a specific channel.
  ///
  /// Optional [extraData] and [image] properties can be provided. The [image]
  /// is exposed to easily set a key of 'image' on [extraData].
  Channel(
    this._client,
    this._type,
    this._id, {
    String? name,
    String? image,
    Map<String, Object?>? extraData,
  }) : _cid = _id != null ? '$_type:$_id' : null,
       _extraData = {
         ...?extraData,
         if (name != null) 'name': name,
         if (image != null) 'image': image,
       } {
    _client.logger.info('New Channel instance created, not yet initialized');
  }

  /// Create a channel client instance from a [ChannelState] object.
  Channel.fromState(this._client, ChannelState channelState)
    : assert(
        channelState.channel != null,
        'No channel found inside channel state',
      ),
      _id = channelState.channel!.id,
      _type = channelState.channel!.type,
      _cid = channelState.channel!.cid,
      _extraData = channelState.channel!.extraData {
    _initState(channelState); // Initialize the state immediately.
  }

  /// This client state
  ChannelClientState? state;

  /// The channel type
  final String _type;

  String? _id;
  String? _cid;
  final Map<String, Object?> _extraData;

  /// Shortcut to set channel name.
  ///
  /// {@macro name}
  set name(String? name) {
    if (_isInitialized) {
      throw StateError(
        'Once the channel is initialized you should use `channel.updateName` '
        'to update the channel name',
      );
    }
    _extraData.addAll({'name': name});
  }

  /// Shortcut to set channel image.
  ///
  /// {@macro image}
  set image(String? image) {
    if (_isInitialized) {
      throw StateError(
        'Once the channel is initialized you should use `channel.updateImage` '
        'to update the channel image',
      );
    }
    _extraData.addAll({'image': image});
  }

  set extraData(Map<String, Object?> extraData) {
    if (_isInitialized) {
      throw StateError(
        'Once the channel is initialized you should use `channel.update` '
        'to update channel data',
      );
    }
    _extraData.addAll(extraData);
  }

  /// Whether this channel is identified by its member set rather than an
  /// explicit id.
  ///
  /// Stream auto-generates ids of the form `!members-<hash>` for channels
  /// created with members but no id, so the same set of users always
  /// references the same channel.
  ///
  /// Distinct channels can lose members but can't gain them after creation.
  ///
  /// See [isOneToOne] for the typical 1-to-1 predicate built on this.
  bool get isDistinct => id?.startsWith('!members') == true;

  /// Whether this is a group channel.
  ///
  /// True when the channel has more than two members, or isn't [isDistinct].
  /// Custom-id channels are treated as groups regardless of current member
  /// count because they aren't bounded — they can grow back into
  /// multi-person conversations.
  ///
  /// Near-inverse of [isOneToOne].
  bool get isGroup => (memberCount ?? 0) > 2 || !isDistinct;

  /// Whether this is a 1-to-1 conversation.
  ///
  /// True when the channel is [isDistinct] and has exactly two members.
  /// Distinct channels can't gain members, so a 2-member distinct channel
  /// is permanently bounded to two participants — including channels that
  /// shrunk down from a larger group DM.
  ///
  /// This is a structural predicate without a current-user check. Combine
  /// with capability / permission checks at the call site if you need
  /// perspective gating.
  ///
  /// Near-inverse of [isGroup].
  bool get isOneToOne => isDistinct && memberCount == 2;

  /// Returns true if the channel is muted.
  bool get isMuted {
    final channelMutes = _client.state.currentUser?.channelMutes;
    if (channelMutes == null) return false;

    return channelMutes.any((it) => it.channel.cid == cid);
  }

  /// Returns true if the channel is muted, as a stream.
  Stream<bool> get isMutedStream => _client.state.currentUserStream.map((user) {
    final channelMutes = user?.channelMutes;
    if (channelMutes == null) return false;

    return channelMutes.any((it) => it.channel.cid == cid);
  }).distinct();

  /// Channel configuration.
  ChannelConfig? get config {
    _checkInitialized();
    return state!.channelState.channel?.config;
  }

  /// Channel configuration as a stream.
  Stream<ChannelConfig?> get configStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.config);
  }

  /// Relationship of the current user to this channel.
  Member? get membership {
    _checkInitialized();
    return state!.channelState.membership;
  }

  /// Relationship of the current user to this channel as a stream.
  Stream<Member?> get membershipStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.membership);
  }

  /// Channel user creator.
  User? get createdBy {
    _checkInitialized();
    return state!.channelState.channel?.createdBy;
  }

  /// Channel user creator as a stream.
  Stream<User?> get createdByStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.createdBy);
  }

  /// Channel frozen status.
  bool get frozen {
    _checkInitialized();
    return state!.channelState.channel?.frozen == true;
  }

  /// Channel frozen status as a stream.
  Stream<bool> get frozenStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.frozen == true);
  }

  /// Channel disabled status.
  bool get disabled {
    _checkInitialized();
    return state!.channelState.channel?.disabled == true;
  }

  /// Channel disabled status as a stream.
  Stream<bool> get disabledStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.disabled == true);
  }

  /// Channel hidden status.
  bool get hidden {
    _checkInitialized();
    return state!.channelState.channel?.hidden == true;
  }

  /// Channel hidden status as a stream.
  Stream<bool> get hiddenStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.hidden == true);
  }

  /// Channel pinned status.
  /// Status is specific to the current user.
  bool get isPinned {
    _checkInitialized();
    return membership?.pinnedAt != null;
  }

  /// Channel pinned status as a stream.
  /// Status is specific to the current user.
  Stream<bool> get isPinnedStream {
    return membershipStream.map((m) => m?.pinnedAt != null);
  }

  /// Channel archived status.
  /// Status is specific to the current user.
  bool get isArchived {
    _checkInitialized();
    return membership?.archivedAt != null;
  }

  /// Channel archived status as a stream.
  /// Status is specific to the current user.
  Stream<bool> get isArchivedStream {
    return membershipStream.map((m) => m?.archivedAt != null);
  }

  /// The last date at which the channel got truncated.
  DateTime? get truncatedAt {
    _checkInitialized();
    return state!.channelState.channel?.truncatedAt;
  }

  /// The last date at which the channel got truncated as a stream.
  Stream<DateTime?> get truncatedAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.truncatedAt);
  }

  /// Cooldown count
  int get cooldown {
    _checkInitialized();
    return state!.channelState.channel?.cooldown ?? 0;
  }

  /// Cooldown count as a stream
  Stream<int> get cooldownStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.cooldown ?? 0);
  }

  /// Remaining cooldown duration in seconds for the channel.
  ///
  /// Returns 0 if there is no cooldown active.
  ///
  /// Optionally, provide [lastMessageAt] to calculate the remaining cooldown based on a specific message timestamp
  /// instead of the last message sent by the current user in this channel.
  int getRemainingCooldown({DateTime? lastMessageAt}) {
    _checkInitialized();

    final cooldownDuration = cooldown;
    if (cooldownDuration <= 0) return 0;

    final userLastMessageAt = lastMessageAt ?? currentUserLastMessageAt;
    if (userLastMessageAt == null) return 0;

    if (canSkipSlowMode) return 0;

    final currentTime = DateTime.timestamp();
    final elapsedTime = currentTime.difference(userLastMessageAt).inSeconds;

    return math.max(0, cooldownDuration - elapsedTime);
  }

  /// Channel creation date.
  DateTime? get createdAt {
    _checkInitialized();
    return state!.channelState.channel?.createdAt;
  }

  /// Channel creation date as a stream.
  Stream<DateTime?> get createdAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.createdAt);
  }

  /// Channel last message date.
  DateTime? get lastMessageAt {
    _checkInitialized();
    return state!.channelState.channel?.lastMessageAt;
  }

  /// Channel last message date as a stream.
  Stream<DateTime?> get lastMessageAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.lastMessageAt);
  }

  DateTime? _currentUserLastMessageAt({
    required List<Message>? messages,
    required Map<String, List<Message>> threads,
  }) {
    final currentUserId = client.state.currentUser?.id;
    if (currentUserId == null) return null;

    bool ours(Message m) => !m.isEphemeral && m.user?.id == currentUserId;

    DateTime? max;

    if (messages != null) {
      final idx = messages.lastIndexWhere(ours);
      if (idx != -1) max = messages[idx].createdAt;
    }

    for (final replies in threads.values) {
      final idx = replies.lastIndexWhere(ours);
      if (idx == -1) continue;
      final createdAt = replies[idx].createdAt;
      if (max == null || createdAt.isAfter(max)) max = createdAt;
    }

    return max;
  }

  /// The date of the last message sent by the current user.
  ///
  /// Returns null if the channel is not up to date or
  /// if the current user has not sent any messages in this channel.
  ///
  /// Note: This includes both regular messages and thread messages.
  DateTime? get currentUserLastMessageAt {
    _checkInitialized();

    // If the channel is not up to date, we can't rely on the last message
    // from the current user.
    if (!state!.isUpToDate) return null;

    final threads = state!.threads;
    final messages = state!.channelState.messages;

    return _currentUserLastMessageAt(messages: messages, threads: threads);
  }

  /// The date of the last message sent by the current user as a stream.
  ///
  /// Returns null if the channel is not up to date or
  /// if the current user has not sent any messages in this channel.
  ///
  /// Note: This includes both regular messages and thread messages.
  Stream<DateTime?> get currentUserLastMessageAtStream {
    _checkInitialized();

    return CombineLatestStream.combine3(
      state!.isUpToDateStream,
      state!.channelStateStream.map((s) => s.messages).distinct(identical),
      state!.threadsStream,
      (isUpToDate, messages, threads) {
        // If the channel is not up to date, we can't rely on the last message
        // from the current user.
        if (!isUpToDate) return null;

        return _currentUserLastMessageAt(messages: messages, threads: threads);
      },
    );
  }

  /// Channel updated date.
  DateTime? get updatedAt {
    _checkInitialized();
    return state!.channelState.channel?.updatedAt;
  }

  /// Channel updated date as a stream.
  Stream<DateTime?> get updatedAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.updatedAt);
  }

  /// Channel deletion date.
  DateTime? get deletedAt {
    _checkInitialized();
    return state!.channelState.channel?.deletedAt;
  }

  /// Channel deletion date as a stream.
  Stream<DateTime?> get deletedAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.deletedAt);
  }

  /// Channel member count.
  int? get memberCount {
    _checkInitialized();
    return state!.channelState.channel?.memberCount;
  }

  /// Channel member count as a stream.
  Stream<int?> get memberCountStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.memberCount);
  }

  /// Channel message count.
  ///
  /// Note: This field is only populated if the `count_messages` option is
  /// enabled for your app.
  int? get messageCount {
    _checkInitialized();
    return state!.channelState.channel?.messageCount;
  }

  /// Channel message count as a stream.
  ///
  /// Note: This field is only populated if the `count_messages` option is
  /// enabled for your app.
  Stream<int?> get messageCountStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.messageCount);
  }

  /// List of filter tags applied to this channel.
  ///
  /// Generally used for filtering channels while querying.
  List<String>? get filterTags {
    _checkInitialized();
    return state!.channelState.channel?.filterTags;
  }

  /// Channel id.
  String? get id => state?.channelState.channel?.id ?? _id;

  /// Channel type.
  String get type => state?.channelState.channel?.type ?? _type;

  /// Channel cid.
  String? get cid => state?.channelState.channel?.cid ?? _cid;

  /// Channel team.
  String? get team {
    _checkInitialized();
    return state!.channelState.channel?.team;
  }

  /// Channel extra data.
  Map<String, Object?> get extraData {
    var data = state?.channelState.channel?.extraData;
    if (data == null || data.isEmpty) {
      data = _extraData;
    }
    return data;
  }

  /// List of user permissions on this channel
  List<ChannelCapability> get ownCapabilities => state?.channelState.channel?.ownCapabilities ?? [];

  /// List of user permissions on this channel
  Stream<List<ChannelCapability>> get ownCapabilitiesStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.ownCapabilities ?? []).distinct();
  }

  /// Channel extra data as a stream.
  Stream<Map<String, Object?>> get extraDataStream {
    _checkInitialized();
    return state!.channelStateStream.map(
      (cs) => cs.channel?.extraData ?? _extraData,
    );
  }

  /// Shortcut to get channel name.
  ///
  /// {@macro name}
  String? get name => extraData['name'] as String?;

  /// Channel [name] as a stream.
  ///
  /// The channel needs to be initialized.
  ///
  /// {@macro name}
  Stream<String?> get nameStream {
    _checkInitialized();
    return extraDataStream.map((it) => it['name'] as String?);
  }

  /// Shortcut to get channel image.
  ///
  /// {@macro image}
  String? get image => extraData['image'] as String?;

  /// Channel [image] as a stream.
  ///
  /// The channel needs to be initialized.
  ///
  /// {@macro image}
  Stream<String?> get imageStream {
    _checkInitialized();
    return extraDataStream.map((it) => it['image'] as String?);
  }

  /// The main Stream chat client.
  StreamChatClient get client => _client;
  final StreamChatClient _client;

  Completer<bool> _initializedCompleter = Completer();

  /// True if this is initialized.
  ///
  /// Call [watch] to initialize the client or instantiate it using
  /// [Channel.fromState].
  Future<bool> get initialized => _initializedCompleter.future;

  // Whether the channel is successfully initialized and not disposed.
  bool get _isInitialized => _initializedCompleter.isCompleted && state != null;

  final _cancelableAttachmentUploadRequest = <String, CancelToken>{};
  final _messageAttachmentsUploadCompleter = <String, Completer<Message>>{};

  /// Cancels [attachmentId] upload request. Throws exception if the request
  /// hasn't even started yet, Already completed or Already cancelled.
  ///
  /// Optionally, provide a [reason] for the cancellation.
  void cancelAttachmentUpload(
    String attachmentId, {
    String? reason,
  }) {
    final cancelToken = _cancelableAttachmentUploadRequest[attachmentId];
    if (cancelToken == null) {
      throw const StreamChatError(
        "Upload request for this Attachment hasn't started yet or maybe "
        'Already completed',
      );
    }
    if (cancelToken.isCancelled) {
      throw const StreamChatError('Upload request already cancelled');
    }
    cancelToken.cancel(reason);
  }

  /// Retries the failed [attachmentId] upload request.
  Future<void> retryAttachmentUpload(String messageId, String attachmentId) =>
      _uploadAttachments(messageId, [attachmentId]);

  Future<void> _uploadAttachments(
    String messageId,
    Iterable<String> attachmentIds,
  ) {
    var message = [
      ...state!.messages,
      ...state!.threads.values.expand((messages) => messages),
    ].firstWhereOrNull((it) => it.id == messageId);

    if (message == null) {
      throw const StreamChatError('Error, Message not found');
    }

    final attachments = message.attachments.where((it) {
      if (it.uploadState.isSuccess) return false;
      return attachmentIds.contains(it.id);
    });

    if (attachments.isEmpty) {
      client.logger.info('No attachments available to upload');
      if (message.attachments.every((it) => it.uploadState.isSuccess)) {
        _messageAttachmentsUploadCompleter.remove(messageId)?.complete(message);
      }
      return Future.value();
    }

    client.logger.info('Found ${attachments.length} attachments');

    void updateAttachment(Attachment attachment, {bool remove = false}) {
      final index = message!.attachments.indexWhere(
        (it) => it.id == attachment.id,
      );
      if (index != -1) {
        // update or remove attachment from message.
        final List<Attachment> newAttachments;
        if (remove) {
          newAttachments = [...message!.attachments]..removeAt(index);
        } else {
          newAttachments = [...message!.attachments]..[index] = attachment;
        }

        final updatedMessage = message!.copyWith(attachments: newAttachments);
        state?.updateMessage(updatedMessage);
        // updating original message for next iteration
        message = message!.merge(updatedMessage);
      }
    }

    return Future.wait(
      attachments.map((it) {
        client.logger.info('Uploading ${it.id} attachment...');

        final throttledUpdateAttachment = updateAttachment.throttled(
          const Duration(milliseconds: 500),
        );

        void onSendProgress(int sent, int total) {
          throttledUpdateAttachment([
            it.copyWith(
              uploadState: UploadState.inProgress(uploaded: sent, total: total),
            ),
          ]);
        }

        final isImage = it.type == AttachmentType.image;
        final cancelToken = CancelToken();
        Future<SendAttachmentResponse> future;
        if (isImage) {
          future = sendImage(
            it.file!,
            onSendProgress: onSendProgress,
            cancelToken: cancelToken,
            extraData: it.extraData,
          );
        } else {
          future = sendFile(
            it.file!,
            onSendProgress: onSendProgress,
            cancelToken: cancelToken,
            extraData: it.extraData,
          );
        }
        _cancelableAttachmentUploadRequest[it.id] = cancelToken;
        return future
            .then((response) {
              client.logger.info('Attachment ${it.id} uploaded successfully...');

              // If the response is SendFileResponse, then we might also be getting
              // thumbUrl in case of video. So we need to update the attachment with
              // both the assetUrl and thumbUrl.
              if (response is SendFileResponse) {
                updateAttachment(
                  it.copyWith(
                    assetUrl: response.file,
                    thumbUrl: response.thumbUrl,
                    uploadState: const UploadState.success(),
                  ),
                );
              } else {
                updateAttachment(
                  it.copyWith(
                    imageUrl: response.file,
                    uploadState: const UploadState.success(),
                  ),
                );
              }
            })
            .catchError((e, stk) {
              if (e is StreamChatNetworkError && e.type == .cancel) {
                client.logger.info('Attachment ${it.id} upload cancelled');

                // remove attachment from message if cancelled.
                updateAttachment(it, remove: true);
                return;
              }

              client.logger.severe('error uploading the attachment', e, stk);
              updateAttachment(
                it.copyWith(uploadState: UploadState.failed(error: e.toString())),
              );
            })
            .whenComplete(() {
              throttledUpdateAttachment.cancel();
              _cancelableAttachmentUploadRequest.remove(it.id);
            });
      }),
    ).whenComplete(() {
      final completer = _messageAttachmentsUploadCompleter.remove(messageId);
      if (completer == null || completer.isCompleted) return;

      // Always complete with the latest message view so callers can decide
      // success vs. partial failure by inspecting per-attachment upload
      // states. Cancellation is still surfaced via `completeError` from the
      // sendMessage/updateMessage/deleteMessage entry points.
      completer.complete(message);
    });
  }

  final _sendMessageLock = Lock();

  /// Send a [message] to this channel.
  ///
  /// If [skipPush] is true the message will not send a push notification.
  ///
  /// Waits for a [_messageAttachmentsUploadCompleter] to complete
  /// before actually sending the message.
  Future<SendMessageResponse> sendMessage(
    Message message, {
    bool skipPush = false,
    bool skipEnrichUrl = false,
  }) async {
    _checkInitialized();

    // Clean up stale error messages before sending a new message.
    state?.cleanUpStaleErrorMessages();

    // Cancelling previous completer in case it's called again in the process
    // Eg. Updating the message while the previous call is in progress.
    _messageAttachmentsUploadCompleter.remove(message.id)?.completeError(const StreamChatError('Message cancelled'));

    final quotedMessage = state!.messages.firstWhereOrNull(
      (m) => m.id == message.quotedMessageId,
    );
    // ignore: parameter_assignments
    message = message.copyWith(
      localCreatedAt: DateTime.now(),
      user: _client.state.currentUser,
      quotedMessage: quotedMessage,
      state: MessageState.sending,
      attachments: message.attachments.map(
        (it) {
          if (it.uploadState.isSuccess) return it;
          return it.copyWith(uploadState: const UploadState.preparing());
        },
      ).toList(),
    );

    state?.updateMessage(message);

    try {
      if (message.attachments.any((it) => !it.uploadState.isSuccess)) {
        final attachmentsUploadCompleter = Completer<Message>();
        _messageAttachmentsUploadCompleter[message.id] = attachmentsUploadCompleter;

        _uploadAttachments(
          message.id,
          message.attachments.map((it) => it.id),
        );

        // ignore: parameter_assignments
        message = await attachmentsUploadCompleter.future;

        // Fail the whole message if any attachment failed to upload
        if (message.attachments.any((it) => it.uploadState.isFailed)) {
          throw const StreamChatError('Failed to upload one or more attachments');
        }
      }

      // Validate the final message before sending it to the server.
      if (MessageRules.canUpload(message) != true) {
        client.logger.warning('Message is not valid for sending, removing it');

        // Remove the message from state as it is invalid.
        state!.deleteMessage(message, hardDelete: true);
        throw const StreamChatError('Message is not valid for sending');
      }

      // Wait for the previous sendMessage call to finish. Otherwise, the order
      // of messages will not be maintained.
      final response = await _sendMessageLock.synchronized(
        () => _client.sendMessage(
          message,
          id!,
          type,
          skipPush: skipPush,
          skipEnrichUrl: skipEnrichUrl,
        ),
      );

      final sentMessage = message
          .updateWith(response.message)
          .copyWith(
            // Update the message state to sent.
            state: MessageState.sent,
          );

      state?.updateMessage(sentMessage);

      return response;
    } catch (e) {
      final failedMessage = message.copyWith(
        // Update the message state to failed.
        state: MessageState.sendingFailed(
          skipPush: skipPush,
          skipEnrichUrl: skipEnrichUrl,
        ),
      );

      state?.updateMessage(failedMessage);
      // If the error is retriable, add it to the retry queue.
      if (e is StreamChatNetworkError && e.isRetriable) {
        state?.scheduleRetry(failedMessage);
      }

      rethrow;
    }
  }

  final _updateMessageLock = Lock();

  /// Updates the [message] in this channel.
  ///
  /// Waits for a [_messageAttachmentsUploadCompleter] to complete
  /// before actually updating the message.
  Future<UpdateMessageResponse> updateMessage(
    Message message, {
    bool skipPush = false,
    bool skipEnrichUrl = false,
  }) async {
    _checkInitialized();

    // Cancelling previous completer in case it's called again in the process
    // Eg. Updating the message while the previous call is in progress.
    _messageAttachmentsUploadCompleter.remove(message.id)?.completeError(const StreamChatError('Message cancelled'));

    // ignore: parameter_assignments
    message = message.copyWith(
      state: MessageState.updating,
      localUpdatedAt: DateTime.now(),
      attachments: message.attachments.map(
        (it) {
          if (it.uploadState.isSuccess) return it;
          return it.copyWith(uploadState: const UploadState.preparing());
        },
      ).toList(),
    );

    state?.updateMessage(message);

    try {
      if (message.attachments.any((it) => !it.uploadState.isSuccess)) {
        final attachmentsUploadCompleter = Completer<Message>();
        _messageAttachmentsUploadCompleter[message.id] = attachmentsUploadCompleter;

        _uploadAttachments(
          message.id,
          message.attachments.map((it) => it.id),
        );

        // ignore: parameter_assignments
        message = await attachmentsUploadCompleter.future;

        // Fail the whole message if any attachment failed to upload
        if (message.attachments.any((it) => it.uploadState.isFailed)) {
          throw const StreamChatError('Failed to upload one or more attachments');
        }
      }

      // Wait for the previous update call to finish. Otherwise, the order of
      // messages will not be maintained.
      final response = await _updateMessageLock.synchronized(
        () => _client.updateMessage(
          message,
          skipPush: skipPush,
          skipEnrichUrl: skipEnrichUrl,
        ),
      );

      final updateMessage = message
          .updateWith(response.message)
          .copyWith(
            // Update the message state to updated.
            state: MessageState.updated,
          );

      state?.updateMessage(updateMessage);

      return response;
    } catch (e) {
      final failedMessage = message.copyWith(
        // Update the message state to failed.
        state: MessageState.updatingFailed(
          skipPush: skipPush,
          skipEnrichUrl: skipEnrichUrl,
        ),
      );

      state?.updateMessage(failedMessage);
      // If the error is retriable, add it to the retry queue.
      if (e is StreamChatNetworkError && e.isRetriable) {
        state?.scheduleRetry(failedMessage);
      }

      rethrow;
    }
  }

  /// Partially updates the [message] in this channel.
  ///
  /// Use [set] to define values to be set.
  ///
  /// Use [unset] to define values to be unset.
  Future<UpdateMessageResponse> partialUpdateMessage(
    Message message, {
    Map<String, Object?>? set,
    List<String>? unset,
    bool skipEnrichUrl = false,
  }) async {
    _checkInitialized();

    // Cancelling previous completer in case it's called again in the process
    // Eg. Updating the message while the previous call is in progress.
    _messageAttachmentsUploadCompleter.remove(message.id)?.completeError(const StreamChatError('Message cancelled'));

    // ignore: parameter_assignments
    message = message.copyWith(
      state: MessageState.updating,
      localUpdatedAt: DateTime.now(),
    );

    state?.updateMessage(message);

    try {
      // Wait for the previous update call to finish. Otherwise, the order of
      // messages will not be maintained.
      final response = await _updateMessageLock.synchronized(
        () => _client.partialUpdateMessage(
          message.id,
          set: set,
          unset: unset,
          skipEnrichUrl: skipEnrichUrl,
        ),
      );

      final updatedMessage = message
          .updateWith(response.message)
          .copyWith(
            // Update the message state to updated.
            state: MessageState.updated,
          );

      state?.updateMessage(updatedMessage);

      return response;
    } catch (e) {
      final failedMessage = message.copyWith(
        // Update the message state to failed.
        state: MessageState.partialUpdatingFailed(
          set: set,
          unset: unset,
          skipEnrichUrl: skipEnrichUrl,
        ),
      );

      state?.updateMessage(failedMessage);
      // If the error is retriable, add it to the retry queue.
      if (e is StreamChatNetworkError && e.isRetriable) {
        state?.scheduleRetry(failedMessage);
      }

      rethrow;
    }
  }

  final _deleteMessageLock = Lock();

  /// Deletes the [message] for everyone.
  ///
  /// If [hard] is true, the message is permanently deleted from the server
  /// and cannot be recovered. In this case, any attachments associated with the
  /// message are also deleted from the server.
  Future<EmptyResponse> deleteMessage(Message message, {bool hard = false}) {
    final deletionScope = MessageDeleteScope.deleteForAll(hard: hard);

    return _deleteMessage(message, scope: deletionScope);
  }

  /// Deletes the [message] only for the current user.
  ///
  /// Note: This does not delete the message for other channel members and
  /// they can still see the message.
  Future<EmptyResponse> deleteMessageForMe(Message message) {
    const deletionScope = MessageDeleteScope.deleteForMe();

    return _deleteMessage(message, scope: deletionScope);
  }

  // Deletes the [message] from the channel.
  //
  // The [scope] defines whether to delete the message for everyone or just
  // for the current user.
  //
  // If the message is a local message (not yet sent to the server) or a bounced
  // error message, it is deleted locally without making an API call.
  //
  // If the message is deleted for everyone and [scope.hard] is true, the
  // message is permanently deleted from the server and cannot be recovered.
  // In this case, any attachments associated with the message are also deleted
  // from the server.
  Future<EmptyResponse> _deleteMessage(
    Message message, {
    required MessageDeleteScope scope,
  }) async {
    _checkInitialized();

    // Directly deleting the local messages and bounced error messages as they
    // are not available on the server.
    if (message.remoteCreatedAt == null || message.isBouncedWithError) {
      _deleteLocalMessage(message);
      // Returning empty response to mark the api call as success.
      return EmptyResponse();
    }

    // ignore: parameter_assignments
    message = message.copyWith(
      type: MessageType.deleted,
      deletedAt: DateTime.now(),
      deletedForMe: scope is DeleteForMe,
      state: MessageState.deleting(scope: scope),
    );

    state?.deleteMessage(message, hardDelete: scope.hard);

    try {
      // Wait for the previous delete call to finish. Otherwise, the order of
      // messages will not be maintained.
      final response = await _deleteMessageLock.synchronized(
        () => switch (scope) {
          DeleteForMe() => _client.deleteMessageForMe(message.id),
          DeleteForAll() => _client.deleteMessage(message.id, hard: scope.hard),
        },
      );

      final deletedMessage = message.copyWith(
        deletedForMe: scope is DeleteForMe,
        state: MessageState.deleted(scope: scope),
      );

      state?.deleteMessage(deletedMessage, hardDelete: scope.hard);
      // If hard delete, also delete the attachments from the server.
      if (scope.hard) _deleteMessageAttachments(deletedMessage);

      return response;
    } catch (e) {
      final failedMessage = message.copyWith(
        // Update the message state to failed.
        state: MessageState.deletingFailed(scope: scope),
      );

      state?.deleteMessage(failedMessage, hardDelete: scope.hard);
      // If the error is retriable, add it to the retry queue.
      if (e is StreamChatNetworkError && e.isRetriable) {
        state?.scheduleRetry(failedMessage);
      }

      rethrow;
    }
  }

  // Deletes a local [message] that is not yet sent to the server.
  //
  // This is typically called when a user wants to delete a message that they
  // have composed but not yet sent, or if a message failed to send and the user
  // wants to remove it from their local view.
  void _deleteLocalMessage(Message message) {
    state?.deleteMessage(
      hardDelete: true, // Local messages are always hard deleted.
      message.copyWith(
        type: MessageType.deleted,
        localDeletedAt: DateTime.now(),
        state: MessageState.hardDeleted,
      ),
    );

    // Removing the attachments upload completer to stop the `sendMessage`
    // waiting for attachments to complete.
    final completer = _messageAttachmentsUploadCompleter.remove(message.id);
    completer?.completeError(const StreamChatError('Message deleted'));
  }

  // Deletes all the attachments associated with the given [message]
  // from the server. This is typically called when a message is hard deleted.
  Future<void> _deleteMessageAttachments(Message message) async {
    final attachments = message.attachments;
    final deleteFutures = attachments.map((it) async {
      if (it.imageUrl case final url?) return deleteImage(url);
      if (it.assetUrl case final url?) return deleteFile(url);
    });

    try {
      await Future.wait(deleteFutures);
    } catch (e, stk) {
      _client.logger.warning('Error deleting message attachments', e, stk);
    }
  }

  /// Retries operations on a message based on its failed state.
  ///
  /// This method examines the message's state and performs the appropriate
  /// retry action:
  /// - For [MessageState.sendingFailed], it attempts to send the message.
  /// - For [MessageState.updatingFailed], it attempts to update the message.
  /// - For [MessageState.partialUpdatingFailed], it attempts to partially
  ///   update the message with the same 'set' and 'unset' parameters that were
  ///   used in the original request.
  /// - For [MessageState.deletingFailed], it attempts to delete the message
  ///   again, using the same scope (for me or for all) as the original request.
  /// - For messages with [isBouncedWithError], it attempts to send the message.
  ///
  /// Throws a [StateError] if the message is not in a failed state or
  /// bounced with an error.
  Future<Object> retryMessage(Message message) async {
    assert(
      message.state.isFailed || message.isBouncedWithError,
      'Only failed or bounced messages can be retried',
    );

    return message.state.maybeWhen(
      failed: (state, _) => state.when(
        sendingFailed: (skipPush, skipEnrichUrl) => sendMessage(
          message,
          skipPush: skipPush,
          skipEnrichUrl: skipEnrichUrl,
        ),
        updatingFailed: (skipPush, skipEnrichUrl) => updateMessage(
          message,
          skipPush: skipPush,
          skipEnrichUrl: skipEnrichUrl,
        ),
        partialUpdatingFailed: (set, unset, skipEnrichUrl) {
          return partialUpdateMessage(
            message,
            set: set,
            unset: unset,
            skipEnrichUrl: skipEnrichUrl,
          );
        },
        deletingFailed: (scope) => switch (scope) {
          DeleteForMe() => deleteMessageForMe(message),
          DeleteForAll(hard: final hard) => deleteMessage(message, hard: hard),
        },
      ),
      orElse: () {
        // Check if the message is bounced with error.
        if (message.isBouncedWithError) return sendMessage(message);

        throw StateError(
          'Only failed or bounced messages can be retried',
        );
      },
    );
  }

  /// Pins provided message
  Future<UpdateMessageResponse> pinMessage(
    Message message, {
    Object? /*num|DateTime*/ timeoutOrExpirationDate,
  }) {
    assert(() {
      if (timeoutOrExpirationDate is! DateTime && timeoutOrExpirationDate != null && timeoutOrExpirationDate is! num) {
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
      message,
      set: {
        'pinned': true,
        'pin_expires': pinExpires?.toUtc().toIso8601String(),
      },
    );
  }

  /// Unpins provided message.
  Future<UpdateMessageResponse> unpinMessage(Message message) => partialUpdateMessage(
    message,
    set: {
      'pinned': false,
    },
  );

  /// Creates or updates a new [draft] for this channel.
  Future<CreateDraftResponse> createDraft(
    DraftMessage draft,
  ) {
    _checkInitialized();
    return _client.createDraft(draft, id!, type);
  }

  /// Retrieves the draft for this channel.
  ///
  /// Optionally, provide a [parentId] to get the draft for a specific thread.
  Future<GetDraftResponse> getDraft({
    String? parentId,
  }) {
    _checkInitialized();
    return _client.getDraft(id!, type, parentId: parentId);
  }

  /// Deletes the draft for this channel.
  ///
  /// Optionally, provide a [parentId] to delete the draft for a specific
  /// thread.
  Future<EmptyResponse> deleteDraft({
    String? parentId,
  }) {
    _checkInitialized();
    return _client.deleteDraft(id!, type, parentId: parentId);
  }

  /// Sends a static location to this channel.
  ///
  /// Optionally, provide a [messageText] and [extraData] to send along with
  /// the location.
  Future<SendMessageResponse> sendStaticLocation({
    String? id,
    String? messageText,
    String? createdByDeviceId,
    required LocationCoordinates location,
    Map<String, Object?> extraData = const {},
  }) {
    final message = Message(
      id: id,
      text: messageText,
      extraData: extraData,
    );

    final currentUserId = _client.state.currentUser?.id;
    final locationMessage = message.copyWith(
      sharedLocation: Location(
        channelCid: cid,
        userId: currentUserId,
        messageId: message.id,
        latitude: location.latitude,
        longitude: location.longitude,
        createdByDeviceId: createdByDeviceId,
      ),
    );

    return sendMessage(locationMessage);
  }

  /// Sends a live location sharing message to this channel.
  ///
  /// Optionally, provide a [messageText] and [extraData] to send along with
  /// the location.
  Future<SendMessageResponse> startLiveLocationSharing({
    String? id,
    String? messageText,
    String? createdByDeviceId,
    required DateTime endSharingAt,
    required LocationCoordinates location,
    Map<String, Object?> extraData = const {},
  }) {
    final message = Message(
      id: id,
      text: messageText,
      extraData: extraData,
    );

    final currentUserId = _client.state.currentUser?.id;
    final locationMessage = message.copyWith(
      sharedLocation: Location(
        channelCid: cid,
        userId: currentUserId,
        messageId: message.id,
        endAt: endSharingAt,
        latitude: location.latitude,
        longitude: location.longitude,
        createdByDeviceId: createdByDeviceId,
      ),
    );

    return sendMessage(locationMessage);
  }

  /// Send a file to this channel.
  Future<SendFileResponse> sendFile(
    AttachmentFile file, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) {
    _checkInitialized();
    return _client.sendFile(
      file,
      id!,
      type,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
      extraData: extraData,
    );
  }

  /// Send an image to this channel.
  Future<SendImageResponse> sendImage(
    AttachmentFile file, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) {
    _checkInitialized();
    return _client.sendImage(
      file,
      id!,
      type,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
      extraData: extraData,
    );
  }

  /// Search for a message with the given options.
  Future<SearchMessagesResponse> search({
    String? query,
    Filter? messageFilters,
    List<SortOption>? sort,
    PaginationParams? paginationParams,
  }) {
    _checkInitialized();
    return _client.search(
      Filter.in_('cid', [cid!]),
      sort: sort,
      query: query,
      paginationParams: paginationParams,
      messageFilters: messageFilters,
    );
  }

  /// Delete a file from this channel.
  Future<EmptyResponse> deleteFile(
    String url, {
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) {
    _checkInitialized();
    return _client.deleteFile(
      url,
      id!,
      type,
      cancelToken: cancelToken,
      extraData: extraData,
    );
  }

  /// Delete an image from this channel.
  Future<EmptyResponse> deleteImage(
    String url, {
    CancelToken? cancelToken,
    Map<String, Object?>? extraData,
  }) {
    _checkInitialized();
    return _client.deleteImage(
      url,
      id!,
      type,
      cancelToken: cancelToken,
      extraData: extraData,
    );
  }

  /// Send an event on this channel.
  Future<EmptyResponse> sendEvent(Event event) {
    _checkInitialized();
    return _client.sendEvent(id!, type, event);
  }

  final _pollLock = Lock();

  /// Send a message with a poll to this channel.
  ///
  /// Optionally provide a [messageText] to send a message along with the poll.
  Future<SendMessageResponse> sendPoll(
    Poll poll, {
    String? messageText,
  }) async {
    _checkInitialized();
    final res = await _pollLock.synchronized(() => _client.createPoll(poll));
    return sendMessage(
      Message(
        text: messageText,
        poll: res.poll,
        pollId: res.poll.id,
      ),
    );
  }

  /// Updates the [poll] in this channel.
  Future<UpdatePollResponse> updatePoll(Poll poll) {
    _checkInitialized();
    return _pollLock.synchronized(() => _client.updatePoll(poll));
  }

  /// Deletes the given [poll] from this channel.
  Future<EmptyResponse> deletePoll(Poll poll) {
    _checkInitialized();
    return _pollLock.synchronized(() => _client.deletePoll(poll.id));
  }

  /// Close the given [poll].
  Future<UpdatePollResponse> closePoll(Poll poll) {
    _checkInitialized();
    return _pollLock.synchronized(() => _client.closePoll(poll.id));
  }

  /// Create a new poll option for the given [poll].
  Future<CreatePollOptionResponse> createPollOption(
    Poll poll,
    PollOption option,
  ) {
    _checkInitialized();
    return _pollLock.synchronized(
      () => _client.createPollOption(poll.id, option),
    );
  }

  final _pollVoteLock = Lock();

  /// Cast a vote on the given [poll] with the given [option].
  Future<CastPollVoteResponse> castPollVote(
    Message message,
    Poll poll,
    PollOption option,
  ) async {
    _checkInitialized();

    final optionId = option.id;
    if (optionId == null) {
      throw ArgumentError('Option id cannot be null');
    }

    return _pollVoteLock.synchronized(
      () => _client.castPollVote(
        message.id,
        poll.id,
        optionId: optionId,
      ),
    );
  }

  /// Add a new answer to the given [poll].
  Future<CastPollVoteResponse> addPollAnswer(
    Message message,
    Poll poll, {
    required String answerText,
  }) {
    _checkInitialized();
    return _pollVoteLock.synchronized(
      () => _client.addPollAnswer(
        message.id,
        poll.id,
        answerText: answerText,
      ),
    );
  }

  /// Remove a vote on the given [poll] with the given [vote].
  Future<RemovePollVoteResponse> removePollVote(
    Message message,
    Poll poll,
    PollVote vote,
  ) {
    _checkInitialized();

    final voteId = vote.id;
    if (voteId == null) {
      throw ArgumentError('Vote id cannot be null');
    }

    return _pollVoteLock.synchronized(
      () => _client.removePollVote(
        message.id,
        poll.id,
        voteId,
      ),
    );
  }

  /// Query the poll votes for the given [pollId] with the given [filter] and
  /// [sort] options.
  Future<QueryPollVotesResponse> queryPollVotes(
    String pollId, {
    Filter? filter,
    SortOrder<PollVote>? sort,
    PaginationParams pagination = const PaginationParams(),
  }) {
    _checkInitialized();
    return _client.queryPollVotes(
      pollId,
      filter: filter,
      sort: sort,
      pagination: pagination,
    );
  }

  /// Create a reminder for the given [messageId].
  ///
  /// Optionally, provide a [remindAt] date to set when the reminder should
  /// be triggered. If not provided, the reminder will be created as a
  /// bookmark type instead.
  Future<CreateReminderResponse> createReminder(
    String messageId, {
    DateTime? remindAt,
  }) {
    _checkInitialized();
    return _client.createReminder(
      messageId,
      remindAt: remindAt,
    );
  }

  /// Update an existing reminder with the given [reminderId].
  ///
  /// Optionally, provide a [remindAt] date to set when the reminder should
  /// be triggered. If not provided, the reminder will be updated as a
  /// bookmark type instead.
  Future<UpdateReminderResponse> updateReminder(
    String messageId, {
    DateTime? remindAt,
  }) {
    _checkInitialized();
    return _client.updateReminder(
      messageId,
      remindAt: remindAt,
    );
  }

  /// Remove the reminder for the given [messageId].
  Future<EmptyResponse> deleteReminder(String messageId) {
    _checkInitialized();
    return _client.deleteReminder(messageId);
  }

  /// Send a reaction to this channel.
  ///
  /// Set [enforceUnique] to true to remove the existing user reaction.
  Future<SendReactionResponse> sendReaction(
    Message message,
    Reaction reaction, {
    bool skipPush = false,
    bool enforceUnique = false,
  }) async {
    _checkInitialized();

    final messageId = message.id;
    // ignore: parameter_assignments
    reaction = reaction.copyWith(
      messageId: messageId,
      user: _client.state.currentUser,
    );

    final updatedMessage = message.addMyReaction(
      reaction,
      enforceUnique: enforceUnique,
    );

    state?.updateMessage(updatedMessage);

    try {
      final reactionResp = await _client.sendReaction(
        messageId,
        reaction,
        skipPush: skipPush,
        enforceUnique: enforceUnique,
      );
      return reactionResp;
    } catch (_) {
      // Reset the message if the update fails. Use replace (not merge)
      // so the rollback wins over the optimistic local state — otherwise
      // `Message.updateWith`'s enrichment preservation would keep the
      // optimistic `ownReactions` for messages that previously had none.
      state?.replaceMessage(message);
      rethrow;
    }
  }

  /// Delete a reaction from this channel.
  Future<EmptyResponse> deleteReaction(
    Message message,
    Reaction reaction,
  ) async {
    _checkInitialized();

    final updatedMessage = message.deleteMyReaction(
      reactionType: reaction.type,
    );

    state?.updateMessage(updatedMessage);

    try {
      final deleteResponse = await _client.deleteReaction(
        message.id,
        reaction.type,
      );
      return deleteResponse;
    } catch (_) {
      // Reset the message if the update fails. Use replace (not merge)
      // for symmetry with `sendReaction` — see that method for context.
      state?.replaceMessage(message);
      rethrow;
    }
  }

  /// Sends an event to stop AI response generation, leaving the message in
  /// its current state.
  Future<EmptyResponse> stopAIResponse() async {
    return sendEvent(
      Event(
        type: EventType.aiIndicatorStop,
      ),
    );
  }

  /// Update the channel's [name].
  ///
  /// This is the same as calling [updatePartial] and providing a map with a
  /// 'name' key:
  ///
  /// ```dart
  /// channel.updatePartial(
  ///   set: {'name': 'Updated channel name'}
  /// );
  /// ```
  ///
  /// Instead do:
  /// ```dart
  /// channel.updateName('Updated channel name');
  /// ```
  Future<PartialUpdateChannelResponse> updateName(String name) => updatePartial(set: {'name': name});

  /// Update the channel's [image].
  ///
  /// This is the same as calling [updatePartial] and providing a map with an
  /// 'image' key:
  ///
  /// ```dart
  /// channel.updatePartial(
  ///   set: {'image': 'https://getstream.io/new-image'}
  /// );
  /// ```
  ///
  /// Instead do:
  /// ```dart
  /// channel.updateImage('https://getstream.io/new-image');
  /// ```
  Future<PartialUpdateChannelResponse> updateImage(String image) => updatePartial(set: {'image': image});

  /// Update the channel custom data. This replaces all of the channel data
  /// with the given [channelData].
  ///
  /// If you instead want to do a partial update, use [updatePartial].
  ///
  /// See, https://getstream.io/chat/docs/other-rest/channel_update/?language=dart
  /// for more information.
  Future<UpdateChannelResponse> update(
    Map<String, Object?> channelData, {
    Message? updateMessage,
  }) async {
    _checkInitialized();
    return _client.updateChannel(
      id!,
      type,
      channelData,
      message: updateMessage,
    );
  }

  /// A partial update can be used to set and unset specific custom data fields
  /// when it is necessary to retain additional custom data fields on the
  /// object.
  ///
  /// - [set] will add, or update existing attributes.
  /// - [unset] will remove the attributes with the provided list of
  /// values (keys).
  ///
  /// If you want to do a full update/replacement, use [update] instead.
  ///
  /// See, https://getstream.io/chat/docs/other-rest/channel_update/?language=dart
  /// for more information.
  Future<PartialUpdateChannelResponse> updatePartial({
    Map<String, Object?>? set,
    List<String>? unset,
  }) async {
    _checkInitialized();
    return _client.updateChannelPartial(id!, type, set: set, unset: unset);
  }

  /// Enable slow mode
  Future<PartialUpdateChannelResponse> enableSlowMode({
    required int cooldownInterval,
  }) async {
    _checkInitialized();
    return _client.enableSlowdown(id!, type, cooldownInterval);
  }

  /// Disable slow mode
  Future<PartialUpdateChannelResponse> disableSlowMode() async {
    _checkInitialized();
    return _client.disableSlowdown(id!, type);
  }

  /// Delete this channel. Messages are permanently removed.
  Future<EmptyResponse> delete() async {
    _checkInitialized();
    return _client.deleteChannel(id!, type);
  }

  /// Removes all messages from the channel up to [truncatedAt] or now if
  /// [truncatedAt] is not provided.
  /// If [skipPush] is true, no push notification will be sent.
  /// [Message] is the system message that will be sent to the channel.
  Future<EmptyResponse> truncate({
    Message? message,
    bool? skipPush,
    DateTime? truncatedAt,
  }) async {
    _checkInitialized();
    return _client.truncateChannel(
      id!,
      type,
      message: message,
      skipPush: skipPush,
      truncatedAt: truncatedAt,
    );
  }

  /// Accept invitation to the channel.
  Future<AcceptInviteResponse> acceptInvite([Message? message]) async {
    _checkInitialized();
    return _client.acceptChannelInvite(id!, type, message: message);
  }

  /// Reject invitation to the channel.
  Future<RejectInviteResponse> rejectInvite([Message? message]) async {
    _checkInitialized();
    return _client.rejectChannelInvite(id!, type, message: message);
  }

  /// Add members to the channel.
  Future<AddMembersResponse> addMembers(
    List<String> memberIds, {
    Message? message,
    bool hideHistory = false,
    DateTime? hideHistoryBefore,
  }) async {
    _checkInitialized();
    return _client.addChannelMembers(
      id!,
      type,
      memberIds,
      message: message,
      hideHistory: hideHistory,
      hideHistoryBefore: hideHistoryBefore,
    );
  }

  /// Invite members to the channel.
  Future<InviteMembersResponse> inviteMembers(
    List<String> memberIds, {
    Message? message,
  }) async {
    _checkInitialized();
    return _client.inviteChannelMembers(id!, type, memberIds, message: message);
  }

  /// Remove members from the channel.
  Future<RemoveMembersResponse> removeMembers(
    List<String> memberIds, {
    Message? message,
  }) async {
    _checkInitialized();
    return _client.removeChannelMembers(id!, type, memberIds, message: message);
  }

  /// Send action for a specific message of this channel.
  Future<SendActionResponse> sendAction(
    Message message,
    Map<String, dynamic> formData,
  ) async {
    _checkInitialized();
    final messageId = message.id;
    final res = await _client.sendAction(id!, type, messageId, formData);

    // update the passed message with response message
    if (res.message != null) {
      state!.updateMessage(res.message!);
    } else {
      // remove the passed message if response does
      // not contain message
      state!.removeMessage(message);
    }
    return res;
  }

  /// Mark all messages as read.
  ///
  /// Optionally provide a [messageId] if you want to mark channel as
  /// read from a particular message onwards.
  ///
  /// If [usesLocalUnreadCount] is `true` for this channel, this updates the
  /// unread count locally, on-device, without making a network request. In
  /// that case [messageId] is recorded as the read boundary but does **not**
  /// narrow the count: the channel is always treated as fully read and the
  /// count drops to zero. See [ChannelClientState.markReadLocally].
  Future<EmptyResponse> markRead({String? messageId}) async {
    _checkInitialized();

    if (usesLocalUnreadCount) {
      state!.markReadLocally(messageId: messageId);
      return EmptyResponse();
    }

    if (!canUseReadReceipts) {
      throw const StreamChatError(
        'Cannot mark as read: Channel does not support read events. '
        'Enable read_events in your channel type configuration.',
      );
    }

    return _client.markChannelRead(id!, type, messageId: messageId);
  }

  /// Marks the channel as unread by a given [messageId].
  ///
  /// All messages from the provided message onwards will be marked as unread,
  /// **including** the message itself. Contrast with
  /// [markUnreadByTimestamp], which is exclusive: a message created at
  /// exactly the given timestamp stays read.
  ///
  /// If [usesLocalUnreadCount] is `true` for this channel, this updates the
  /// unread count locally, on-device, without making a network request. The
  /// message must be part of the locally-known messages ([Channel.messages])
  /// for the count to be recomputed.
  Future<EmptyResponse> markUnread(String messageId) async {
    _checkInitialized();

    if (usesLocalUnreadCount) {
      // [ChannelClientState.messages] is sorted ascending by `createdAt`, so
      // the entry before the anchor is the newest message that stays read.
      final messages = state!.messages;
      final anchorIndex = messages.indexWhere((it) => it.id == messageId);
      if (anchorIndex < 0) {
        throw StreamChatError(
          'Cannot mark as unread: Message "$messageId" was not found in the '
          'locally-known messages for this channel.',
        );
      }

      final anchor = messages[anchorIndex];
      final previous = anchorIndex > 0 ? messages[anchorIndex - 1] : null;

      // Subtract a microsecond so the anchor message itself is treated as
      // "after" the new read boundary, matching the "from the provided
      // message onwards" semantics described above. Preferred over using
      // `previous.createdAt` as the boundary, which would leak the anchor
      // back into the read set if the two share an identical `createdAt`.
      final lastRead = anchor.createdAt.subtract(const Duration(microseconds: 1));
      state!.markUnreadLocally(lastRead: lastRead, lastReadMessageId: previous?.id);
      return EmptyResponse();
    }

    if (!canUseReadReceipts) {
      throw const StreamChatError(
        'Cannot mark as unread: Channel does not support read events. '
        'Enable read_events in your channel type configuration.',
      );
    }

    return _client.markChannelUnread(id!, type, messageId);
  }

  /// Marks the channel as unread by a given [timestamp].
  ///
  /// All messages after the provided timestamp will be marked as unread. This
  /// boundary is **exclusive**: a message created at exactly [timestamp] stays
  /// read. Contrast with [markUnread], which is inclusive of the message it is
  /// given — `markUnread(m.id)` is equivalent to
  /// `markUnreadByTimestamp(m.createdAt - 1µs)`, not to
  /// `markUnreadByTimestamp(m.createdAt)`.
  ///
  /// If [usesLocalUnreadCount] is `true` for this channel, this updates the
  /// unread count locally, on-device, without making a network request.
  Future<EmptyResponse> markUnreadByTimestamp(DateTime timestamp) async {
    _checkInitialized();

    if (usesLocalUnreadCount) {
      // The newest locally-known message at or before the boundary is the last
      // one that stays read.
      final lastReadMessage = state!.messages.lastWhereOrNull(
        (it) => !it.createdAt.isAfter(timestamp),
      );

      state!.markUnreadLocally(
        lastRead: timestamp,
        lastReadMessageId: lastReadMessage?.id,
      );
      return EmptyResponse();
    }

    if (!canUseReadReceipts) {
      throw const StreamChatError(
        'Cannot mark as unread: Channel does not support read events. '
        'Enable read_events in your channel type configuration.',
      );
    }

    return _client.markChannelUnreadByTimestamp(id!, type, timestamp);
  }

  /// Mark the thread with [threadId] in the channel as read.
  Future<EmptyResponse> markThreadRead(String threadId) async {
    _checkInitialized();

    if (!canUseReadReceipts) {
      throw const StreamChatError(
        'Cannot mark thread as read: Channel does not support read events. '
        'Enable read_events in your channel type configuration.',
      );
    }

    return _client.markThreadRead(id!, type, threadId);
  }

  /// Mark the thread with [threadId] in the channel as unread.
  Future<EmptyResponse> markThreadUnread(String threadId) async {
    _checkInitialized();

    if (!canUseReadReceipts) {
      throw const StreamChatError(
        'Cannot mark thread as unread: Channel does not support read events. '
        'Enable read_events in your channel type configuration.',
      );
    }

    return _client.markThreadUnread(id!, type, threadId);
  }

  void _initState(ChannelState channelState) {
    state = ChannelClientState(this, channelState);
    _initializedCompleter.safeComplete(true);

    if (cid case final cid?) client.state.addChannels({cid: this});
    _client.logger.info('Channel ${channelState.channel?.cid} initialized');
  }

  /// Loads the initial channel state and watches for changes.
  Future<ChannelState> watch({
    bool presence = false,
    PaginationParams? messagesPagination,
    PaginationParams? membersPagination,
    PaginationParams? watchersPagination,
  }) {
    return query(
      watch: true,
      presence: presence,
      messagesPagination: messagesPagination,
      membersPagination: membersPagination,
      watchersPagination: watchersPagination,
    );
  }

  /// Stop watching the channel.
  Future<EmptyResponse> stopWatching() async {
    _checkInitialized();
    return _client.stopChannelWatching(id!, type);
  }

  /// List the message replies for a parent message.
  ///
  /// Set [preferOffline] to true to avoid the api call if the data is already
  /// in the offline storage.
  Future<QueryRepliesResponse> getReplies(
    String parentId, {
    PaginationParams? options,
    bool preferOffline = false,
  }) async {
    QueryRepliesResponse? response;

    // If we prefer offline, we first try to get the replies from the
    // offline storage.
    if (preferOffline) {
      if (_client.chatPersistenceClient case final persistenceClient?) {
        final cachedReplies = await persistenceClient.getReplies(
          parentId,
          options: options,
        );

        // If the cached replies are not empty, we can use them.
        if (cachedReplies.isNotEmpty) {
          response = QueryRepliesResponse()..messages = cachedReplies;
        }
      }
    }

    // If we still don't have the replies, we try to get them from the API.
    response ??= await _client.getReplies(parentId, options: options);

    // Before updating the state, we check if we are querying around a
    // reply, If we are, we have to clear the state to avoid potential
    // gaps in the message sequence.
    final isQueryingAround = switch (options) {
      PaginationParams(idAround: _?) => true,
      PaginationParams(createdAtAround: _?) => true,
      _ => false,
    };

    if (isQueryingAround) state?.clearThread(parentId);
    state?.updateThreadInfo(parentId, response.messages);

    return response;
  }

  /// List the reactions for a message in the channel.
  Future<QueryReactionsResponse> getReactions(
    String messageId, {
    PaginationParams? pagination,
  }) => _client.getReactions(
    messageId,
    pagination: pagination,
  );

  /// Retrieves a list of messages by given [messageIDs].
  Future<GetMessagesByIdResponse> getMessagesById(
    List<String> messageIDs,
  ) async {
    _checkInitialized();
    return _client.getMessagesById(id!, type, messageIDs);
  }

  /// Translate a message by given [messageId] and [language].
  Future<TranslateMessageResponse> translateMessage(
    String messageId,
    String language,
  ) => _client.translateMessage(
    messageId,
    language,
  );

  /// Creates a new channel.
  Future<ChannelState> create() => query(state: false);

  /// Query the API, get messages, members or other channel fields.
  ///
  /// Set [preferOffline] to true to avoid the API call if the data is already
  /// in the offline storage.
  Future<ChannelState> query({
    bool state = true,
    bool watch = false,
    bool presence = false,
    PaginationParams? messagesPagination,
    PaginationParams? membersPagination,
    PaginationParams? watchersPagination,
    bool preferOffline = false,
  }) async {
    // A prior failed init left the completer errored; reset it so this attempt
    // owns the `initialized` result. Must stay before the first `await` so a
    // caller reading `initialized` right after `query()`/`watch()` begins sees
    // the fresh completer.
    if (_initializedCompleter.isCompleted && this.state == null) {
      _initializedCompleter = Completer<bool>();
    }

    ChannelState? channelState;

    try {
      // If we prefer offline, we first try to get the channel state from the
      // offline storage.
      if (preferOffline && !watch && cid != null) {
        final persistenceClient = _client.chatPersistenceClient;
        if (persistenceClient != null) {
          final cachedState = await persistenceClient.getChannelStateByCid(
            cid!,
            messagePagination: messagesPagination,
          );

          // If the cached state contains messages, we can use it.
          if (cachedState.messages?.isNotEmpty == true) {
            channelState = cachedState;
          }
        }
      }

      // If we still don't have the channelState, we try to get it from the API.
      channelState ??= await _client.queryChannel(
        type,
        channelId: id,
        channelData: _extraData,
        state: state,
        watch: watch,
        presence: presence,
        messagesPagination: messagesPagination,
        membersPagination: membersPagination,
        watchersPagination: watchersPagination,
      );

      if (_id == null) {
        _id = channelState.channel!.id;
        _cid = channelState.channel!.cid;
      }

      // Initialize the channel state if it's not initialized yet.
      if (this.state == null) {
        _initState(channelState);
      } else {
        // Otherwise, we update the existing state with the new channel state.
        //
        // But, before updating the state, we check if we are querying around a
        // message, If we are, we have to truncate the state to avoid potential
        // gaps in the message sequence.
        final isQueryingAround = switch (messagesPagination) {
          PaginationParams(idAround: _?) => true,
          PaginationParams(createdAtAround: _?) => true,
          _ => false,
        };

        if (isQueryingAround) this.state?.truncate();
        this.state?.updateChannelStateFromServer(channelState);
      }

      // Submit for delivery reporting only when fetching the latest messages.
      // This happens when no pagination params are provided (initial query).
      if (messagesPagination == null) {
        _client.channelDeliveryReporter.submitForDelivery([this]);
      }

      return channelState;
    } catch (e, stk) {
      // If we failed to get the channel state from the API and we were not
      // supposed to watch the channel, we will try to get the channel state
      // from the offline storage.
      if (watch == false) {
        if (_client.persistenceEnabled) {
          return _client.chatPersistenceClient!.getChannelStateByCid(
            cid!,
            messagePagination: messagesPagination,
          );
        }
      }

      // Otherwise, we will just rethrow the error.
      _initializedCompleter.safeCompleteError(e, stk);

      rethrow;
    }
  }

  /// Query channel members.
  Future<QueryMembersResponse> queryMembers({
    Filter? filter,
    SortOrder<Member>? sort,
    PaginationParams? pagination,
  }) => _client.queryMembers(
    type,
    channelId: id,
    filter: filter,
    members: state?.members,
    sort: sort,
    pagination: pagination,
  );

  /// Query channel banned users.
  Future<QueryBannedUsersResponse> queryBannedUsers({
    Filter? filter,
    SortOrder<BannedUser>? sort,
    PaginationParams? pagination,
  }) {
    _checkInitialized();
    filter ??= Filter.equal('channel_cid', cid!);
    return _client.queryBannedUsers(
      filter: filter,
      sort: sort,
      pagination: pagination,
    );
  }

  // Timer to keep track of mute expiration. This is used to update the channel
  // state when the mute expires.
  Timer? _muteExpirationTimer;

  /// Mutes the channel.
  Future<EmptyResponse> mute({Duration? expiration}) {
    _checkInitialized();

    // If there is a expiration set, we will set a timer to automatically unmute
    // the channel when the mute expires.
    if (expiration != null) {
      _muteExpirationTimer?.cancel();
      _muteExpirationTimer = Timer(expiration, unmute);
    }

    return _client.muteChannel(cid!, expiration: expiration);
  }

  /// Unmute the channel.
  Future<EmptyResponse> unmute() {
    _checkInitialized();

    // Cancel the mute expiration timer if it is set.
    _muteExpirationTimer?.cancel();
    _muteExpirationTimer = null;

    return _client.unmuteChannel(cid!);
  }

  /// Bans the member with given [userID] from the channel.
  Future<EmptyResponse> banMember(
    String userID,
    Map<String, dynamic> options,
  ) async {
    _checkInitialized();
    final opts = Map<String, dynamic>.from(options)
      ..addAll({
        'type': type,
        'id': id,
      });
    return _client.banUser(userID, opts);
  }

  /// Remove the ban for the member with given [userID] in the channel.
  Future<EmptyResponse> unbanMember(String userID) async {
    _checkInitialized();
    return _client.unbanUser(userID, {
      'type': type,
      'id': id,
    });
  }

  /// Shadow bans the user with the given [userID] from the channel.
  Future<EmptyResponse> shadowBan(
    String userID,
    Map<String, dynamic> options,
  ) async {
    _checkInitialized();
    final opts = Map<String, dynamic>.from(options)
      ..addAll({
        'type': type,
        'id': id,
      });
    return _client.shadowBan(userID, opts);
  }

  /// Remove the shadow ban for the user with the given [userID] in the channel.
  Future<EmptyResponse> removeShadowBan(String userID) async {
    _checkInitialized();
    return _client.removeShadowBan(userID, {
      'type': type,
      'id': id,
    });
  }

  /// Hides the channel from [StreamChatClient.queryChannels] for the user
  /// until a message is added.
  ///
  /// If [clearHistory] is set to true - all messages
  /// will be removed for the user.
  Future<EmptyResponse> hide({bool clearHistory = false}) async {
    _checkInitialized();
    return _client.hideChannel(
      id!,
      type,
      clearHistory: clearHistory,
    );
  }

  /// Removes the hidden status for the channel.
  Future<EmptyResponse> show() async {
    _checkInitialized();
    return _client.showChannel(id!, type);
  }

  /// Pins the channel for the current user.
  Future<Member> pin() async {
    _checkInitialized();

    final response = await _client.pinChannel(
      channelId: id!,
      channelType: type,
    );

    return response.channelMember;
  }

  /// Unpins the channel.
  Future<Member?> unpin() async {
    _checkInitialized();

    final response = await _client.unpinChannel(
      channelId: id!,
      channelType: type,
    );

    return response.channelMember;
  }

  /// Archives the channel.
  Future<Member?> archive() async {
    _checkInitialized();

    final response = await _client.archiveChannel(
      channelId: id!,
      channelType: type,
    );

    return response.channelMember;
  }

  /// Unarchives the channel for the current user.
  Future<Member?> unarchive() async {
    _checkInitialized();

    final response = await _client.unarchiveChannel(
      channelId: id!,
      channelType: type,
    );

    return response.channelMember;
  }

  /// Stream of [Event] coming from websocket connection specific for the
  /// channel. Pass an eventType as parameter in order to filter just a type
  /// of event.
  Stream<Event> on([
    String? eventType,
    String? eventType2,
    String? eventType3,
    String? eventType4,
  ]) => _client
      .on(
        eventType,
        eventType2,
        eventType3,
        eventType4,
      )
      .where((e) => e.cid == cid);

  late final _keyStrokeHandler = KeyStrokeHandler(
    onStartTyping: startTyping,
    onStopTyping: stopTyping,
  );

  // Whether sending typing events is allowed in the channel and by the user
  // privacy settings.
  bool get _canSendTypingEvents {
    final currentUser = client.state.currentUser;
    if (currentUser == null) return false;

    return canUseTypingEvents && currentUser.isTypingIndicatorsEnabled;
  }

  /// Sends the [Event.typingStart] event and schedules a timer to invoke the
  /// [Event.typingStop] event.
  ///
  /// This is meant to be called every time the user presses a key.
  Future<void> keyStroke([String? parentId]) async {
    if (!_canSendTypingEvents) return;

    client.logger.info('KeyStroke received');
    return _keyStrokeHandler(parentId);
  }

  /// Sends the [EventType.typingStart] event.
  Future<void> startTyping([String? parentId]) async {
    if (!_canSendTypingEvents) return;

    client.logger.info('start typing');
    await sendEvent(
      Event(
        type: EventType.typingStart,
        parentId: parentId,
      ),
    );
  }

  /// Sends the [EventType.typingStop] event.
  Future<void> stopTyping([String? parentId]) async {
    if (!_canSendTypingEvents) return;

    client.logger.info('stop typing');
    await sendEvent(
      Event(
        type: EventType.typingStop,
        parentId: parentId,
      ),
    );
  }

  /// Call this method to dispose the channel client.
  void dispose() {
    client.state.removeChannel('$cid');
    state?.dispose();
    state = null;
    _muteExpirationTimer?.cancel();
    _keyStrokeHandler.cancel();
  }

  void _checkInitialized() {
    if (_isInitialized) return;

    throw StateError(
      "Channel $cid hasn't been initialized yet or has been disposed. "
      'Make sure to call .watch() or instantiate the client using '
      '[Channel.fromState]',
    );
  }
}
