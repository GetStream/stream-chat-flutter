// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_core/stream_core.dart' show runSafely;
import 'package:synchronized/synchronized.dart';

import '../../../stream_chat.dart';
import '../../repository/mapper/result_mapper.dart';

/// The maximum time the incoming [Event.typingStart] event is valid before a
/// [Event.typingStop] event is emitted automatically.
const incomingTypingStartEventTimeout = 7;

/// Class that manages a specific channel.
///
/// #### Channel name
///
/// {@template name}
/// If an optional [name] argument is provided in the constructor then it
/// will be set on [custom] with a key of 'name'.
///
/// ```dart
/// final channel = Channel(client, type, id, name: 'Channel name');
/// print(channel.name == channel.custom['name']); // true
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
/// will be set on [custom] with a key of 'image'.
///
/// ```dart
/// final channel = Channel(client, type, id, image: 'https://getstream.io/image.png');
/// print(channel.image == channel.custom['image']); // true
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
  /// Creates a channel of [type] with the id [id].
  ///
  /// The channel starts with [custom] as its custom data. A [name] or [image]
  /// is stored in it under the `name` or `image` key, replacing any entry
  /// [custom] has for that key.
  Channel(
    this._client,
    this._type,
    this._id, {
    String? name,
    String? image,
    Map<String, Object?>? custom,
  }) : _cid = _id != null ? '$_type:$_id' : null,
       _custom = {
         ...?custom,
         if (name != null) 'name': name,
         if (image != null) 'image': image,
       } {
    _logger.d(() => 'New Channel instance created, not yet initialized');
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
      _custom = channelState.channel!.custom {
    _initState(channelState); // Initialize the state immediately.
  }

  late final _logger = StreamLogger('SCh:Channel:$cid');

  /// This client state
  ChannelClientState? state;

  /// The channel type
  final String _type;

  String? _id;
  String? _cid;
  final Map<String, Object?> _custom;

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
    _custom.addAll({'name': name});
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
    _custom.addAll({'image': image});
  }

  set custom(Map<String, Object?> custom) {
    if (_isInitialized) {
      throw StateError(
        'Once the channel is initialized you should use `channel.update` '
        'to update channel data',
      );
    }
    _custom.addAll(custom);
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
    return state!.channelStateStream.map((cs) => cs.channel?.frozen == true).distinct();
  }

  /// Channel disabled status.
  bool get disabled {
    _checkInitialized();
    return state!.channelState.channel?.disabled == true;
  }

  /// Channel disabled status as a stream.
  Stream<bool> get disabledStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.disabled == true).distinct();
  }

  /// Channel hidden status.
  bool get hidden {
    _checkInitialized();
    return state!.channelState.channel?.hidden == true;
  }

  /// Channel hidden status as a stream.
  Stream<bool> get hiddenStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.hidden == true).distinct();
  }

  /// Channel blocked status.
  /// Status is specific to the current user.
  bool get blocked {
    _checkInitialized();
    return state!.channelState.channel?.blocked == true;
  }

  /// Channel blocked status as a stream.
  /// Status is specific to the current user.
  Stream<bool> get blockedStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.blocked == true).distinct();
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
    return membershipStream.map((m) => m?.pinnedAt != null).distinct();
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
    return membershipStream.map((m) => m?.archivedAt != null).distinct();
  }

  /// The last date at which the channel got truncated.
  DateTime? get truncatedAt {
    _checkInitialized();
    return state!.channelState.channel?.truncatedAt;
  }

  /// The last date at which the channel got truncated as a stream.
  Stream<DateTime?> get truncatedAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.truncatedAt).distinct();
  }

  /// Cooldown count
  int get cooldown {
    _checkInitialized();
    return state!.channelState.channel?.cooldown ?? 0;
  }

  /// Cooldown count as a stream
  Stream<int> get cooldownStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.cooldown ?? 0).distinct();
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
    return state!.channelStateStream.map((cs) => cs.channel?.createdAt).distinct();
  }

  /// Channel last message date.
  DateTime? get lastMessageAt {
    _checkInitialized();
    return state!.channelState.channel?.lastMessageAt;
  }

  /// Channel last message date as a stream.
  Stream<DateTime?> get lastMessageAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.lastMessageAt).distinct();
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
    return state!.channelStateStream.map((cs) => cs.channel?.updatedAt).distinct();
  }

  /// Channel deletion date.
  DateTime? get deletedAt {
    _checkInitialized();
    return state!.channelState.channel?.deletedAt;
  }

  /// Channel deletion date as a stream.
  Stream<DateTime?> get deletedAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.deletedAt).distinct();
  }

  /// Channel member count.
  int? get memberCount {
    _checkInitialized();
    return state!.channelState.channel?.memberCount;
  }

  /// Channel member count as a stream.
  Stream<int?> get memberCountStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.memberCount).distinct();
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
    return state!.channelStateStream.map((cs) => cs.channel?.messageCount).distinct();
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

  /// This channel's custom data.
  ///
  /// Before the channel is initialized, this is the custom data it was created
  /// with, updated by any assignment to [name], [image] or [custom].
  Map<String, Object?> get custom => state?.channelState.channel?.custom ?? _custom;

  /// List of user permissions on this channel
  List<ChannelCapability> get ownCapabilities => state?.channelState.channel?.ownCapabilities ?? [];

  /// List of user permissions on this channel
  Stream<List<ChannelCapability>> get ownCapabilitiesStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.ownCapabilities ?? []).distinct();
  }

  /// This channel's custom data as a stream.
  Stream<Map<String, Object?>> get customStream {
    _checkInitialized();
    return state!.channelStateStream.map(
      (cs) => cs.channel?.custom ?? _custom,
    );
  }

  /// Shortcut to get channel name.
  ///
  /// {@macro name}
  String? get name => custom['name'] as String?;

  /// Channel [name] as a stream.
  ///
  /// The channel needs to be initialized.
  ///
  /// {@macro name}
  Stream<String?> get nameStream {
    _checkInitialized();
    return customStream.map((it) => it['name'] as String?).distinct();
  }

  /// Shortcut to get channel image.
  ///
  /// {@macro image}
  String? get image => custom['image'] as String?;

  /// Channel [image] as a stream.
  ///
  /// The channel needs to be initialized.
  ///
  /// {@macro image}
  Stream<String?> get imageStream {
    _checkInitialized();
    return customStream.map((it) => it['image'] as String?).distinct();
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
      throw StateError(
        "Upload request for attachment '$attachmentId' hasn't started yet, or has already completed.",
      );
    }
    if (cancelToken.isCancelled) {
      throw StateError("Upload request for attachment '$attachmentId' was already cancelled.");
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
      throw const StreamClientException(message: 'Error, Message not found');
    }

    final attachments = message.attachments.where((it) {
      if (it.uploadState.isSuccess) return false;
      return attachmentIds.contains(it.id);
    });

    if (attachments.isEmpty) {
      _logger.d(() => 'No attachments available to upload');
      if (message.attachments.every((it) => it.uploadState.isSuccess)) {
        _messageAttachmentsUploadCompleter.remove(messageId)?.complete(message);
      }
      return Future.value();
    }

    _logger.d(() => 'Found ${attachments.length} attachments');

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
      attachments.map((it) async {
        _logger.d(() => 'Uploading ${it.id} attachment...');

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

        final cancelToken = CancelToken();
        _cancelableAttachmentUploadRequest[it.id] = cancelToken;

        final isImage = it.type == AttachmentType.image;
        final upload = isImage ? sendImage : sendFile;

        final result = await upload(
          it.file!,
          onSendProgress: onSendProgress,
          cancelToken: cancelToken,
          extraData: it.custom,
        );

        throttledUpdateAttachment.cancel();
        _cancelableAttachmentUploadRequest.remove(it.id);

        if (result case Success(data: final uploaded)) {
          _logger.d(() => 'Attachment ${it.id} uploaded successfully...');
          updateAttachment(
            it.copyWith(
              imageUrl: isImage ? uploaded.fileUrl : null,
              assetUrl: isImage ? null : uploaded.fileUrl,
              thumbUrl: uploaded.thumbUrl,
              uploadState: const UploadState.success(),
            ),
          );
          return;
        }

        if (result case Failure(error: StreamNetworkException(isCancelled: true))) {
          _logger.d(() => 'Attachment ${it.id} upload cancelled');
          updateAttachment(it, remove: true);
          return;
        }

        if (result case Failure(:final error, :final stackTrace)) {
          _logger.e(() => 'error uploading the attachment', error: error, stackTrace: stackTrace);
          updateAttachment(it.copyWith(uploadState: UploadState.failed(error: error.toString())));
        }
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
  Future<Result<SendMessageResponse>> sendMessage(
    Message message, {
    bool skipPush = false,
    bool skipEnrichUrl = false,
  }) async {
    _checkInitialized();

    // Clean up stale error messages before sending a new message.
    state?.cleanUpStaleErrorMessages();

    // Cancelling previous completer in case it's called again in the process
    // Eg. Updating the message while the previous call is in progress.
    const cancelled = StreamNetworkException(message: 'Message cancelled', isCancelled: true);
    _messageAttachmentsUploadCompleter.remove(message.id)?.completeError(cancelled);

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

    final result = await _runCatching(failureMessage: 'Failed to send the message', () async {
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
        if (message.attachments.where((it) => it.uploadState.isFailed) case final failed when failed.isNotEmpty) {
          throw StreamClientException(message: _uploadFailureMessage(failed));
        }
      }

      // Validate the final message before sending it.
      if (MessageRules.canUpload(message) != true) {
        _logger.w(() => 'Message is not valid for sending, removing it');

        // Remove the message from state as it is invalid.
        state!.deleteMessage(message, hardDelete: true);
        throw const StreamClientException(message: 'Message is not valid for sending');
      }

      // Wait for the previous sendMessage call to finish. Otherwise, the order
      // of messages will not be maintained.
      return _sendMessageLock.synchronized(
        () => _client.sendMessage(
          message,
          id!,
          type,
          skipPush: skipPush,
          skipEnrichUrl: skipEnrichUrl,
        ),
      );
    });

    switch (result) {
      case Success(data: final response):
        final sentMessage = message
            .updateWith(response.message)
            .copyWith(
              // Update the message state to sent.
              state: MessageState.sent,
            );

        state?.updateMessage(sentMessage);
      case Failure(:final error):
        final failedMessage = message.copyWith(
          // Update the message state to failed.
          state: MessageState.sendingFailed(
            skipPush: skipPush,
            skipEnrichUrl: skipEnrichUrl,
          ),
        );

        state?.updateMessage(failedMessage);
        // If the error is retriable, add it to the retry queue.
        if (error is StreamChatException && error.isRetriable) {
          state?.scheduleRetry(failedMessage);
        }
    }

    return result;
  }

  final _updateMessageLock = Lock();

  /// Updates the [message] in this channel.
  ///
  /// Waits for a [_messageAttachmentsUploadCompleter] to complete
  /// before actually updating the message.
  Future<Result<UpdateMessageResponse>> updateMessage(
    Message message, {
    bool skipPush = false,
    bool skipEnrichUrl = false,
  }) async {
    _checkInitialized();

    // Cancelling previous completer in case it's called again in the process
    // Eg. Updating the message while the previous call is in progress.
    const cancelled = StreamNetworkException(message: 'Message cancelled', isCancelled: true);
    _messageAttachmentsUploadCompleter.remove(message.id)?.completeError(cancelled);

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

    final result = await _runCatching(failureMessage: 'Failed to update the message', () async {
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
        if (message.attachments.where((it) => it.uploadState.isFailed) case final failed when failed.isNotEmpty) {
          throw StreamClientException(message: _uploadFailureMessage(failed));
        }
      }

      // Wait for the previous update call to finish. Otherwise, the order of
      // messages will not be maintained.
      return _updateMessageLock.synchronized(
        () => _client.updateMessage(
          message,
          skipPush: skipPush,
          skipEnrichUrl: skipEnrichUrl,
        ),
      );
    });

    switch (result) {
      case Success(data: final response):
        final updateMessage = message
            .updateWith(response.message)
            .copyWith(
              // Update the message state to updated.
              state: MessageState.updated,
            );

        state?.updateMessage(updateMessage);
      case Failure(:final error):
        final failedMessage = message.copyWith(
          // Update the message state to failed.
          state: MessageState.updatingFailed(
            skipPush: skipPush,
            skipEnrichUrl: skipEnrichUrl,
          ),
        );

        state?.updateMessage(failedMessage);
        // If the error is retriable, add it to the retry queue.
        if (error is StreamChatException && error.isRetriable) {
          state?.scheduleRetry(failedMessage);
        }
    }

    return result;
  }

  /// Sets the fields in [set] and removes the fields named in [unset] on
  /// [message].
  Future<Result<UpdateMessagePartialResponse>> updateMessagePartial(
    Message message, {
    Map<String, Object?>? set,
    List<String>? unset,
    bool skipEnrichUrl = false,
  }) async {
    _checkInitialized();

    // Cancelling previous completer in case it's called again in the process
    // Eg. Updating the message while the previous call is in progress.
    const cancelled = StreamNetworkException(message: 'Message cancelled', isCancelled: true);
    _messageAttachmentsUploadCompleter.remove(message.id)?.completeError(cancelled);

    // ignore: parameter_assignments
    message = message.copyWith(
      state: MessageState.updating,
      localUpdatedAt: DateTime.now(),
    );

    state?.updateMessage(message);

    // Wait for the previous update call to finish. Otherwise, the order of
    // messages will not be maintained.
    final result = await _updateMessageLock.synchronized(
      () => _client.updateMessagePartial(
        message.id,
        set: set,
        unset: unset,
        skipEnrichUrl: skipEnrichUrl,
      ),
    );

    switch (result) {
      case Success(data: final response):
        final updatedMessage = message
            .updateWith(response.message)
            .copyWith(
              // Update the message state to updated.
              state: MessageState.updated,
            );

        state?.updateMessage(updatedMessage);
      case Failure(:final error):
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
        if (error is StreamChatException && error.isRetriable) {
          state?.scheduleRetry(failedMessage);
        }
    }

    return result;
  }

  final _deleteMessageLock = Lock();

  /// Deletes the [message] for everyone.
  ///
  /// If [hard] is true, the message is permanently deleted and cannot be
  /// recovered. In this case, any attachments associated with the message are
  /// deleted as well.
  Future<Result<DeleteMessageResponse>> deleteMessage(Message message, {bool hard = false}) {
    final deletionScope = MessageDeleteScope.deleteForAll(hard: hard);

    return _deleteMessage(message, scope: deletionScope);
  }

  /// Deletes the [message] only for the current user.
  ///
  /// Note: This does not delete the message for other channel members and
  /// they can still see the message.
  Future<Result<DeleteMessageResponse>> deleteMessageForMe(Message message) {
    const deletionScope = MessageDeleteScope.deleteForMe();

    return _deleteMessage(message, scope: deletionScope);
  }

  // Deletes the [message] from the channel.
  //
  // The [scope] defines whether to delete the message for everyone or just
  // for the current user.
  //
  // If the message is a local message (not yet sent) or a bounced
  // error message, it is deleted locally without making an API call.
  //
  // If the message is deleted for everyone and [scope.hard] is true, the
  // message is permanently deleted and cannot be recovered. In this case, any
  // attachments associated with the message are deleted as well.
  Future<Result<DeleteMessageResponse>> _deleteMessage(
    Message message, {
    required MessageDeleteScope scope,
  }) async {
    _checkInitialized();

    // Directly deleting the local messages and bounced error messages as they
    // were never sent.
    if (message.remoteCreatedAt == null || message.isBouncedWithError) {
      final deletedMessage = _deleteLocalMessage(message);
      return Result.success(DeleteMessageResponse(duration: '0ms', message: deletedMessage));
    }

    // ignore: parameter_assignments
    message = message.copyWith(
      type: MessageType.deleted,
      deletedAt: DateTime.now(),
      deletedForMe: scope is DeleteForMe,
      state: MessageState.deleting(scope: scope),
    );

    state?.deleteMessage(message, hardDelete: scope.hard);

    // Wait for the previous delete call to finish. Otherwise, the order of
    // messages will not be maintained.
    final result = await _deleteMessageLock.synchronized(
      () => switch (scope) {
        DeleteForMe() => _client.deleteMessageForMe(message.id),
        DeleteForAll() => _client.deleteMessage(message.id, hard: scope.hard),
      },
    );

    switch (result) {
      case Success():
        final deletedMessage = message.copyWith(
          deletedForMe: scope is DeleteForMe,
          state: MessageState.deleted(scope: scope),
        );

        state?.deleteMessage(deletedMessage, hardDelete: scope.hard);
        // If hard delete, also delete the uploaded attachments.
        if (scope.hard) _deleteMessageAttachments(deletedMessage);
      case Failure(:final error):
        final failedMessage = message.copyWith(
          // Update the message state to failed.
          state: MessageState.deletingFailed(scope: scope),
        );

        state?.deleteMessage(failedMessage, hardDelete: scope.hard);
        // If the error is retriable, add it to the retry queue.
        if (error is StreamChatException && error.isRetriable) {
          state?.scheduleRetry(failedMessage);
        }
    }

    return result;
  }

  // Deletes a local [message] that is not yet sent, and returns it as deleted.
  //
  // This is typically called when a user wants to delete a message that they
  // have composed but not yet sent, or if a message failed to send and the user
  // wants to remove it from their local view.
  Message _deleteLocalMessage(Message message) {
    final deletedMessage = message.copyWith(
      type: MessageType.deleted,
      localDeletedAt: DateTime.now(),
      state: MessageState.hardDeleted,
    );

    state?.deleteMessage(
      hardDelete: true, // Local messages are always hard deleted.
      deletedMessage,
    );

    // Removing the attachments upload completer to stop the `sendMessage`
    // waiting for attachments to complete.
    final completer = _messageAttachmentsUploadCompleter.remove(message.id);
    completer?.completeError(
      const StreamNetworkException(message: 'Message deleted', isCancelled: true),
    );

    return deletedMessage;
  }

  // Deletes all the uploaded attachments associated with the given [message].
  // This is typically called when a message is hard deleted.
  Future<void> _deleteMessageAttachments(Message message) async {
    if (!_isInitialized) return;

    final attachments = message.attachments;
    final deleteFutures = attachments.map((it) async {
      if (it.imageUrl case final url?) return deleteImage(url);
      if (it.assetUrl case final url?) return deleteFile(url);
    });

    final results = await Future.wait(deleteFutures);
    for (final result in results) {
      if (result case Failure(:final error, :final stackTrace)) {
        _logger.w(
          () => 'Error deleting message attachments',
          error: error,
          stackTrace: stackTrace,
        );
      }
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
  /// Returns the retried call's result.
  ///
  /// Throws a [StateError] if the message is not in a failed state or
  /// bounced with an error.
  Future<Result<Object>> retryMessage(Message message) async {
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
          return updateMessagePartial(
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

  /// Pins [message].
  Future<Result<UpdateMessagePartialResponse>> pinMessage(
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
    return updateMessagePartial(
      message,
      set: {
        'pinned': true,
        'pin_expires': pinExpires?.toUtc().toIso8601String(),
      },
    );
  }

  /// Unpins [message].
  Future<Result<UpdateMessagePartialResponse>> unpinMessage(Message message) => updateMessagePartial(
    message,
    set: {
      'pinned': false,
    },
  );

  /// Saves [draft] as the current user's draft in this channel.
  ///
  /// It replaces the draft the user already has here, or in the thread of the
  /// message [DraftMessage.parentId] names.
  ///
  /// Throws a [StateError] if the channel is not initialized.
  Future<Result<CreateDraftResponse>> createDraft(
    DraftMessage draft,
  ) {
    _checkInitialized();
    return _client.createDraft(draft, id!, type);
  }

  /// Fetches the current user's draft in this channel, or in the thread of the
  /// message with the id [parentId].
  ///
  /// A channel or thread without a draft comes back as a failure.
  ///
  /// Throws a [StateError] if the channel is not initialized.
  Future<Result<GetDraftResponse>> getDraft({
    String? parentId,
  }) {
    _checkInitialized();
    return _client.getDraft(id!, type, parentId: parentId);
  }

  /// Deletes the current user's draft in this channel, or in the thread of the
  /// message with the id [parentId].
  ///
  /// A channel or thread without a draft comes back as a failure.
  ///
  /// Throws a [StateError] if the channel is not initialized.
  Future<Result<void>> deleteDraft({
    String? parentId,
  }) {
    _checkInitialized();
    return _client.deleteDraft(id!, type, parentId: parentId);
  }

  /// Sends a static location to this channel.
  ///
  /// A [messageText] and [custom] data, when given, are sent in the message
  /// with the location.
  Future<Result<SendMessageResponse>> sendStaticLocation({
    String? id,
    String? messageText,
    String? createdByDeviceId,
    required LocationCoordinate location,
    Map<String, Object?> custom = const {},
  }) {
    final message = Message(
      id: id,
      text: messageText,
      custom: custom,
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
  /// A [messageText] and [custom] data, when given, are sent in the message
  /// with the location.
  Future<Result<SendMessageResponse>> startLiveLocationSharing({
    String? id,
    String? messageText,
    String? createdByDeviceId,
    required DateTime endSharingAt,
    required LocationCoordinate location,
    Map<String, Object?> custom = const {},
  }) {
    final message = Message(
      id: id,
      text: messageText,
      custom: custom,
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

  /// Uploads [file] to this channel.
  Future<Result<UploadedFile>> sendFile(
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

  /// Uploads [file] as an image to this channel.
  Future<Result<UploadedFile>> sendImage(
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

  /// Searches the messages of this channel.
  ///
  /// It looks for the messages that contain the text [query], or for those that
  /// match [messageFilters]. Exactly one of the two must be given.
  ///
  /// The results are ordered by [sort]. A page holds up to [limit] results, and
  /// never more than 100.
  ///
  /// The next page is fetched by passing a response's
  /// [SearchMessagesResponse.next] as [next], or by skipping the first [offset]
  /// results. A non-zero [offset] cannot be combined with [sort] or [next].
  ///
  /// Throws a [StateError] if this channel is not initialized.
  Future<Result<SearchMessagesResponse>> search({
    String? query,
    MessageSearchFilter? messageFilters,
    List<MessageSearchSort>? sort,
    int? limit,
    int? offset,
    String? next,
  }) {
    _checkInitialized();
    return _client.search(
      .in_(ChannelFilterField.cid, [cid]),
      query: query,
      messageFilters: messageFilters,
      sort: sort,
      limit: limit,
      offset: offset,
      next: next,
    );
  }

  /// Deletes the file at [url] from this channel.
  Future<Result<void>> deleteFile(
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

  /// Deletes the image at [url] from this channel.
  Future<Result<void>> deleteImage(
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

  /// Sends an event of the given [type] to this channel's watchers.
  ///
  /// The [type] names the event, such as [EventType.typingStart] or a custom
  /// event's name.
  ///
  /// A [parentId] ties the event to the thread of that message, and the
  /// [custom] data reaches the watchers alongside the event.
  ///
  /// Throws a [StateError] if this channel is not initialized.
  Future<Result<EventResponse>> sendEvent({
    required String type,
    String? parentId,
    Map<String, Object?>? custom,
  }) {
    _checkInitialized();
    return _client.sendEvent(id!, this.type, type: type, parentId: parentId, custom: custom);
  }

  final _pollLock = Lock();

  /// Creates [poll] and sends it to this channel in a new message.
  ///
  /// The message carries [messageText] as its text, if given.
  ///
  /// If the poll cannot be created, no message is sent and the failure is
  /// returned. If the message cannot be sent, the poll stays created and the
  /// failure is returned.
  Future<Result<SendMessageResponse>> sendPoll(
    Poll poll, {
    String? messageText,
  }) async {
    _checkInitialized();
    final created = await _pollLock.synchronized(() => _client.createPoll(poll));
    return created.flatMapAsync((response) {
      final poll = response.poll;
      return sendMessage(Message(text: messageText, poll: poll, pollId: poll.id));
    });
  }

  /// Updates [poll] to match the settings and options it carries.
  ///
  /// [Poll.options] becomes the poll's full list of options, each matched by
  /// its id, so an existing option missing from it is deleted. New options are
  /// added through [createPollOption].
  ///
  /// [Poll.enforceUniqueVote] is left as the poll was created.
  Future<Result<PollResponse>> updatePoll(Poll poll) {
    _checkInitialized();
    return _pollLock.synchronized(() => _client.updatePoll(poll));
  }

  /// Deletes [poll].
  Future<Result<void>> deletePoll(Poll poll) {
    _checkInitialized();
    return _pollLock.synchronized(() => _client.deletePoll(poll.id));
  }

  /// Closes [poll], so it accepts no more votes or answers.
  Future<Result<PollResponse>> closePoll(Poll poll) {
    _checkInitialized();
    return _pollLock.synchronized(() => _client.closePoll(poll.id));
  }

  /// Adds [option] to [poll].
  ///
  /// The option gets a new id, which the returned option carries.
  Future<Result<PollOptionResponse>> createPollOption(
    Poll poll,
    PollOption option,
  ) {
    _checkInitialized();
    return _pollLock.synchronized(
      () => _client.createPollOption(poll.id, option),
    );
  }

  final _pollVoteLock = Lock();

  /// Votes for [option] of [poll], which was sent in [message].
  ///
  /// If the poll allows only one vote per user, the vote replaces the previous
  /// one. The [option] must carry its id; if it does not, the call returns a
  /// failure without voting.
  Future<Result<PollVoteResponse>> castPollVote(
    Message message,
    Poll poll,
    PollOption option,
  ) async {
    _checkInitialized();

    final optionId = option.id;
    if (optionId == null) {
      return const Result.failure(
        StreamClientException(message: 'The poll option has no id, so it cannot be voted for.'),
      );
    }

    return _pollVoteLock.synchronized(
      () => _client.castPollVote(
        message.id,
        poll.id,
        optionId: optionId,
      ),
    );
  }

  /// Adds [answerText] as an answer to [poll], which was sent in [message].
  ///
  /// Each user has one answer per poll; a new one replaces the previous one.
  Future<Result<PollVoteResponse>> addPollAnswer(
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

  /// Removes [vote], a vote or answer on [poll], which was sent in [message].
  ///
  /// The [vote] must carry its id; if it does not, the call returns a failure
  /// without removing anything.
  Future<Result<PollVoteResponse>> removePollVote(
    Message message,
    Poll poll,
    PollVote vote,
  ) async {
    _checkInitialized();

    final voteId = vote.id;
    if (voteId == null) {
      return const Result.failure(StreamClientException(message: 'The poll vote has no id, so it cannot be removed.'));
    }

    return _pollVoteLock.synchronized(
      () => _client.removePollVote(
        message.id,
        poll.id,
        voteId,
      ),
    );
  }

  /// Fetches one page of the votes and answers matching [filter] on the poll
  /// with the id [pollId], ordered by [sort].
  ///
  /// Up to [limit] votes are returned. The next page is fetched by passing a
  /// response's [QueryPollVotesResponse.next] as [next], and the previous page
  /// by passing its [QueryPollVotesResponse.prev] as [prev]. At most one of
  /// [next] and [prev] may be given.
  Future<Result<QueryPollVotesResponse>> queryPollVotes(
    String pollId, {
    PollVoteFilter? filter,
    List<PollVoteSort>? sort,
    int limit = 10,
    String? next,
    String? prev,
  }) {
    _checkInitialized();
    return _client.queryPollVotes(
      pollId,
      filter: filter,
      sort: sort,
      limit: limit,
      next: next,
      prev: prev,
    );
  }

  /// Creates a reminder on the message with the id [messageId].
  ///
  /// The reminder is due at [remindAt]. Without it, the reminder is a bookmark,
  /// which is never due.
  ///
  /// Throws a [StateError] if this channel is not initialized.
  Future<Result<CreateReminderResponse>> createReminder(
    String messageId, {
    DateTime? remindAt,
  }) {
    _checkInitialized();
    return _client.createReminder(
      messageId,
      remindAt: remindAt,
    );
  }

  /// Updates the reminder on the message with the id [messageId].
  ///
  /// The reminder becomes due at [remindAt]. Without it, the reminder becomes a
  /// bookmark, which is never due.
  ///
  /// Throws a [StateError] if this channel is not initialized.
  Future<Result<UpdateReminderResponse>> updateReminder(
    String messageId, {
    DateTime? remindAt,
  }) {
    _checkInitialized();
    return _client.updateReminder(
      messageId,
      remindAt: remindAt,
    );
  }

  /// Deletes the reminder on the message with the id [messageId].
  ///
  /// Throws a [StateError] if this channel is not initialized.
  Future<Result<DeleteReminderResponse>> deleteReminder(String messageId) {
    _checkInitialized();
    return _client.deleteReminder(messageId);
  }

  /// Sends [reaction] to [message] in this channel.
  ///
  /// If [enforceUnique] is true, it replaces the current user's other reactions
  /// on the message.
  ///
  /// If [skipPush] is true, no push notification is sent.
  ///
  /// Throws a [StateError] if this channel is not initialized.
  Future<Result<SendReactionResponse>> sendReaction(
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
      user: _client.state.currentUser ?? reaction.user,
    );

    final updatedMessage = message.addMyReaction(
      reaction,
      enforceUnique: enforceUnique,
    );

    state?.updateMessage(updatedMessage);

    final result = await _client.sendReaction(
      messageId,
      reaction,
      skipPush: skipPush,
      enforceUnique: enforceUnique,
    );

    // Reset the message if the update fails. Use replace (not merge) so the
    // rollback wins over the optimistic local state — otherwise
    // `Message.updateWith`'s enrichment preservation would keep the optimistic
    // `ownReactions` for messages that previously had none.
    if (result case Failure()) state?.replaceMessage(message);

    return result;
  }

  /// Removes [reaction] from [message] in this channel.
  ///
  /// Throws a [StateError] if this channel is not initialized.
  Future<Result<DeleteReactionResponse>> deleteReaction(
    Message message,
    Reaction reaction,
  ) async {
    _checkInitialized();

    final updatedMessage = message.deleteMyReaction(
      reactionType: reaction.type,
    );

    state?.updateMessage(updatedMessage);

    final result = await _client.deleteReaction(message.id, reaction.type);

    // Reset the message if the update fails. Use replace (not merge) for
    // symmetry with `sendReaction` — see that method for context.
    if (result case Failure()) state?.replaceMessage(message);

    return result;
  }

  /// Sends an event to stop AI response generation, leaving the message in
  /// its current state.
  ///
  /// Throws a [StateError] if this channel is not initialized.
  Future<Result<void>> stopAIResponse() async {
    final result = await sendEvent(type: EventType.aiIndicatorStop);
    return result.ignoreValue();
  }

  /// Sets this channel's [name], leaving every other field as it is.
  ///
  /// The same as [updatePartial] with `set: {'name': name}`.
  Future<Result<UpdateChannelPartialResponse>> updateName(String name) => updatePartial(set: {'name': name});

  /// Sets this channel's [image] URL, leaving every other field as it is.
  ///
  /// The same as [updatePartial] with `set: {'image': image}`.
  Future<Result<UpdateChannelPartialResponse>> updateImage(String image) => updatePartial(set: {'image': image});

  /// Replaces this channel's data with [channelData].
  ///
  /// Every field [channelData] leaves out is cleared. An [updateMessage] is
  /// sent to the channel as a system message.
  ///
  /// The `members`, `invites`, `team`, `frozen`, `disabled`,
  /// `auto_translation_enabled`, `auto_translation_language` and
  /// `config_overrides` entries set those fields; every other entry, `name`
  /// and `image` included, is custom data. An entry whose value has another
  /// type than its field returns a failure.
  ///
  /// To change only some fields, consider [updatePartial].
  Future<Result<UpdateChannelResponse>> update(
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

  /// Partially updates this channel.
  ///
  /// Sets the fields in [set] and removes the custom fields named in [unset],
  /// leaving every other field as it is.
  ///
  /// At least one of [set] and [unset] is required.
  ///
  /// To replace every field, consider [update].
  Future<Result<UpdateChannelPartialResponse>> updatePartial({
    Map<String, Object?>? set,
    List<String>? unset,
  }) async {
    _checkInitialized();
    return _client.updateChannelPartial(id!, type, set: set, unset: unset);
  }

  /// Enables slow mode on this channel.
  ///
  /// Members then wait [cooldownInterval] seconds between messages.
  ///
  /// The [cooldownInterval] must be between 1 and 100.
  Future<Result<UpdateChannelPartialResponse>> enableSlowMode({
    required int cooldownInterval,
  }) async {
    _checkInitialized();
    return _client.enableSlowMode(id!, type, cooldownInterval);
  }

  /// Disables slow mode on this channel.
  Future<Result<UpdateChannelPartialResponse>> disableSlowMode() async {
    _checkInitialized();
    return _client.disableSlowMode(id!, type);
  }

  /// Deletes this channel and its messages.
  Future<Result<DeleteChannelResponse>> delete() async {
    _checkInitialized();
    return _client.deleteChannel(id!, type);
  }

  /// Removes this channel's messages.
  ///
  /// The messages up to [truncatedAt] are removed, or all of them when it is
  /// null. A [message] is sent to the channel as a system message, and
  /// [skipPush] sends it without a push notification.
  Future<Result<TruncateChannelResponse>> truncate({
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

  /// Accepts the current user's invite to this channel.
  ///
  /// A [message] is sent to the channel as a system message.
  Future<Result<UpdateChannelResponse>> acceptInvite([Message? message]) async {
    _checkInitialized();
    return _client.acceptChannelInvite(id!, type, message: message);
  }

  /// Rejects the current user's invite to this channel.
  ///
  /// A [message] is sent to the channel as a system message.
  Future<Result<UpdateChannelResponse>> rejectInvite([Message? message]) async {
    _checkInitialized();
    return _client.rejectChannelInvite(id!, type, message: message);
  }

  /// Adds the users with the ids [memberIds] to this channel.
  ///
  /// A [message] is sent to the channel as a system message.
  ///
  /// The new members do not see the messages sent before [hideHistoryBefore],
  /// or any earlier message when [hideHistory] is true. A [hideHistoryBefore]
  /// takes precedence over [hideHistory].
  Future<Result<UpdateChannelResponse>> addMembers(
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

  /// Invites the users with the ids [memberIds] to this channel.
  ///
  /// A [message] is sent to the channel as a system message.
  Future<Result<UpdateChannelResponse>> inviteMembers(
    List<String> memberIds, {
    Message? message,
  }) async {
    _checkInitialized();
    return _client.inviteChannelMembers(id!, type, memberIds, message: message);
  }

  /// Removes the users with the ids [memberIds] from this channel.
  ///
  /// A [message] is sent to the channel as a system message.
  Future<Result<UpdateChannelResponse>> removeMembers(
    List<String> memberIds, {
    Message? message,
  }) async {
    _checkInitialized();
    return _client.removeChannelMembers(id!, type, memberIds, message: message);
  }

  /// Runs the action [formData] describes on [message].
  Future<Result<SendActionResponse>> sendAction(Message message, Map<String, String> formData) async {
    _checkInitialized();
    final result = await _client.sendAction(message.id, formData);

    return result.onSuccess((response) {
      switch (response.message) {
        case final updated?:
          state?.updateMessage(updated);
        case null:
          state?.removeMessage(message);
      }
    });
  }

  /// Marks this channel as read for the current user.
  ///
  /// Messages up to and including the one with [messageId] are marked as read,
  /// or all of them when [messageId] is null.
  ///
  /// If [usesLocalUnreadCount] is `true` for this channel, this updates the
  /// unread count locally, on-device, without making a network request, and
  /// returns a [MarkReadResponse] whose [MarkReadResponse.duration] is `0ms`.
  /// In that case [messageId] is recorded as the read boundary but does
  /// **not** narrow the count: the channel is always treated as fully read and
  /// the count drops to zero. See [ChannelClientState.markReadLocally].
  ///
  /// Returns a failure if [canUseReadReceipts] is `false`, unless
  /// [usesLocalUnreadCount] is `true`.
  Future<Result<MarkReadResponse>> markRead({String? messageId}) async {
    _checkInitialized();

    if (usesLocalUnreadCount) {
      state!.markReadLocally(messageId: messageId);
      return const Result.success(MarkReadResponse(duration: '0ms'));
    }

    if (!canUseReadReceipts) {
      return const Result.failure(
        StreamClientException(
          message:
              'Cannot mark as read: Channel does not support read events. '
              'Enable read_events in your channel type configuration.',
        ),
      );
    }

    return _client.markChannelRead(id!, type, messageId: messageId);
  }

  /// Marks this channel as unread for the current user.
  ///
  /// The message with [messageId] and every later one are marked as unread.
  /// Contrast with [markUnreadByTimestamp], which is exclusive: a message
  /// created at exactly the given timestamp stays read.
  ///
  /// The message must be one of the channel's latest 100 messages; an older one
  /// returns a failure.
  ///
  /// If [usesLocalUnreadCount] is `true` for this channel, this updates the
  /// unread count locally, on-device, without making a network request. The
  /// message must be part of the locally-known messages ([Channel.messages])
  /// for the count to be recomputed; otherwise this returns a failure.
  ///
  /// Returns a failure if [canUseReadReceipts] is `false`, unless
  /// [usesLocalUnreadCount] is `true`.
  Future<Result<void>> markUnread(String messageId) async {
    _checkInitialized();

    if (usesLocalUnreadCount) {
      // [ChannelClientState.messages] is sorted ascending by `createdAt`, so
      // the entry before the anchor is the newest message that stays read.
      final messages = state!.messages;
      final anchorIndex = messages.indexWhere((it) => it.id == messageId);
      if (anchorIndex < 0) {
        return Result.failure(
          StreamClientException(
            message:
                'Cannot mark as unread: Message "$messageId" was not found in the '
                'locally-known messages for this channel.',
          ),
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
      return const Result.success(null);
    }

    if (!canUseReadReceipts) {
      return const Result.failure(
        StreamClientException(
          message:
              'Cannot mark as unread: Channel does not support read events. '
              'Enable read_events in your channel type configuration.',
        ),
      );
    }

    return _client.markChannelUnread(id!, type, messageId);
  }

  /// Marks the messages of this channel created after [timestamp] as unread for
  /// the current user.
  ///
  /// The boundary is **exclusive**: a message created at exactly [timestamp]
  /// stays read. Contrast with [markUnread], which is inclusive of the message
  /// it is given — `markUnread(m.id)` is equivalent to
  /// `markUnreadByTimestamp(m.createdAt - 1µs)`, not to
  /// `markUnreadByTimestamp(m.createdAt)`.
  ///
  /// If [usesLocalUnreadCount] is `true` for this channel, this updates the
  /// unread count locally, on-device, without making a network request.
  ///
  /// Returns a failure if [canUseReadReceipts] is `false`, unless
  /// [usesLocalUnreadCount] is `true`.
  Future<Result<void>> markUnreadByTimestamp(DateTime timestamp) async {
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
      return const Result.success(null);
    }

    if (!canUseReadReceipts) {
      return const Result.failure(
        StreamClientException(
          message:
              'Cannot mark as unread: Channel does not support read events. '
              'Enable read_events in your channel type configuration.',
        ),
      );
    }

    return _client.markChannelUnreadByTimestamp(id!, type, timestamp);
  }

  /// Marks the thread started by the message with [threadId] as read for the
  /// current user.
  ///
  /// Returns a failure if [canUseReadReceipts] is `false`.
  Future<Result<MarkReadResponse>> markThreadRead(String threadId) async {
    _checkInitialized();

    if (!canUseReadReceipts) {
      return const Result.failure(
        StreamClientException(
          message:
              'Cannot mark thread as read: Channel does not support read events. '
              'Enable read_events in your channel type configuration.',
        ),
      );
    }

    return _client.markThreadRead(id!, type, threadId);
  }

  /// Marks the thread started by the message with [threadId] as unread for the
  /// current user.
  ///
  /// Returns a failure if [canUseReadReceipts] is `false`.
  Future<Result<void>> markThreadUnread(String threadId) async {
    _checkInitialized();

    if (!canUseReadReceipts) {
      return const Result.failure(
        StreamClientException(
          message:
              'Cannot mark thread as unread: Channel does not support read events. '
              'Enable read_events in your channel type configuration.',
        ),
      );
    }

    return _client.markThreadUnread(id!, type, threadId);
  }

  void _initState(ChannelState channelState) {
    state = ChannelClientState(this, channelState);
    _initializedCompleter.safeComplete(true);

    if (cid case final cid?) client.state.addChannels({cid: this});
    _logger.v(() => 'State initialized');
  }

  /// Loads this channel's state and starts watching it, creating the channel
  /// first if it does not exist.
  ///
  /// The same as [query] with `watch: true`.
  Future<Result<ChannelStateResponse>> watch({
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

  /// Fetches one page of the replies to the message with the id [parentId].
  ///
  /// On success, the replies are added to this channel's thread state. A page
  /// fetched with [idAround] replaces the thread state rather than adding to
  /// it, so it has no gaps. A failure leaves the state as it was.
  ///
  /// Up to [limit] replies are returned, oldest first, and never more than 300.
  /// The [limit] must be positive for the reply ids below to take effect.
  ///
  /// The reply ids [idLt] and [idLte] bound the page to the replies before that
  /// reply, [idGt] and [idGte] to the replies after it, and [idAround] to the
  /// replies around it. [idLte] and [idGte] include the reply itself.
  ///
  /// If [preferOffline] is true and the offline storage holds replies for the
  /// page, those are returned instead of fetching them. The page is still
  /// fetched when the storage holds none or cannot be read.
  Future<Result<GetRepliesResponse>> getReplies(
    String parentId, {
    required int limit,
    String? idLt,
    String? idLte,
    String? idGt,
    String? idGte,
    String? idAround,
    bool preferOffline = false,
  }) async {
    final offlineReplies = preferOffline
        ? await _offlineReplies(
            parentId,
            PaginationParams(
              limit: limit,
              lessThan: idLt,
              lessThanOrEqual: idLte,
              greaterThan: idGt,
              greaterThanOrEqual: idGte,
              idAround: idAround,
            ),
          )
        : null;

    final result = switch (offlineReplies) {
      final response? => Result.success(response),
      null => await _client.getReplies(
        parentId,
        limit: limit,
        idLt: idLt,
        idLte: idLte,
        idGt: idGt,
        idGte: idGte,
        idAround: idAround,
      ),
    };

    return result.onSuccess((response) {
      // A page around a reply can leave a gap with the replies already in the
      // state, so it replaces them.
      if (idAround != null) state?.clearThread(parentId);
      state?.updateThreadInfo(parentId, response.messages);
    });
  }

  // The replies the offline storage holds for the page described by [options],
  // or null when it holds none or cannot be read, so the page is fetched.
  Future<GetRepliesResponse?> _offlineReplies(String parentId, PaginationParams options) async {
    final persistenceClient = _client.chatPersistenceClient;
    if (persistenceClient == null) return null;

    final result = await runSafely(() => persistenceClient.getReplies(parentId, options: options));
    final replies = result.getOrNull();
    if (replies == null || replies.isEmpty) return null;

    return GetRepliesResponse(duration: '0ms', messages: replies);
  }

  /// Fetches one page of the reactions on the message with the id [messageId].
  ///
  /// Up to [limit] reactions are returned, after skipping the first [offset].
  Future<Result<GetReactionsResponse>> getReactions(String messageId, {int? limit, int? offset}) =>
      _client.getReactions(messageId, limit: limit, offset: offset);

  /// Fetches messages of this channel by their ids.
  ///
  /// It takes up to 50 [messageIds]; more return a failure. A message that does
  /// not exist or cannot be shown is left out of the response.
  ///
  /// Throws a [StateError] if this channel is not initialized.
  Future<Result<GetManyMessagesResponse>> getManyMessages(List<String> messageIds) async {
    _checkInitialized();
    return _client.getManyMessages(id!, type, messageIds);
  }

  /// Translates the message with the id [messageId] into [language].
  ///
  /// On success, the translated message is merged into the channel state, so
  /// its translations reach everything listening to it. A failure leaves the
  /// state as it was.
  Future<Result<TranslateMessageResponse>> translateMessage(String messageId, TranslationLanguage language) async {
    final result = await _client.translateMessage(messageId, language);
    return result.onSuccess((response) => state?.updateMessage(response.message));
  }

  /// Creates this channel without loading its messages, members or watchers.
  Future<Result<ChannelStateResponse>> create() => query(state: false);

  /// Loads this channel's state, creating the channel first if it does not
  /// exist, and applies it to [Channel.state].
  ///
  /// The state holds the messages, members and watchers when [state] is true,
  /// paged by [messagesPagination], [membersPagination] and
  /// [watchersPagination]. With [watch], this connection receives the
  /// channel's events; with [presence], its members' presence changes.
  ///
  /// If [preferOffline] is true and the offline storage holds messages for the
  /// page, that state is used instead of fetching it. When fetching fails
  /// without [watch], the state stored offline is returned instead, if there
  /// is one. Either answer reports a `0ms` duration.
  ///
  /// A failure that is not answered from the offline storage also completes
  /// [initialized] with its error while the channel has no state.
  Future<Result<ChannelStateResponse>> query({
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

    final offlineState = preferOffline && !watch ? await _offlineChannelState(messagesPagination) : null;
    final result = switch (offlineState) {
      final channelState? when channelState.messages?.isNotEmpty == true => Result.success(
        ChannelStateResponse(duration: '0ms', channelState: channelState),
      ),
      _ => await _client.queryChannel(
        type,
        channelId: id,
        channelData: _custom,
        state: state,
        watch: watch,
        presence: presence,
        messagesPagination: messagesPagination,
        membersPagination: membersPagination,
        watchersPagination: watchersPagination,
      ),
    };

    switch (result) {
      case Success(:final data):
        _applyChannelState(data.channelState, messagesPagination: messagesPagination);
        return result;
      case Failure(:final error, :final stackTrace):
        if (!watch && _client.persistenceEnabled) {
          if (await _offlineChannelState(messagesPagination) case final channelState?) {
            return Result.success(ChannelStateResponse(duration: '0ms', channelState: channelState));
          }
        }

        _initializedCompleter.safeCompleteError(error, stackTrace);
        return result;
    }
  }

  // The channel state the offline storage holds for the page described by
  // [messagesPagination], or null when there is no storage, the channel has
  // no cid yet or the storage cannot be read.
  Future<ChannelState?> _offlineChannelState(PaginationParams? messagesPagination) async {
    final persistenceClient = _client.chatPersistenceClient;
    final cid = this.cid;
    if (persistenceClient == null || cid == null) return null;

    final result = await runSafely(
      () => persistenceClient.getChannelStateByCid(cid, messagePagination: messagesPagination),
    );
    return result.getOrNull();
  }

  // Applies a fetched [channelState]: adopts the id of a channel created
  // through its members, initializes the state or updates it, and reports
  // delivery when the latest messages were loaded.
  void _applyChannelState(ChannelState channelState, {PaginationParams? messagesPagination}) {
    if (_id == null) {
      _id = channelState.channel!.id;
      _cid = channelState.channel!.cid;
    }

    // Initialize the channel state if it's not initialized yet.
    if (state == null) {
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

      if (isQueryingAround) state?.truncate();
      state?.updateChannelStateFromServer(channelState);
    }

    // Submit for delivery reporting only when fetching the latest messages.
    // This happens when no pagination params are provided (initial query).
    if (messagesPagination == null) {
      _client.channelDeliveryReporter.submitForDelivery([this]);
    }
  }

  /// Fetches one page of this channel's members that match [filter], ordered
  /// by [sort].
  ///
  /// The page holds up to [PaginationParams.limit] members after skipping
  /// [PaginationParams.offset], bounded by its `createdAt` dates.
  Future<Result<QueryMembersResponse>> queryMembers({
    MemberFilter? filter,
    List<MemberSort>? sort,
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
    BannedUserFilter? filter,
    List<BannedUserSort>? sort,
    PaginationParams? pagination,
  }) {
    _checkInitialized();
    filter ??= .equal(BannedUserFilterField.channelCid, cid);
    return _client.queryBannedUsers(
      filter: filter,
      sort: sort,
      pagination: pagination,
    );
  }

  // Timer to keep track of mute expiration. This is used to update the channel
  // state when the mute expires.
  Timer? _muteExpirationTimer;

  /// Mutes this channel for the current user.
  ///
  /// The mute lasts until it is removed. An [expiration] expires it after
  /// that long, and a zero one removes it straight away.
  Future<Result<void>> mute({Duration? expiration}) {
    _checkInitialized();

    // If there is a expiration set, we will set a timer to automatically unmute
    // the channel when the mute expires.
    if (expiration != null) {
      _muteExpirationTimer?.cancel();
      _muteExpirationTimer = Timer(expiration, unmute);
    }

    return _client.moderation.muteChannel(cid!, expiration: expiration);
  }

  /// Removes the current user's mute on this channel.
  Future<Result<void>> unmute() {
    _checkInitialized();

    // Cancel the mute expiration timer if it is set.
    _muteExpirationTimer?.cancel();
    _muteExpirationTimer = null;

    return _client.moderation.unmuteChannel(cid!);
  }

  /// Bans [userID] from this channel.
  ///
  /// The ban lasts until it is removed. A [timeout] expires it after that
  /// long, applied in whole minutes and never less than one.
  ///
  /// If [shadow] is true, their messages stop reaching anyone else and they
  /// are not told.
  ///
  /// If [ipBan] is true, the address they connected from is banned as well.
  ///
  /// [deleteMessages] decides what happens to the messages they already
  /// sent, which are left alone when it is omitted. [reason] is recorded
  /// with the ban.
  Future<Result<void>> banMember(
    String userID, {
    Duration? timeout,
    String? reason,
    bool? shadow,
    bool? ipBan,
    DeleteType? deleteMessages,
  }) {
    _checkInitialized();
    return _client.moderation.banUser(
      userID,
      channelCid: cid,
      timeout: timeout,
      reason: reason,
      shadow: shadow,
      ipBan: ipBan,
      deleteMessages: deleteMessages,
    );
  }

  /// Removes the ban on [userID] in this channel.
  ///
  /// A shadow ban lifts the same way as any other.
  Future<Result<void>> unbanMember(String userID) {
    _checkInitialized();
    return _client.moderation.unbanUser(userID, channelCid: cid);
  }

  /// Bans [userID] without telling them, hiding their messages.
  ///
  /// The same as [banMember] with `shadow` set, and the other arguments
  /// behave the same way.
  ///
  /// Remove it with [unbanMember].
  Future<Result<void>> shadowBan(
    String userID, {
    Duration? timeout,
    String? reason,
    bool? ipBan,
    DeleteType? deleteMessages,
  }) {
    _checkInitialized();
    return _client.moderation.shadowBan(
      userID,
      channelCid: cid,
      timeout: timeout,
      reason: reason,
      ipBan: ipBan,
      deleteMessages: deleteMessages,
    );
  }

  /// Hides this channel for the current user.
  ///
  /// It stays out of the current user's channel list until a new message is
  /// added to it.
  ///
  /// Hiding also marks it read for the current user.
  ///
  /// If [clearHistory] is true, this channel's messages are also cleared
  /// for the current user.
  Future<Result<HideChannelResponse>> hide({bool clearHistory = false}) async {
    _checkInitialized();
    return _client.hideChannel(
      id!,
      type,
      clearHistory: clearHistory,
    );
  }

  /// Shows this channel after the current user hid it.
  Future<Result<ShowChannelResponse>> show() async {
    _checkInitialized();
    return _client.showChannel(id!, type);
  }

  /// Pins this channel for the current user.
  Future<Result<UpdateMemberPartialResponse>> pin() async {
    _checkInitialized();
    return _client.pinChannel(channelId: id!, channelType: type);
  }

  /// Unpins this channel for the current user.
  Future<Result<UpdateMemberPartialResponse>> unpin() async {
    _checkInitialized();
    return _client.unpinChannel(channelId: id!, channelType: type);
  }

  /// Archives this channel for the current user.
  Future<Result<UpdateMemberPartialResponse>> archive() async {
    _checkInitialized();
    return _client.archiveChannel(channelId: id!, channelType: type);
  }

  /// Unarchives this channel for the current user.
  Future<Result<UpdateMemberPartialResponse>> unarchive() async {
    _checkInitialized();
    return _client.unarchiveChannel(channelId: id!, channelType: type);
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

  /// Sends a typing start event, and a typing stop once the user stops typing.
  ///
  /// Call this on every key press. A [parentId] ties the events to the thread
  /// of that message.
  ///
  /// If typing events are disabled for this channel or by the current user's
  /// privacy settings, nothing is sent and this returns a success.
  Future<Result<void>> keyStroke([String? parentId]) async {
    if (!_canSendTypingEvents) return const Result.success(null);

    _logger.v(() => 'KeyStroke received');
    return _keyStrokeHandler(parentId);
  }

  /// Sends the [EventType.typingStart] event.
  ///
  /// A [parentId] ties the event to the thread of that message.
  ///
  /// If typing events are disabled for this channel or by the current user's
  /// privacy settings, nothing is sent and this returns a success.
  Future<Result<void>> startTyping([String? parentId]) async {
    if (!_canSendTypingEvents) return const Result.success(null);

    _logger.d(() => 'start typing');
    final result = await sendEvent(type: EventType.typingStart, parentId: parentId);
    return result.ignoreValue();
  }

  /// Sends the [EventType.typingStop] event.
  ///
  /// A [parentId] ties the event to the thread of that message.
  ///
  /// If typing events are disabled for this channel or by the current user's
  /// privacy settings, nothing is sent and this returns a success.
  Future<Result<void>> stopTyping([String? parentId]) async {
    if (!_canSendTypingEvents) return const Result.success(null);

    _logger.d(() => 'stop typing');
    final result = await sendEvent(type: EventType.typingStop, parentId: parentId);
    return result.ignoreValue();
  }

  /// Call this method to dispose the channel client.
  void dispose() {
    _keyStrokeHandler.cancel();
    client.state.removeChannel('$cid');
    state?.dispose();
    state = null;
    _muteExpirationTimer?.cancel();
  }

  // Runs [block] and returns its result, or what it throws as a failure: a
  // [StreamException] as it is, and any other error in a
  // [StreamClientException] carrying [failureMessage].
  Future<Result<T>> _runCatching<T>(Future<Result<T>> Function() block, {required String failureMessage}) async {
    try {
      return await block();
    } on StreamException catch (error, stackTrace) {
      return Result.failure(error, stackTrace);
    } catch (error, stackTrace) {
      return Result.failure(StreamClientException(message: failureMessage, cause: error), stackTrace);
    }
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

// Names which attachments failed and what each reported, so the caller is not
// left with "one or more".
//
// The reasons are strings because `UploadStateFailed.error` is one: whatever
// each upload threw was stringified when its state was recorded, so there is no
// throwable left to carry as a `cause`.
String _uploadFailureMessage(Iterable<Attachment> failed) {
  final reasons = failed.map((it) {
    final reason = switch (it.uploadState) {
      UploadStateFailed(:final error) => error,
      _ => 'unknown error',
    };

    return '${it.id}: $reason';
  });

  return 'Failed to upload ${failed.length} attachment(s) — ${reasons.join('; ')}';
}
