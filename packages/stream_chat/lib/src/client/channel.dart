// ignore_for_file: avoid_redundant_argument_values

import 'dart:async';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/client/retry_queue.dart';
import 'package:stream_chat/src/core/util/utils.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:synchronized/synchronized.dart';

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
  })  : _cid = _id != null ? '$_type:$_id' : null,
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
    state = ChannelClientState(this, channelState);
    _initializedCompleter.complete(true);
    _client.logger.info('New Channel instance initialized');
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
    if (_initializedCompleter.isCompleted) {
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
    if (_initializedCompleter.isCompleted) {
      throw StateError(
        'Once the channel is initialized you should use `channel.updateImage` '
        'to update the channel image',
      );
    }
    _extraData.addAll({'image': image});
  }

  set extraData(Map<String, Object?> extraData) {
    if (_initializedCompleter.isCompleted) {
      throw StateError(
        'Once the channel is initialized you should use `channel.update` '
        'to update channel data',
      );
    }
    _extraData.addAll(extraData);
  }

  /// Returns true if the channel is muted.
  bool get isMuted =>
      _client.state.currentUser?.channelMutes
          .any((element) => element.channel.cid == cid) ==
      true;

  /// Returns true if the channel is muted, as a stream.
  Stream<bool> get isMutedStream => _client.state.currentUserStream
      .map((event) =>
          event?.channelMutes.any((element) => element.channel.cid == cid) ==
          true)
      .distinct();

  /// True if the channel is a group.
  bool get isGroup => memberCount != 2;

  /// True if the channel is distinct.
  bool get isDistinct => id?.startsWith('!members') == true;

  /// Channel configuration.
  ChannelConfig? get config {
    _checkInitialized();
    return state!._channelState.channel?.config;
  }

  /// Channel configuration as a stream.
  Stream<ChannelConfig?> get configStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.config);
  }

  /// Relationship of the current user to this channel.
  Member? get membership {
    _checkInitialized();
    return state!._channelState.membership;
  }

  /// Relationship of the current user to this channel as a stream.
  Stream<Member?> get membershipStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.membership);
  }

  /// Channel user creator.
  User? get createdBy {
    _checkInitialized();
    return state!._channelState.channel?.createdBy;
  }

  /// Channel user creator as a stream.
  Stream<User?> get createdByStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.createdBy);
  }

  /// Channel frozen status.
  bool get frozen {
    _checkInitialized();
    return state!._channelState.channel?.frozen == true;
  }

  /// Channel frozen status as a stream.
  Stream<bool> get frozenStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.frozen == true);
  }

  /// Channel disabled status.
  bool get disabled {
    _checkInitialized();
    return state!._channelState.channel?.disabled == true;
  }

  /// Channel disabled status as a stream.
  Stream<bool> get disabledStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.disabled == true);
  }

  /// Channel hidden status.
  bool get hidden {
    _checkInitialized();
    return state!._channelState.channel?.hidden == true;
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
    return state!._channelState.channel?.truncatedAt;
  }

  /// The last date at which the channel got truncated as a stream.
  Stream<DateTime?> get truncatedAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.truncatedAt);
  }

  /// Cooldown count
  int get cooldown {
    _checkInitialized();
    return state!._channelState.channel?.cooldown ?? 0;
  }

  /// Cooldown count as a stream
  Stream<int> get cooldownStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.cooldown ?? 0);
  }

  /// Remaining cooldown duration in seconds for the channel.
  ///
  /// Returns 0 if there is no cooldown active.
  int getRemainingCooldown() {
    _checkInitialized();

    final cooldownDuration = cooldown;
    if (cooldownDuration <= 0) return 0;

    final userLastMessageAt = currentUserLastMessageAt;
    if (userLastMessageAt == null) return 0;

    if (canSkipSlowMode) return 0;

    final currentTime = DateTime.timestamp();
    final elapsedTime = currentTime.difference(userLastMessageAt).inSeconds;

    return math.max(0, cooldownDuration - elapsedTime);
  }

  /// Stores time at which cooldown was started
  @Deprecated(
    "Use a combination of 'remainingCooldown' and 'currentUserLastMessageAt'",
  )
  DateTime? get cooldownStartedAt {
    if (getRemainingCooldown() <= 0) return null;
    return currentUserLastMessageAt;
  }

  /// Channel creation date.
  DateTime? get createdAt {
    _checkInitialized();
    return state!._channelState.channel?.createdAt;
  }

  /// Channel creation date as a stream.
  Stream<DateTime?> get createdAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.createdAt);
  }

  /// Channel last message date.
  DateTime? get lastMessageAt {
    _checkInitialized();
    return state!._channelState.channel?.lastMessageAt;
  }

  /// Channel last message date as a stream.
  Stream<DateTime?> get lastMessageAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.lastMessageAt);
  }

  DateTime? _currentUserLastMessageAt(List<Message>? messages) {
    final currentUserId = client.state.currentUser?.id;
    if (currentUserId == null) return null;

    final validMessages = messages?.where((message) {
      if (message.isEphemeral) return false;
      if (message.user?.id != currentUserId) return false;
      return true;
    });

    return validMessages?.map((m) => m.createdAt).max;
  }

  /// The date of the last message sent by the current user.
  DateTime? get currentUserLastMessageAt {
    _checkInitialized();

    // If the channel is not up to date, we can't rely on the last message
    // from the current user.
    if (!state!.isUpToDate) return null;

    final messages = state!.channelState.messages;
    return _currentUserLastMessageAt(messages);
  }

  /// The date of the last message sent by the current user as a stream.
  Stream<DateTime?> get currentUserLastMessageAtStream {
    _checkInitialized();

    return CombineLatestStream.combine2<bool, List<Message>?, DateTime?>(
      state!.isUpToDateStream,
      state!.channelStateStream.map((state) => state.messages),
      (isUpToDate, messages) {
        // If the channel is not up to date, we can't rely on the last message
        // from the current user.
        if (!isUpToDate) return null;
        return _currentUserLastMessageAt(messages);
      },
    );
  }

  /// Channel updated date.
  DateTime? get updatedAt {
    _checkInitialized();
    return state!._channelState.channel?.updatedAt;
  }

  /// Channel updated date as a stream.
  Stream<DateTime?> get updatedAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.updatedAt);
  }

  /// Channel deletion date.
  DateTime? get deletedAt {
    _checkInitialized();
    return state!._channelState.channel?.deletedAt;
  }

  /// Channel deletion date as a stream.
  Stream<DateTime?> get deletedAtStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.deletedAt);
  }

  /// Channel member count.
  int? get memberCount {
    _checkInitialized();
    return state!._channelState.channel?.memberCount;
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
    return state!._channelState.channel?.messageCount;
  }

  /// Channel message count as a stream.
  ///
  /// Note: This field is only populated if the `count_messages` option is
  /// enabled for your app.
  Stream<int?> get messageCountStream {
    _checkInitialized();
    return state!.channelStateStream.map((cs) => cs.channel?.messageCount);
  }

  /// Channel id.
  String? get id => state?._channelState.channel?.id ?? _id;

  /// Channel type.
  String get type => state?._channelState.channel?.type ?? _type;

  /// Channel cid.
  String? get cid => state?._channelState.channel?.cid ?? _cid;

  /// Channel team.
  String? get team {
    _checkInitialized();
    return state!._channelState.channel?.team;
  }

  /// Channel extra data.
  Map<String, Object?> get extraData {
    var data = state?._channelState.channel?.extraData;
    if (data == null || data.isEmpty) {
      data = _extraData;
    }
    return data;
  }

  /// List of user permissions on this channel
  List<ChannelCapability> get ownCapabilities =>
      state?._channelState.channel?.ownCapabilities ?? [];

  /// List of user permissions on this channel
  Stream<List<ChannelCapability>> get ownCapabilitiesStream {
    _checkInitialized();
    return state!.channelStateStream
        .map((cs) => cs.channel?.ownCapabilities ?? [])
        .distinct();
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

  final Completer<bool> _initializedCompleter = Completer();

  /// True if this is initialized.
  ///
  /// Call [watch] to initialize the client or instantiate it using
  /// [Channel.fromState].
  Future<bool> get initialized => _initializedCompleter.future;

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

    return Future.wait(attachments.map((it) {
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
      return future.then((response) {
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
      }).catchError((e, stk) {
        if (e is StreamChatNetworkError && e.isRequestCancelledError) {
          client.logger.info('Attachment ${it.id} upload cancelled');

          // remove attachment from message if cancelled.
          updateAttachment(it, remove: true);
          return;
        }

        client.logger.severe('error uploading the attachment', e, stk);
        updateAttachment(
          it.copyWith(uploadState: UploadState.failed(error: e.toString())),
        );
      }).whenComplete(() {
        throttledUpdateAttachment.cancel();
        _cancelableAttachmentUploadRequest.remove(it.id);
      });
    })).whenComplete(() {
      if (message!.attachments.every((it) => it.uploadState.isSuccess)) {
        _messageAttachmentsUploadCompleter.remove(messageId)?.complete(message);
      }
    });
  }

  bool _isMessageValidForUpload(Message message) {
    final hasText = message.text?.trim().isNotEmpty == true;
    final hasAttachments = message.attachments.isNotEmpty;
    final hasQuotedMessage = message.quotedMessageId != null;
    final hasPoll = message.pollId != null;

    return hasText || hasAttachments || hasQuotedMessage || hasPoll;
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
    state!.cleanUpStaleErrorMessages();

    // Cancelling previous completer in case it's called again in the process
    // Eg. Updating the message while the previous call is in progress.
    _messageAttachmentsUploadCompleter
        .remove(message.id)
        ?.completeError(const StreamChatError('Message cancelled'));

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

    state!.updateMessage(message);

    try {
      if (message.attachments.any((it) => !it.uploadState.isSuccess)) {
        final attachmentsUploadCompleter = Completer<Message>();
        _messageAttachmentsUploadCompleter[message.id] =
            attachmentsUploadCompleter;

        _uploadAttachments(
          message.id,
          message.attachments.map((it) => it.id),
        );

        // ignore: parameter_assignments
        message = await attachmentsUploadCompleter.future;
      }

      // Validate the final message before sending it to the server.
      if (_isMessageValidForUpload(message) == false) {
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

      final sentMessage = response.message.syncWith(message).copyWith(
            // Update the message state to sent.
            state: MessageState.sent,
          );

      state!.updateMessage(sentMessage);

      return response;
    } catch (e) {
      if (e is StreamChatNetworkError && e.isRetriable) {
        state!._retryQueue.add([
          message.copyWith(
            // Update the message state to failed.
            state: MessageState.sendingFailed,
          ),
        ]);
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
    final originalMessage = message;

    // Cancelling previous completer in case it's called again in the process
    // Eg. Updating the message while the previous call is in progress.
    _messageAttachmentsUploadCompleter
        .remove(message.id)
        ?.completeError(const StreamChatError('Message cancelled'));

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
        _messageAttachmentsUploadCompleter[message.id] =
            attachmentsUploadCompleter;

        _uploadAttachments(
          message.id,
          message.attachments.map((it) => it.id),
        );

        // ignore: parameter_assignments
        message = await attachmentsUploadCompleter.future;
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

      final updateMessage = response.message.syncWith(message).copyWith(
            // Update the message state to updated.
            state: MessageState.updated,
            ownReactions: message.ownReactions,
          );

      state?.updateMessage(updateMessage);

      return response;
    } catch (e) {
      if (e is StreamChatNetworkError) {
        if (e.isRetriable) {
          state!._retryQueue.add([
            message.copyWith(
              // Update the message state to failed.
              state: MessageState.updatingFailed,
            ),
          ]);
        } else {
          // Reset the message to original state if the update fails and is not
          // retriable.
          state?.updateMessage(originalMessage.copyWith(
            state: MessageState.updatingFailed,
          ));
        }
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
    final originalMessage = message;

    // Cancelling previous completer in case it's called again in the process
    // Eg. Updating the message while the previous call is in progress.
    _messageAttachmentsUploadCompleter
        .remove(message.id)
        ?.completeError(const StreamChatError('Message cancelled'));

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

      final updatedMessage = response.message.syncWith(message).copyWith(
            // Update the message state to updated.
            state: MessageState.updated,
            ownReactions: message.ownReactions,
          );

      state?.updateMessage(updatedMessage);

      return response;
    } catch (e) {
      if (e is StreamChatNetworkError) {
        if (e.isRetriable) {
          state!._retryQueue.add([
            message.copyWith(
              // Update the message state to failed.
              state: MessageState.updatingFailed,
            ),
          ]);
        } else {
          // Reset the message to original state if the update fails and is not
          // retriable.
          state?.updateMessage(originalMessage.copyWith(
            state: MessageState.updatingFailed,
          ));
        }
      }

      rethrow;
    }
  }

  final _deleteMessageLock = Lock();

  /// Deletes the [message] from the channel.
  Future<EmptyResponse> deleteMessage(
    Message message, {
    bool hard = false,
  }) async {
    _checkInitialized();

    // Directly deleting the local messages and bounced error messages as they
    // are not available on the server.
    if (message.remoteCreatedAt == null || message.isBouncedWithError) {
      state!.deleteMessage(
        message.copyWith(
          type: MessageType.deleted,
          localDeletedAt: DateTime.now(),
          state: MessageState.deleted(hard: hard),
        ),
        hardDelete: hard,
      );

      // Removing the attachments upload completer to stop the `sendMessage`
      // waiting for attachments to complete.
      _messageAttachmentsUploadCompleter
          .remove(message.id)
          ?.completeError(const StreamChatError('Message deleted'));

      // Returning empty response to mark the api call as success.
      return EmptyResponse();
    }

    // ignore: parameter_assignments
    message = message.copyWith(
      type: MessageType.deleted,
      deletedAt: DateTime.now(),
      state: MessageState.deleting(hard: hard),
    );

    state?.deleteMessage(message, hardDelete: hard);

    try {
      // Wait for the previous delete call to finish. Otherwise, the order of
      // messages will not be maintained.
      final response = await _deleteMessageLock.synchronized(
        () => _client.deleteMessage(message.id, hard: hard),
      );

      final deletedMessage = message.copyWith(
        state: MessageState.deleted(hard: hard),
      );

      state?.deleteMessage(deletedMessage, hardDelete: hard);

      if (hard) {
        deletedMessage.attachments.forEach((attachment) {
          if (attachment.uploadState.isSuccess) {
            if (attachment.type == AttachmentType.image) {
              deleteImage(attachment.imageUrl!);
            } else if (attachment.type == AttachmentType.file) {
              deleteFile(attachment.assetUrl!);
            }
          }
        });
      }

      return response;
    } catch (e) {
      if (e is StreamChatNetworkError && e.isRetriable) {
        state!._retryQueue.add([
          message.copyWith(
            // Update the message state to failed.
            state: MessageState.deletingFailed(hard: hard),
          ),
        ]);
      }
      rethrow;
    }
  }

  /// Retry the operation on the message based on the failed state.
  ///
  /// For example, if the message failed to send, it will retry sending the
  /// message and vice-versa.
  Future<Object> retryMessage(Message message) async {
    assert(message.state.isFailed, 'Message state is not failed');

    return message.state.maybeWhen(
      failed: (state, _) => state.when(
        sendingFailed: () => sendMessage(message),
        updatingFailed: () => updateMessage(message),
        deletingFailed: (hard) => deleteMessage(message, hard: hard),
      ),
      orElse: () => throw StateError('Message state is not failed'),
    );
  }

  /// Pins provided message
  Future<UpdateMessageResponse> pinMessage(
    Message message, {
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
      message,
      set: {
        'pinned': true,
        'pin_expires': pinExpires?.toUtc().toIso8601String(),
      },
    );
  }

  /// Unpins provided message.
  Future<UpdateMessageResponse> unpinMessage(Message message) =>
      partialUpdateMessage(
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
    String messageText = '',
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
    String type, {
    int score = 1,
    Map<String, Object?> extraData = const {},
    bool enforceUnique = false,
  }) async {
    _checkInitialized();
    final currentUser = _client.state.currentUser;
    if (currentUser == null) {
      throw StateError(
        'Cannot send reaction: current user is not available. '
        'Ensure the client is connected and a user is set.',
      );
    }

    final messageId = message.id;
    final reaction = Reaction(
      type: type,
      messageId: messageId,
      user: currentUser,
      score: score,
      createdAt: DateTime.timestamp(),
      extraData: extraData,
    );

    final updatedMessage = message.addMyReaction(
      reaction,
      enforceUnique: enforceUnique,
    );

    state?.updateMessage(updatedMessage);

    try {
      final reactionResp = await _client.sendReaction(
        messageId,
        reaction.type,
        score: reaction.score,
        extraData: reaction.extraData,
        enforceUnique: enforceUnique,
      );
      return reactionResp;
    } catch (_) {
      // Reset the message if the update fails
      state?.updateMessage(message);
      rethrow;
    }
  }

  /// Delete a reaction from this channel.
  Future<EmptyResponse> deleteReaction(
    Message message,
    Reaction reaction,
  ) async {
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
      // Reset the message if the update fails
      state?.updateMessage(message);
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
  Future<PartialUpdateChannelResponse> updateName(String name) =>
      updatePartial(set: {'name': name});

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
  Future<PartialUpdateChannelResponse> updateImage(String image) =>
      updatePartial(set: {'image': image});

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
  }) async {
    _checkInitialized();
    return _client.addChannelMembers(
      id!,
      type,
      memberIds,
      message: message,
      hideHistory: hideHistory,
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
  Future<EmptyResponse> markRead({String? messageId}) async {
    _checkInitialized();
    return _client.markChannelRead(id!, type, messageId: messageId);
  }

  /// Mark message as unread.
  ///
  /// You have to provide a [messageId] from which you want the channel
  /// to be marked as unread.
  Future<EmptyResponse> markUnread(String messageId) async {
    _checkInitialized();
    return _client.markChannelUnread(id!, type, messageId);
  }

  /// Mark the thread with [threadId] in the channel as read.
  Future<EmptyResponse> markThreadRead(String threadId) {
    _checkInitialized();
    return client.markThreadRead(id!, type, threadId);
  }

  /// Mark the thread with [threadId] in the channel as unread.
  Future<EmptyResponse> markThreadUnread(String threadId) {
    _checkInitialized();
    return client.markThreadUnread(id!, type, threadId);
  }

  void _initState(ChannelState channelState) {
    state = ChannelClientState(this, channelState);

    if (cid != null) {
      client.state.addChannels({cid!: this});
    }
    if (!_initializedCompleter.isCompleted) {
      _initializedCompleter.complete(true);
    }
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
  }) =>
      _client.getReactions(
        messageId,
        pagination: pagination,
      );

  /// Retrieves a list of messages by given [messageIDs].
  Future<GetMessagesByIdResponse> getMessagesById(
    List<String> messageIDs,
  ) async {
    _checkInitialized();
    final res = await _client.getMessagesById(id!, type, messageIDs);
    final messages = res.messages;
    state!.updateChannelState(state!.channelState.copyWith(messages: messages));
    return res;
  }

  /// Translate a message by given [messageId] and [language].
  Future<TranslateMessageResponse> translateMessage(
    String messageId,
    String language,
  ) =>
      _client.translateMessage(
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
        this.state?.updateChannelState(channelState);
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
      if (!_initializedCompleter.isCompleted) {
        _initializedCompleter.completeError(e, stk);
      }

      rethrow;
    }
  }

  /// Query channel members.
  Future<QueryMembersResponse> queryMembers({
    Filter? filter,
    SortOrder<Member>? sort,
    PaginationParams? pagination,
  }) =>
      _client.queryMembers(
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
  ]) =>
      _client
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

  /// Sends the [Event.typingStart] event and schedules a timer to invoke the
  /// [Event.typingStop] event.
  ///
  /// This is meant to be called every time the user presses a key.
  Future<void> keyStroke([String? parentId]) async {
    if (config?.typingEvents == false) return;

    client.logger.info('KeyStroke received');
    return _keyStrokeHandler(parentId);
  }

  /// Sends the [EventType.typingStart] event.
  Future<void> startTyping([String? parentId]) async {
    if (config?.typingEvents == false) return;

    client.logger.info('start typing');
    await sendEvent(Event(
      type: EventType.typingStart,
      parentId: parentId,
    ));
  }

  /// Sends the [EventType.typingStop] event.
  Future<void> stopTyping([String? parentId]) async {
    if (config?.typingEvents == false) return;

    client.logger.info('stop typing');
    await sendEvent(Event(
      type: EventType.typingStop,
      parentId: parentId,
    ));
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
    if (_initializedCompleter.isCompleted && state != null) return;

    throw StateError(
      "Channel $cid hasn't been initialized yet or has been disposed. "
      'Make sure to call .watch() or instantiate the client using '
      '[Channel.fromState]',
    );
  }
}

/// The class that handles the state of the channel listening to the events.
class ChannelClientState {
  /// Creates a new instance listening to events and updating the state.
  ChannelClientState(
    this._channel,
    ChannelState channelState,
  ) {
    _retryQueue = RetryQueue(
      channel: _channel,
      logger: _channel.client.detachedLogger(
        '⟳ (${generateHash([_channel.cid])})',
      ),
    );

    _channelStateController = BehaviorSubject.seeded(channelState);
    // Update the persistence storage with the seeded channel state.
    _debouncedUpdatePersistenceChannelState.call([channelState]);

    _checkExpiredAttachmentMessages(channelState);

    _listenTypingEvents();

    _listenMessageNew();

    _listenMessageDeleted();

    _listenMessageUpdated();

    /* Start of draft events */

    _listenDraftUpdated();

    _listenDraftDeleted();

    /* End of draft events */

    _listenReactions();

    _listenReactionDeleted();

    /* Start of poll events */

    _listenPollUpdated();

    _listenPollClosed();

    _listenPollAnswerCasted();

    _listenPollVoteCasted();

    _listenPollVoteChanged();

    _listenPollAnswerRemoved();

    _listenPollVoteRemoved();

    /* End of poll events */

    _listenReadEvents();

    _listenChannelTruncated();

    _listenChannelUpdated();

    _listenChannelMessageCount();

    _listenMemberAdded();

    _listenMemberRemoved();

    _listenMemberUpdated();

    _listenMemberBanned();

    _listenMemberUnbanned();

    _listenUserStartWatching();

    _listenUserStopWatching();

    /* Start of reminder events */

    _listenReminderCreated();

    _listenReminderUpdated();

    _listenReminderDeleted();

    /* End of reminder events */

    _listenUserMessagesDeleted();

    _startCleaningStaleTypingEvents();

    _startCleaningStalePinnedMessages();

    _listenChannelPushPreferenceUpdated();

    final persistenceClient = _channel.client.chatPersistenceClient;
    persistenceClient?.getChannelThreads(_channel.cid!).then((threads) {
      // Load all the threads for the channel from the offline storage.
      if (threads.isNotEmpty) _threads = threads;
    }).then((_) => retryFailedMessages());
  }

  final Channel _channel;
  final _subscriptions = CompositeSubscription();

  void _checkExpiredAttachmentMessages(ChannelState channelState) async {
    final expiredAttachmentMessagesId = channelState.messages
        ?.where((m) =>
            !_updatedMessagesIds.contains(m.id) &&
            m.attachments.isNotEmpty &&
            m.attachments.any((e) {
              final url = e.imageUrl ?? e.assetUrl;
              if (url == null || !url.contains('')) {
                return false;
              }
              try {
                final uri = Uri.parse(url);
                if (!uri.host.endsWith('stream-io-cdn.com') ||
                    uri.queryParameters['Expires'] == null) {
                  return false;
                }
                final secondsFromEpoch =
                    int.parse(uri.queryParameters['Expires']!);
                final expiration = DateTime.fromMillisecondsSinceEpoch(
                  secondsFromEpoch * 1000,
                );
                return expiration.isBefore(DateTime.now());
              } catch (_) {
                return false;
              }
            }))
        .map((e) => e.id)
        .toList();

    if (expiredAttachmentMessagesId != null &&
        expiredAttachmentMessagesId.isNotEmpty) {
      await _channel._initializedCompleter.future;
      _updatedMessagesIds.addAll(expiredAttachmentMessagesId);
      _channel.getMessagesById(expiredAttachmentMessagesId);
    }
  }

  void _listenMemberAdded() {
    _subscriptions.add(_channel.on(EventType.memberAdded).listen((Event e) {
      final member = e.member!;
      final existingMembers = channelState.members ?? [];

      updateChannelState(
        channelState.copyWith(
          members: [...existingMembers, member],
        ),
      );
    }));
  }

  void _listenMemberRemoved() {
    _subscriptions.add(_channel.on(EventType.memberRemoved).listen((Event e) {
      final user = e.user!;
      final existingRead = channelState.read ?? [];
      final existingMembers = channelState.members ?? [];

      updateChannelState(
        channelState.copyWith(
          read: [...existingRead.where((r) => r.user.id != user.id)],
          members: [...existingMembers.where((m) => m.userId != user.id)],
        ),
      );
    }));
  }

  void _listenMemberUpdated() {
    _subscriptions
      // Listen to events containing member users
      ..add(_channel.on().listen(
        (event) {
          final user = event.user;
          if (user == null) return;

          final existingMembers = [...?channelState.members];
          final existingMembership = channelState.membership;

          // Return if the user is not a existing member of the channel.
          if (!existingMembers.any((m) => m.userId == user.id)) return;

          Member? maybeUpdateMemberUser(Member? existingMember) {
            if (existingMember == null) return null;
            if (existingMember.userId == user.id) {
              return existingMember.copyWith(user: user);
            }
            return existingMember;
          }

          updateChannelState(
            channelState.copyWith(
              membership: maybeUpdateMemberUser(existingMembership),
              members: [...existingMembers.map(maybeUpdateMemberUser).nonNulls],
            ),
          );
        },
      ))

      // Listen to member updated events.
      ..add(_channel.on(EventType.memberUpdated).listen(
        (Event e) {
          final member = e.member!;
          final existingMembers = channelState.members ?? [];
          final existingMembership = channelState.membership;

          Member? maybeUpdateMember(Member? existingMember) {
            if (existingMember == null) return null;
            if (existingMember.userId == member.userId) return member;
            return existingMember;
          }

          updateChannelState(
            channelState.copyWith(
              membership: maybeUpdateMember(existingMembership),
              members: [...existingMembers.map(maybeUpdateMember).nonNulls],
            ),
          );
        },
      ));
  }

  void _listenChannelUpdated() {
    _subscriptions.add(_channel.on(EventType.channelUpdated).listen((Event e) {
      final channel = e.channel!;
      updateChannelState(channelState.copyWith(
        channel: channelState.channel?.merge(channel),
        members: channel.members,
      ));
    }));
  }

  void _listenChannelMessageCount() {
    _subscriptions.add(_channel.on().listen(
      (Event e) {
        final messageCount = e.channelMessageCount;
        if (messageCount == null) return;

        updateChannelState(
          channelState.copyWith(
            channel: channelState.channel?.copyWith(
              messageCount: messageCount,
            ),
          ),
        );
      },
    ));
  }

  void _listenChannelTruncated() {
    _subscriptions.add(_channel
        .on(EventType.channelTruncated, EventType.notificationChannelTruncated)
        .listen((event) async {
      final channel = event.channel!;
      await _channel._client.chatPersistenceClient
          ?.deleteMessageByCid(channel.cid);
      truncate();
      if (event.message != null) {
        updateMessage(event.message!);
      }
    }));
  }

  void _listenMemberBanned() {
    _subscriptions.add(_channel
        .on(EventType.userBanned)
        .where((it) => it.cid != null) // filters channel ban from app ban
        .listen(
      (event) async {
        final user = event.user!;
        final member = await _channel
            .queryMembers(filter: Filter.equal('id', user.id))
            .then((it) => it.members.first);

        _updateMember(member);
      },
    ));
  }

  void _listenUserStartWatching() {
    _subscriptions.add(
      _channel.on(EventType.userWatchingStart).listen((event) {
        final watcher = event.user;
        if (watcher != null) {
          final existingWatchers = channelState.watchers;
          updateChannelState(channelState.copyWith(
            watchers: [
              watcher,
              ...?existingWatchers?.where((user) => user.id != watcher.id),
            ],
          ));
        }
      }),
    );
  }

  void _listenUserStopWatching() {
    _subscriptions.add(
      _channel.on(EventType.userWatchingStop).listen((event) {
        final watcher = event.user;
        if (watcher != null) {
          final existingWatchers = channelState.watchers;
          updateChannelState(channelState.copyWith(
            watchers: [
              ...?existingWatchers?.where((user) => user.id != watcher.id)
            ],
          ));
        }
      }),
    );
  }

  void _listenMemberUnbanned() {
    _subscriptions.add(_channel
        .on(EventType.userUnbanned)
        .where((it) => it.cid != null) // filters channel ban from app ban
        .listen(
      (event) async {
        final user = event.user!;
        final member = await _channel
            .queryMembers(filter: Filter.equal('id', user.id))
            .then((it) => it.members.first);

        _updateMember(member);
      },
    ));
  }

  void _updateMember(Member member) {
    final currentMembers = [...members];
    final memberIndex = currentMembers.indexWhere(
      (m) => m.userId == member.userId,
    );

    if (memberIndex == -1) return;
    currentMembers[memberIndex] = member;

    updateChannelState(
      channelState.copyWith(
        members: currentMembers,
      ),
    );
  }

  /// Flag which indicates if [ChannelClientState] contain latest/recent messages or not.
  ///
  /// This flag should be managed by UI sdks.
  ///
  /// When false, any new message received by WebSocket event
  /// [EventType.messageNew] will not be pushed on to message list.
  bool get isUpToDate => _isUpToDateController.value;

  set isUpToDate(bool isUpToDate) => _isUpToDateController.safeAdd(isUpToDate);

  /// [isUpToDate] flag count as a stream.
  Stream<bool> get isUpToDateStream => _isUpToDateController.stream;
  final _isUpToDateController = BehaviorSubject.seeded(true);

  /// The retry queue associated to this channel.
  late final RetryQueue _retryQueue;

  /// Retry failed message.
  Future<void> retryFailedMessages() async {
    final failedMessages = [...messages, ...threads.values.expand((v) => v)]
        .where((it) => it.state.isFailed);
    _retryQueue.add(failedMessages);
  }

  Message? _findPollMessage(String pollId) {
    final message = messages.firstWhereOrNull((it) => it.pollId == pollId);
    if (message != null) return message;

    final threadMessage = threads.values.flattened.firstWhereOrNull((it) {
      return it.pollId == pollId;
    });

    return threadMessage;
  }

  void _listenPollUpdated() {
    _subscriptions.add(_channel.on(EventType.pollUpdated).listen((event) {
      final eventPoll = event.poll;
      if (eventPoll == null) return;

      final pollMessage = _findPollMessage(eventPoll.id);
      if (pollMessage == null) return;

      final oldPoll = pollMessage.poll;

      final latestAnswers = oldPoll?.latestAnswers ?? eventPoll.latestAnswers;
      final ownVotesAndAnswers =
          oldPoll?.ownVotesAndAnswers ?? eventPoll.ownVotesAndAnswers;

      final poll = eventPoll.copyWith(
        latestAnswers: latestAnswers,
        ownVotesAndAnswers: ownVotesAndAnswers,
      );

      final message = pollMessage.copyWith(poll: poll);
      updateMessage(message);
    }));
  }

  void _listenPollClosed() {
    _subscriptions.add(_channel.on(EventType.pollClosed).listen((event) {
      final eventPoll = event.poll;
      if (eventPoll == null) return;

      final pollMessage = _findPollMessage(eventPoll.id);
      if (pollMessage == null) return;

      final oldPoll = pollMessage.poll;
      final poll = oldPoll?.copyWith(isClosed: true) ?? eventPoll;

      final message = pollMessage.copyWith(poll: poll);
      updateMessage(message);
    }));
  }

  void _listenPollAnswerCasted() {
    _subscriptions.add(_channel.on(EventType.pollAnswerCasted).listen((event) {
      final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
      if (eventPoll == null || eventPollVote == null) return;

      final pollMessage = _findPollMessage(eventPoll.id);
      if (pollMessage == null) return;

      final oldPoll = pollMessage.poll;

      final latestAnswers = <String, PollVote>{
        for (final ans in oldPoll?.latestAnswers ?? []) ans.id: ans,
        eventPollVote.id!: eventPollVote,
      };

      final currentUserId = _channel.client.state.currentUser?.id;
      final ownVotesAndAnswers = <String, PollVote>{
        for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
        if (eventPollVote.userId == currentUserId)
          eventPollVote.id!: eventPollVote,
      };

      final poll = eventPoll.copyWith(
        latestAnswers: [...latestAnswers.values],
        ownVotesAndAnswers: [...ownVotesAndAnswers.values],
      );

      final message = pollMessage.copyWith(poll: poll);
      updateMessage(message);
    }));
  }

  void _listenPollVoteCasted() {
    _subscriptions.add(_channel.on(EventType.pollVoteCasted).listen((event) {
      final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
      if (eventPoll == null || eventPollVote == null) return;

      final pollMessage = _findPollMessage(eventPoll.id);
      if (pollMessage == null) return;

      final oldPoll = pollMessage.poll;

      final latestAnswers = oldPoll?.latestAnswers ?? eventPoll.latestAnswers;
      final currentUserId = _channel.client.state.currentUser?.id;
      final ownVotesAndAnswers = <String, PollVote>{
        for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
        if (eventPollVote.userId == currentUserId)
          eventPollVote.id!: eventPollVote,
      };

      final poll = eventPoll.copyWith(
        latestAnswers: latestAnswers,
        ownVotesAndAnswers: [...ownVotesAndAnswers.values],
      );

      final message = pollMessage.copyWith(poll: poll);
      updateMessage(message);
    }));
  }

  void _listenPollAnswerRemoved() {
    _subscriptions.add(_channel.on(EventType.pollAnswerRemoved).listen((event) {
      final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
      if (eventPoll == null || eventPollVote == null) return;

      final pollMessage = _findPollMessage(eventPoll.id);
      if (pollMessage == null) return;

      final oldPoll = pollMessage.poll;

      final latestAnswers = <String, PollVote>{
        for (final ans in oldPoll?.latestAnswers ?? []) ans.id: ans,
      }..remove(eventPollVote.id);

      final ownVotesAndAnswers = <String, PollVote>{
        for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
      }..remove(eventPollVote.id);

      final poll = eventPoll.copyWith(
        latestAnswers: [...latestAnswers.values],
        ownVotesAndAnswers: [...ownVotesAndAnswers.values],
      );

      final message = pollMessage.copyWith(poll: poll);
      updateMessage(message);
    }));
  }

  void _listenPollVoteRemoved() {
    _subscriptions.add(_channel.on(EventType.pollVoteRemoved).listen((event) {
      final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
      if (eventPoll == null || eventPollVote == null) return;

      final pollMessage = _findPollMessage(eventPoll.id);
      if (pollMessage == null) return;

      final oldPoll = pollMessage.poll;

      final latestAnswers = oldPoll?.latestAnswers ?? eventPoll.latestAnswers;
      final ownVotesAndAnswers = <String, PollVote>{
        for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
      }..remove(eventPollVote.id);

      final poll = eventPoll.copyWith(
        latestAnswers: latestAnswers,
        ownVotesAndAnswers: [...ownVotesAndAnswers.values],
      );

      final message = pollMessage.copyWith(poll: poll);
      updateMessage(message);
    }));
  }

  void _listenPollVoteChanged() {
    _subscriptions.add(_channel.on(EventType.pollVoteChanged).listen((event) {
      final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
      if (eventPoll == null || eventPollVote == null) return;

      final pollMessage = _findPollMessage(eventPoll.id);
      if (pollMessage == null) return;

      final oldPoll = pollMessage.poll;

      final latestAnswers = oldPoll?.latestAnswers ?? eventPoll.latestAnswers;
      final currentUserId = _channel.client.state.currentUser?.id;
      final ownVotesAndAnswers = <String, PollVote>{
        for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
        if (eventPollVote.userId == currentUserId)
          eventPollVote.id!: eventPollVote,
      };

      final poll = eventPoll.copyWith(
        latestAnswers: latestAnswers,
        ownVotesAndAnswers: [...ownVotesAndAnswers.values],
      );

      final message = pollMessage.copyWith(poll: poll);
      updateMessage(message);
    }));
  }

  void _listenDraftUpdated() {
    _subscriptions.add(
      _channel.on(EventType.draftUpdated).listen((event) {
        final draft = event.draft;
        if (draft == null) return;

        return updateDraft(draft);
      }),
    );
  }

  void _listenDraftDeleted() {
    _subscriptions.add(
      _channel.on(EventType.draftDeleted).listen((event) {
        final draft = event.draft;
        if (draft == null) return;

        return deleteDraft(draft);
      }),
    );
  }

  void _listenReminderCreated() {
    _subscriptions.add(
      _channel.on(EventType.reminderCreated).listen((event) {
        final reminder = event.reminder;
        if (reminder == null) return;

        updateReminder(reminder);
      }),
    );
  }

  void _listenReminderUpdated() {
    _subscriptions.add(
      _channel.on(EventType.reminderUpdated).listen((event) {
        final reminder = event.reminder;
        if (reminder == null) return;

        updateReminder(reminder);
      }),
    );
  }

  void _listenReminderDeleted() {
    _subscriptions.add(
      _channel.on(EventType.reminderDeleted).listen((event) {
        final reminder = event.reminder;
        if (reminder == null) return;

        deleteReminder(reminder);
      }),
    );
  }

  /// Updates the [reminder] of the message if it exists.
  void updateReminder(MessageReminder reminder) {
    final messageId = reminder.messageId;
    // TODO: Improve once we have support for parentId in reminders.
    for (final message in [...messages, ...threads.values.flattened]) {
      if (message.id == messageId) {
        return updateMessage(
          message.copyWith(reminder: reminder),
        );
      }
    }
  }

  /// Deletes the [reminder] of the message if it exists.
  void deleteReminder(MessageReminder reminder) {
    final messageId = reminder.messageId;
    // TODO: Improve once we have support for parentId in reminders.
    for (final message in [...messages, ...threads.values.flattened]) {
      if (message.id == messageId) {
        return updateMessage(
          message.copyWith(reminder: null),
        );
      }
    }
  }

  void _listenReactionDeleted() {
    _subscriptions.add(_channel.on(EventType.reactionDeleted).listen((event) {
      final oldMessage =
          messages.firstWhereOrNull((it) => it.id == event.message?.id) ??
              threads[event.message?.parentId]
                  ?.firstWhereOrNull((e) => e.id == event.message?.id);
      final reaction = event.reaction;
      final ownReactions = oldMessage?.ownReactions
          ?.whereNot((it) =>
              it.type == reaction?.type &&
              it.score == reaction?.score &&
              it.messageId == reaction?.messageId &&
              it.userId == reaction?.userId &&
              it.extraData == reaction?.extraData)
          .toList(growable: false);
      final message = event.message!.copyWith(
        ownReactions: ownReactions,
      );
      updateMessage(message);
    }));
  }

  void _listenReactions() {
    _subscriptions.add(_channel.on(EventType.reactionNew).listen((event) {
      final oldMessage =
          messages.firstWhereOrNull((it) => it.id == event.message?.id) ??
              threads[event.message?.parentId]
                  ?.firstWhereOrNull((e) => e.id == event.message?.id);
      final message = event.message!.copyWith(
        ownReactions: oldMessage?.ownReactions,
      );
      updateMessage(message);
    }));
  }

  void _listenMessageUpdated() {
    _subscriptions.add(_channel
        .on(
      EventType.messageUpdated,
      EventType.reactionUpdated,
    )
        .listen((event) {
      final oldMessage =
          messages.firstWhereOrNull((it) => it.id == event.message?.id) ??
              threads[event.message?.parentId]
                  ?.firstWhereOrNull((e) => e.id == event.message?.id);
      final message = event.message!.copyWith(
        poll: oldMessage?.poll,
        pollId: oldMessage?.pollId,
        ownReactions: oldMessage?.ownReactions,
      );
      updateMessage(message);
    }));
  }

  void _listenMessageDeleted() {
    _subscriptions.add(_channel.on(EventType.messageDeleted).listen((event) {
      final message = event.message!;
      final hardDelete = event.hardDelete ?? false;

      deleteMessage(message, hardDelete: hardDelete);
    }));
  }

  void _listenMessageNew() {
    _subscriptions.add(_channel
        .on(
      EventType.messageNew,
      EventType.notificationMessageNew,
    )
        .listen((event) {
      final message = event.message;
      if (message == null) return;

      final isThreadMessage = message.parentId != null;
      final isShownInChannel = message.showInChannel == true;
      final isThreadOnlyMessage = isThreadMessage && !isShownInChannel;

      // Only add the message if the channel is upToDate or if the message is
      // a thread-only message.
      if (isUpToDate || isThreadOnlyMessage) {
        updateMessage(message);
      }

      // Otherwise, check if we can count the message as unread.
      if (_countMessageAsUnread(message)) unreadCount += 1;
    }));
  }

  // Logic taken from the backend SDK
  // https://github.com/GetStream/chat/blob/9245c2b3f7e679267d57ee510c60e93de051cb8e/types/channel.go#L1136-L1150
  bool _shouldUpdateChannelLastMessageAt(Message message) {
    if (message.isError) return false;
    if (message.shadowed) return false;
    if (message.isEphemeral) return false;

    final config = channelState.channel?.config;
    if (message.isSystem && config?.skipLastMsgUpdateForSystemMsgs == true) {
      return false;
    }

    final currentUserId = _channel._client.state.currentUser?.id;
    if (currentUserId case final userId? when message.isNotVisibleTo(userId)) {
      return false;
    }

    return true;
  }

  /// Updates the [read] in the state if it exists. Adds it otherwise.
  void updateRead([Iterable<Read>? read]) {
    final existingReads = <Read>[...?channelState.read];
    final updatedReads = <Read>[
      ...existingReads.merge(
        read,
        key: (read) => read.user.id,
        update: (original, updated) => updated,
      ),
    ];

    updateChannelState(
      channelState.copyWith(
        read: updatedReads,
      ),
    );
  }

  /// Updates the [draft] in the channel state or the message if it exists.
  void updateDraft(Draft draft) {
    if (draft.parentId case final parentId?) {
      for (final message in messages) {
        if (message.id == parentId) {
          return updateMessage(message.copyWith(draft: draft));
        }
      }
    }

    updateChannelState(
      channelState.copyWith(
        draft: draft,
      ),
    );
  }

  /// Deletes the [draft] from the state if it exists.
  void deleteDraft(Draft draft) async {
    // Delete the draft from the persistence client.
    await _channel._client.chatPersistenceClient?.deleteDraftMessageByCid(
      draft.channelCid,
      parentId: draft.parentId,
    );

    if (draft.parentId case final parentId?) {
      for (final message in messages) {
        if (message.id == parentId) {
          return updateMessage(
            message.copyWith(draft: null),
          );
        }
      }
    }

    updateChannelState(
      channelState.copyWith(
        draft: null,
      ),
    );
  }

  /// Updates the [message] in the state if it exists. Adds it otherwise.
  void updateMessage(Message message) => _updateMessages([message]);

  /// Cleans up all the stale error messages which requires no action.
  void cleanUpStaleErrorMessages() {
    final errorMessages = messages.where((message) {
      return message.isError && !message.isBounced;
    }).toList();

    if (errorMessages.isEmpty) return;
    return _removeMessages(errorMessages);
  }

  /// Remove a [message] from this [channelState].
  void removeMessage(Message message) => _removeMessages([message]);

  /// Removes/Updates the [message] based on the [hardDelete] value.
  void deleteMessage(Message message, {bool hardDelete = false}) {
    if (hardDelete) return removeMessage(message);
    return updateMessage(message);
  }

  void _listenReadEvents() {
    if (_channelState.channel?.config.readEvents == false) return;

    _subscriptions
      ..add(
        _channel
            .on(
          EventType.messageRead,
          EventType.notificationMarkRead,
        )
            .listen(
          (event) {
            final user = event.user;
            if (user == null) return;

            final updatedRead = Read(
              user: user,
              lastRead: event.createdAt,
              unreadMessages: event.unreadMessages,
              lastReadMessageId: event.lastReadMessageId,
            );

            return updateRead([updatedRead]);
          },
        ),
      )
      ..add(
        _channel.on(EventType.notificationMarkUnread).listen(
          (Event event) {
            final user = event.user;
            if (user == null) return;

            final updatedRead = Read(
              user: user,
              lastRead: event.lastReadAt!,
              unreadMessages: event.unreadMessages,
              lastReadMessageId: event.lastReadMessageId,
            );

            return updateRead([updatedRead]);
          },
        ),
      );
  }

  /// Channel message list.
  List<Message> get messages => _channelState.messages ?? <Message>[];

  /// Channel message list as a stream.
  Stream<List<Message>> get messagesStream => channelStateStream
      .map((cs) => cs.messages ?? <Message>[])
      .distinct(const ListEquality().equals);

  /// Channel pinned message list.
  List<Message> get pinnedMessages =>
      _channelState.pinnedMessages ?? <Message>[];

  /// Channel pinned message list as a stream.
  Stream<List<Message>> get pinnedMessagesStream => channelStateStream
      .map((cs) => cs.pinnedMessages ?? <Message>[])
      .distinct(const ListEquality().equals);

  /// Get channel last message.
  Message? get lastMessage =>
      _channelState.messages != null && _channelState.messages!.isNotEmpty
          ? _channelState.messages!.last
          : null;

  /// Get channel last message.
  Stream<Message?> get lastMessageStream =>
      messagesStream.map((event) => event.isNotEmpty ? event.last : null);

  /// Channel members list.
  List<Member> get members => (_channelState.members ?? <Member>[])
      .map((e) => e.copyWith(user: _channel.client.state.users[e.user!.id]))
      .toList();

  /// Channel members list as a stream.
  Stream<List<Member>> get membersStream => CombineLatestStream.combine2<
          List<Member?>?, Map<String?, User?>, List<Member>>(
        channelStateStream.map((cs) => cs.members),
        _channel.client.state.usersStream,
        (members, users) =>
            [...?members?.map((e) => e!.copyWith(user: users[e.user!.id]))],
      ).distinct(const ListEquality().equals);

  /// Channel watcher count.
  int? get watcherCount => _channelState.watcherCount;

  /// Channel watcher count as a stream.
  Stream<int?> get watcherCountStream =>
      channelStateStream.map((cs) => cs.watcherCount);

  /// Channel watchers list.
  List<User> get watchers => (_channelState.watchers ?? <User>[])
      .map((e) => _channel.client.state.users[e.id] ?? e)
      .toList();

  /// Channel watchers list as a stream.
  Stream<List<User>> get watchersStream => CombineLatestStream.combine2<
          List<User>?, Map<String?, User?>, List<User>>(
        channelStateStream.map((cs) => cs.watchers),
        _channel.client.state.usersStream,
        (watchers, users) => [...?watchers?.map((e) => users[e.id] ?? e)],
      ).distinct(const ListEquality().equals);

  /// Channel draft.
  Draft? get draft => _channelState.draft;

  /// Channel draft as a stream.
  Stream<Draft?> get draftStream {
    return channelStateStream.map((cs) => cs.draft).distinct();
  }

  /// Channel member for the current user.
  Member? get currentUserMember => members.firstWhereOrNull(
        (m) => m.user?.id == _channel.client.state.currentUser?.id,
      );

  /// Channel role for the current user
  String? get currentUserChannelRole => currentUserMember?.channelRole;

  /// Channel read list.
  List<Read> get read => _channelState.read ?? <Read>[];

  /// Channel read list as a stream.
  Stream<List<Read>> get readStream =>
      channelStateStream.map((cs) => cs.read ?? <Read>[]);

  bool _isCurrentUserRead(Read read) =>
      read.user.id == _channel._client.state.currentUser!.id;

  /// Channel read for the logged in user.
  Read? get currentUserRead => read.firstWhereOrNull(_isCurrentUserRead);

  /// Channel read for the logged in user as a stream.
  Stream<Read?> get currentUserReadStream =>
      readStream.map((read) => read.firstWhereOrNull(_isCurrentUserRead));

  /// Unread count getter as a stream.
  Stream<int> get unreadCountStream =>
      currentUserReadStream.map((read) => read?.unreadMessages ?? 0);

  /// Unread count getter.
  int get unreadCount => currentUserRead?.unreadMessages ?? 0;

  /// Setter for unread count.
  set unreadCount(int count) {
    final currentUser = _channel.client.state.currentUser;
    if (currentUser == null) return;

    var existingUserRead = currentUserRead;
    if (existingUserRead == null) {
      final lastMessageAt = _channelState.channel?.lastMessageAt;
      existingUserRead = Read(
        user: currentUser,
        lastRead: lastMessageAt ?? DateTime.now(),
      );
    }

    return updateRead([existingUserRead.copyWith(unreadMessages: count)]);
  }

  bool _countMessageAsUnread(Message message) {
    // Don't count if the channel doesn't allow read events.
    if (!_channel.canReceiveReadEvents) return false;

    // Don't count if the channel is muted.
    if (_channel.isMuted) return false;

    // Don't count if the message is silent or shadowed or ephemeral.
    if (message.silent) return false;
    if (message.shadowed) return false;
    if (message.isEphemeral) return false;

    // Don't count thread replies which are not shown in the channel as unread.
    if (message.parentId != null && message.showInChannel != true) {
      return false;
    }

    // Don't count if the message doesn't have a user.
    final messageUser = message.user;
    if (messageUser == null) return false;

    // Don't count if the current user is not set.
    final currentUser = _channel.client.state.currentUser;
    if (currentUser == null) return false;

    // Don't count user's own messages as unread.
    if (messageUser.id == currentUser.id) return false;

    // Don't count restricted messages as unread.
    if (message.isNotVisibleTo(currentUser.id)) return false;

    // Don't count messages from muted users as unread.
    final isMuted = currentUser.mutes.any((it) => it.user.id == messageUser.id);
    if (isMuted) return false;

    final lastRead = currentUserRead?.lastRead;
    // Don't count messages created before the last read time as unread.
    if (lastRead case final read? when message.createdAt.isBefore(read)) {
      return false;
    }

    final lastReadMessageId = currentUserRead?.lastReadMessageId;
    // Don't count if the last read message id is the same as the message id.
    if (lastReadMessageId case final id? when message.id == id) {
      return false;
    }

    // If we've passed all checks, count the message as unread.
    return true;
  }

  /// Counts the number of unread messages mentioning the current user.
  ///
  /// **NOTE**: The method relies on the [Channel.messages] list and doesn't do
  /// any API call. Therefore, the count might be not reliable as it relies on
  /// the local data.
  int countUnreadMentions() {
    final lastRead = currentUserRead?.lastRead;
    final userId = _channel.client.state.currentUser?.id;

    var count = 0;
    for (final message in messages) {
      if (_countMessageAsUnread(message) &&
          (lastRead == null || message.createdAt.isAfter(lastRead)) &&
          message.mentionedUsers.any((user) => user.id == userId) == true) {
        count++;
      }
    }
    return count;
  }

  /// Delete all channel messages.
  void truncate() {
    _channelState = _channelState.copyWith(
      messages: [],
    );
  }

  final List<String> _updatedMessagesIds = [];

  /// Update channelState with updated information.
  void updateChannelState(ChannelState updatedState) {
    final _existingStateMessages = <Message>[...messages];
    final newMessages = _mergeMessagesIntoExisting(
      existing: _existingStateMessages,
      toMerge: updatedState.messages ?? <Message>[],
    ).sorted(_sortByCreatedAt);

    final _existingStateWatchers = <User>[...?_channelState.watchers];
    final newWatchers = <User>[
      ..._existingStateWatchers.merge(
        updatedState.watchers,
        key: (watcher) => watcher.id,
        update: (original, updated) => updated,
      ),
    ];

    final _existingStateRead = <Read>[...?_channelState.read];
    final newReads = <Read>[
      ..._existingStateRead.merge(
        updatedState.read,
        key: (read) => read.user.id,
        update: (original, updated) => updated,
      ),
    ];

    final newMembers = <Member>[...?updatedState.members];

    _checkExpiredAttachmentMessages(updatedState);

    _channelState = _channelState.copyWith(
      messages: newMessages,
      channel: _channelState.channel?.merge(updatedState.channel),
      watchers: newWatchers,
      watcherCount: updatedState.watcherCount,
      members: newMembers,
      membership: updatedState.membership,
      read: newReads,
      draft: updatedState.draft,
      pinnedMessages: updatedState.pinnedMessages,
      pushPreferences: updatedState.pushPreferences,
    );
  }

  int _sortByCreatedAt(Message a, Message b) =>
      a.createdAt.compareTo(b.createdAt);

  /// The channel state related to this client.
  ChannelState get _channelState => _channelStateController.value;

  /// The channel state related to this client as a stream.
  Stream<ChannelState> get channelStateStream => _channelStateController.stream;

  /// The channel state related to this client.
  ChannelState get channelState => _channelStateController.value;
  late BehaviorSubject<ChannelState> _channelStateController;

  late final _debouncedUpdatePersistenceChannelState = debounce(
    (ChannelState state) {
      final persistenceClient = _channel._client.chatPersistenceClient;
      return persistenceClient?.updateChannelState(state);
    },
    const Duration(seconds: 1),
  );

  set _channelState(ChannelState v) {
    _channelStateController.safeAdd(v);
    _debouncedUpdatePersistenceChannelState.call([v]);
  }

  late final _debouncedUpdatePersistenceChannelThreads = debounce(
    (Map<String, List<Message>> threads) async {
      final channelCid = _channel.cid;
      if (channelCid == null) return;

      final persistenceClient = _channel._client.chatPersistenceClient;
      return persistenceClient?.updateChannelThreads(channelCid, threads);
    },
    const Duration(seconds: 1),
  );

  /// The channel threads related to this channel.
  Map<String, List<Message>> get threads => {..._threadsController.value};

  /// The channel threads related to this channel as a stream.
  Stream<Map<String, List<Message>>> get threadsStream => _threadsController;
  final _threadsController = BehaviorSubject.seeded(<String, List<Message>>{});
  set _threads(Map<String, List<Message>> threads) {
    _threadsController.safeAdd(threads);
    _debouncedUpdatePersistenceChannelThreads.call([threads]);
  }

  /// Clears all the replies in the thread identified by [parentId].
  void clearThread(String parentId) {
    final updatedThreads = {
      ...threads,
      parentId: <Message>[],
    };

    _threads = updatedThreads;
  }

  /// Update threads with updated information about messages.
  void updateThreadInfo(String parentId, List<Message> messages) {
    final updatedThreads = {...threads};

    final threadMessages = [...?updatedThreads[parentId]];
    final updatedThreadMessages = _mergeMessagesIntoExisting(
      existing: threadMessages,
      toMerge: messages,
    ).sorted(_sortByCreatedAt);

    // Update the thread with the modified message list.
    updatedThreads[parentId] = updatedThreadMessages;

    _threads = updatedThreads;
  }

  Draft? _getThreadDraft(String parentId, List<Message>? messages) {
    return messages?.firstWhereOrNull((it) => it.id == parentId)?.draft;
  }

  /// Draft for a specific thread identified by [parentId].
  Draft? threadDraft(String parentId) => _getThreadDraft(parentId, messages);

  /// Stream of draft for a specific thread identified by [parentId].
  ///
  /// This stream emits a new value whenever the draft associated with the
  /// specified thread is updated or removed.
  Stream<Draft?> threadDraftStream(String parentId) => channelStateStream
      .map((cs) => _getThreadDraft(parentId, cs.messages))
      .distinct();

  /// Channel related typing users stream.
  Stream<Map<User, Event>> get typingEventsStream =>
      _typingEventsController.stream;

  /// Channel related typing users last value.
  Map<User, Event> get typingEvents => _typingEventsController.value;
  final _typingEventsController = BehaviorSubject.seeded(<User, Event>{});

  void _listenTypingEvents() {
    if (_channelState.channel?.config.typingEvents == false) return;

    final currentUser = _channel.client.state.currentUser;
    if (currentUser == null) return;

    _subscriptions
      ..add(
        _channel.on(EventType.typingStart).listen(
          (event) {
            final user = event.user;
            if (user != null && user.id != currentUser.id) {
              final events = {...typingEvents};
              events[user] = event;
              _typingEventsController.safeAdd(events);
            }
          },
        ),
      )
      ..add(
        _channel.on(EventType.typingStop).listen(
          (event) {
            final user = event.user;
            if (user != null && user.id != currentUser.id) {
              final events = {...typingEvents}..remove(user);
              _typingEventsController.safeAdd(events);
            }
          },
        ),
      );
  }

  Timer? _staleTypingEventsCleanerTimer;

  // Checks and removes stale typing events that were not explicitly stopped by
  // the sender due to technical difficulties. e.g. process death, loss of
  // Internet connection or custom implementation.
  void _startCleaningStaleTypingEvents() {
    if (_channelState.channel?.config.typingEvents == false) return;

    _staleTypingEventsCleanerTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final now = DateTime.now();
        typingEvents.forEach((user, event) {
          if (now.difference(event.createdAt).inSeconds >
              incomingTypingStartEventTimeout) {
            _channel.client.handleEvent(
              Event(
                type: EventType.typingStop,
                user: user,
                cid: _channel.cid,
                parentId: event.parentId,
              ),
            );
          }
        });
      },
    );
  }

  Timer? _stalePinnedMessagesCleanerTimer;

  // Checks and removes stale pinned messages that are not valid anymore.
  void _startCleaningStalePinnedMessages() {
    _stalePinnedMessagesCleanerTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        final now = DateTime.now();
        var expiredMessages = channelState.pinnedMessages
            ?.where((m) => m.pinExpires?.isBefore(now) == true)
            .toList();
        if (expiredMessages != null && expiredMessages.isNotEmpty) {
          expiredMessages = expiredMessages
              .map((m) => m.copyWith(
                    pinExpires: null,
                    pinned: false,
                  ))
              .toList();

          updateChannelState(_channelState.copyWith(
            pinnedMessages: pinnedMessages.where(_pinIsValid).toList(),
            messages: expiredMessages,
          ));
        }
      },
    );
  }

  // Listens to channel push preference update events and updates the state
  void _listenChannelPushPreferenceUpdated() {
    _subscriptions.add(
      _channel.on(EventType.channelPushPreferenceUpdated).listen(
        (event) {
          final pushPreferences = event.channelPushPreference;
          if (pushPreferences == null) return;

          updateChannelState(
            channelState.copyWith(
              pushPreferences: pushPreferences,
            ),
          );
        },
      ),
    );
  }

  void _deleteMessagesFromUser({
    required String userId,
    bool hardDelete = false,
    DateTime? deletedAt,
  }) {
    final userMessages = <String, Message>{};
    for (final message in [...messages, ...threads.values.flattened]) {
      if (message.user?.id != userId) continue;
      userMessages[message.id] = message.copyWith(
        type: MessageType.deleted,
        deletedAt: deletedAt ?? DateTime.now(),
        state: MessageState.deleted(hard: hardDelete),
      );
    }

    final messagesToDelete = userMessages.values.toList();
    return _deleteMessages(messagesToDelete, hardDelete: hardDelete);
  }

  void _deleteMessages(
    List<Message> messages, {
    bool hardDelete = false,
  }) {
    if (messages.isEmpty) return;

    if (hardDelete) return _removeMessages(messages);
    return _updateMessages(messages);
  }

  void _updateMessages(List<Message> messages) {
    if (messages.isEmpty) return;

    _updateThreadMessages(messages);
    _updateChannelMessages(messages);
  }

  void _updateThreadMessages(List<Message> messages) {
    if (messages.isEmpty) return;

    final affectedThreads = {...messages.map((it) => it.parentId).nonNulls};
    // If there are no affected threads, return early.
    if (affectedThreads.isEmpty) return;

    final updatedThreads = {...threads};
    for (final thread in affectedThreads) {
      final threadMessages = [...?updatedThreads[thread]];
      final updatedThreadMessages = _mergeMessagesIntoExisting(
        existing: threadMessages,
        toMerge: messages,
      ).sorted(_sortByCreatedAt);

      // Update the thread with the modified message list.
      updatedThreads[thread] = updatedThreadMessages;
    }

    // Update the threads map.
    _threads = updatedThreads;
  }

  void _updateChannelMessages(List<Message> messages) {
    if (messages.isEmpty) return;

    final affectedMessages = [
      ...messages.map((it) {
        // If it's not a thread message, consider it affected.
        if (it.parentId == null) return it;
        // If it's a thread message shown in channel, consider it affected.
        if (it.showInChannel == true) return it;

        return null; // Thread message not shown in channel, ignore it.
      }).nonNulls,
    ];

    // If there are no affected messages, return early.
    if (affectedMessages.isEmpty) return;

    final channelMessages = [...this.messages];
    final updatedChannelMessages = _mergeMessagesIntoExisting(
      existing: channelMessages,
      toMerge: affectedMessages,
    ).sorted(_sortByCreatedAt);

    final pinnedMessages = [...this.pinnedMessages];
    final updatedPinnedMessages = _mergeMessagesIntoExisting(
      existing: pinnedMessages,
      toMerge: affectedMessages,
    ).where(_pinIsValid).sorted(_sortByCreatedAt);

    // Calculate the new last message at time.
    var lastMessageAt = _channelState.channel?.lastMessageAt;
    final lastMessage = updatedChannelMessages.lastWhereOrNull(
      _shouldUpdateChannelLastMessageAt,
    );

    if (lastMessage != null) {
      lastMessageAt = [lastMessageAt, lastMessage.createdAt].nonNulls.max;
    }

    _channelState = _channelState.copyWith(
      messages: updatedChannelMessages,
      pinnedMessages: updatedPinnedMessages,
      channel: _channelState.channel?.copyWith(lastMessageAt: lastMessageAt),
    );
  }

  List<Message> _mergeMessagesIntoExisting({
    required List<Message> existing,
    required List<Message> toMerge,
  }) {
    if (toMerge.isEmpty) return existing;

    final mergedMessages = existing.merge(
      toMerge,
      key: (message) => message.id,
      update: (original, updated) {
        var merged = updated.syncWith(original);

        // Preserve quotedMessage if the updated doesn't include it.
        if (updated.quotedMessageId != null && updated.quotedMessage == null) {
          merged = merged.copyWith(quotedMessage: original.quotedMessage);
        }

        return merged;
      },
    );

    final toUpdateMap = {for (final m in toMerge) m.id: m};
    final updatedMessages = [
      ...mergedMessages.map((it) {
        // Continue if the message doesn't quote any of the updated messages.
        if (!toUpdateMap.containsKey(it.quotedMessageId)) return it;

        final updatedQuotedMessage = toUpdateMap[it.quotedMessageId];
        // Update the quotedMessage reference in the message.
        return it.copyWith(quotedMessage: updatedQuotedMessage);
      })
    ];

    return updatedMessages;
  }

  void _removeMessages(List<Message> messages) {
    if (messages.isEmpty) return;

    final messageIds = messages.map((m) => m.id).toSet().toList();
    final persistenceClient = _channel.client.chatPersistenceClient;
    // Remove the messages from the persistence client.
    persistenceClient?.deleteMessageByIds(messageIds);
    persistenceClient?.deletePinnedMessageByIds(messageIds);

    _removeThreadMessages(messages);
    _removeChannelMessages(messages);
  }

  void _removeThreadMessages(List<Message> messages) {
    if (messages.isEmpty) return;

    final affectedThreads = {...messages.map((it) => it.parentId).nonNulls};
    // If there are no affected threads, return early.
    if (affectedThreads.isEmpty) return;

    final updatedThreads = {...threads};
    for (final thread in affectedThreads) {
      final threadMessages = updatedThreads[thread];
      // Continue if the thread doesn't exist.
      if (threadMessages == null) continue;

      // Remove the deleted message from the thread messages and reference from
      // other messages quoting it.
      final updatedThreadMessages = _removeMessagesFromExisting(
        existing: threadMessages,
        toRemove: messages,
      );

      // If there are no more messages in the thread, remove the thread entry.
      if (updatedThreadMessages.isEmpty) {
        updatedThreads.remove(thread);
        continue;
      }

      // Otherwise, update the thread with the modified message list.
      updatedThreads[thread] = updatedThreadMessages;
    }

    // Update the threads map.
    _threads = updatedThreads;
  }

  void _removeChannelMessages(List<Message> messages) {
    if (messages.isEmpty) return;

    final affectedMessages = [
      ...messages.map((it) {
        // If it's not a thread message, consider it affected.
        if (it.parentId == null) return it;
        // If it's a thread message shown in channel, consider it affected.
        if (it.showInChannel == true) return it;

        return null; // Thread message not shown in channel, ignore it.
      }).nonNulls,
    ];

    // If there are no affected messages, return early.
    if (affectedMessages.isEmpty) return;

    final channelMessages = [...this.messages];
    final updatedChannelMessages = _removeMessagesFromExisting(
      existing: channelMessages,
      toRemove: affectedMessages,
    );

    final pinnedMessages = [...this.pinnedMessages];
    final updatedPinnedMessages = _removeMessagesFromExisting(
      existing: pinnedMessages,
      toRemove: affectedMessages,
    );

    _channelState = _channelState.copyWith(
      messages: updatedChannelMessages,
      pinnedMessages: updatedPinnedMessages,
    );
  }

  List<Message> _removeMessagesFromExisting({
    required List<Message> existing,
    required List<Message> toRemove,
  }) {
    if (toRemove.isEmpty) return existing;

    final toRemoveIds = toRemove.map((m) => m.id).toSet();
    final updatedMessages = [
      ...existing.where((it) => !toRemoveIds.contains(it.id)).map((it) {
        // Continue if the message doesn't quote any of the deleted messages.
        if (!toRemoveIds.contains(it.quotedMessageId)) return it;

        // Setting it to null will remove the quoted message from the message.
        return it.copyWith(quotedMessageId: null, quotedMessage: null);
      }),
    ];

    return updatedMessages;
  }

  // Listens to user message deleted events and marks messages from that user
  // as either soft or hard deleted based on the event data.
  void _listenUserMessagesDeleted() {
    _subscriptions.add(
      _channel.on(EventType.userMessagesDeleted).listen((event) {
        final user = event.user;
        if (user == null) return;

        return _deleteMessagesFromUser(
          userId: user.id,
          hardDelete: event.hardDelete ?? false,
          deletedAt: event.createdAt,
        );
      }),
    );
  }

  /// Call this method to dispose this object.
  void dispose() {
    _debouncedUpdatePersistenceChannelThreads.cancel();
    _debouncedUpdatePersistenceChannelState.cancel();
    _retryQueue.dispose();
    _subscriptions.cancel();
    _channelStateController.close();
    _isUpToDateController.close();
    _threadsController.close();
    _staleTypingEventsCleanerTimer?.cancel();
    _stalePinnedMessagesCleanerTimer?.cancel();
    _typingEventsController.close();
  }
}

bool _pinIsValid(Message message) {
  // If the message is not pinned, it's not valid.
  if (message.pinned != true) return false;

  // If there's no expiration, the pin is valid.
  final pinExpires = message.pinExpires;
  if (pinExpires == null) return true;

  // If there's an expiration, check if it's still valid.
  return pinExpires.isAfter(DateTime.now());
}

/// Extension methods for checking channel capabilities on a Channel instance.
///
/// These methods provide a convenient way to check if the current user has
/// specific capabilities in a channel.
extension ChannelCapabilityCheck on Channel {
  /// True, if the current user can send a message to this channel.
  bool get canSendMessage {
    return ownCapabilities.contains(ChannelCapability.sendMessage);
  }

  /// True, if the current user can send a reply to this channel.
  bool get canSendReply {
    return ownCapabilities.contains(ChannelCapability.sendReply);
  }

  /// True, if the current user can send a message with restricted visibility.
  bool get canSendRestrictedVisibilityMessage {
    return ownCapabilities.contains(
      ChannelCapability.sendRestrictedVisibilityMessage,
    );
  }

  /// True, if the current user can send reactions.
  bool get canSendReaction {
    return ownCapabilities.contains(ChannelCapability.sendReaction);
  }

  /// True, if the current user can attach links to messages.
  bool get canSendLinks {
    return ownCapabilities.contains(ChannelCapability.sendLinks);
  }

  /// True, if the current user can attach files to messages.
  bool get canCreateAttachment {
    return ownCapabilities.contains(ChannelCapability.createAttachment);
  }

  /// True, if the current user can freeze or unfreeze channel.
  bool get canFreezeChannel {
    return ownCapabilities.contains(ChannelCapability.freezeChannel);
  }

  /// True, if the current user can enable or disable slow mode.
  bool get canSetChannelCooldown {
    return ownCapabilities.contains(ChannelCapability.setChannelCooldown);
  }

  /// True, if the current user can leave channel (remove own membership).
  bool get canLeaveChannel {
    return ownCapabilities.contains(ChannelCapability.leaveChannel);
  }

  /// True, if the current user can join channel (add own membership).
  bool get canJoinChannel {
    return ownCapabilities.contains(ChannelCapability.joinChannel);
  }

  /// True, if the current user can pin a message.
  bool get canPinMessage {
    return ownCapabilities.contains(ChannelCapability.pinMessage);
  }

  /// True, if the current user can delete any message from the channel.
  bool get canDeleteAnyMessage {
    return ownCapabilities.contains(ChannelCapability.deleteAnyMessage);
  }

  /// True, if the current user can delete own messages from the channel.
  bool get canDeleteOwnMessage {
    return ownCapabilities.contains(ChannelCapability.deleteOwnMessage);
  }

  /// True, if the current user can update any message in the channel.
  bool get canUpdateAnyMessage {
    return ownCapabilities.contains(ChannelCapability.updateAnyMessage);
  }

  /// True, if the current user can update own messages in the channel.
  bool get canUpdateOwnMessage {
    return ownCapabilities.contains(ChannelCapability.updateOwnMessage);
  }

  /// True, if the current user can use message search.
  bool get canSearchMessages {
    return ownCapabilities.contains(ChannelCapability.searchMessages);
  }

  /// True, if the current user can send typing events.
  bool get canSendTypingEvents {
    return ownCapabilities.contains(ChannelCapability.sendTypingEvents);
  }

  /// True, if the current user can upload message attachments.
  bool get canUploadFile {
    return ownCapabilities.contains(ChannelCapability.uploadFile);
  }

  /// True, if the current user can delete channel.
  bool get canDeleteChannel {
    return ownCapabilities.contains(ChannelCapability.deleteChannel);
  }

  /// True, if the current user can update channel data.
  bool get canUpdateChannel {
    return ownCapabilities.contains(ChannelCapability.updateChannel);
  }

  /// True, if the current user can update channel members.
  bool get canUpdateChannelMembers {
    return ownCapabilities.contains(ChannelCapability.updateChannelMembers);
  }

  /// True, if the current user can update thread data.
  bool get canUpdateThread {
    return ownCapabilities.contains(ChannelCapability.updateThread);
  }

  /// True, if the current user can quote a message.
  bool get canQuoteMessage {
    return ownCapabilities.contains(ChannelCapability.quoteMessage);
  }

  /// True, if the current user can ban channel members.
  bool get canBanChannelMembers {
    return ownCapabilities.contains(ChannelCapability.banChannelMembers);
  }

  /// True, if the current user can flag a message.
  bool get canFlagMessage {
    return ownCapabilities.contains(ChannelCapability.flagMessage);
  }

  /// True, if the current user can mute a channel.
  bool get canMuteChannel {
    return ownCapabilities.contains(ChannelCapability.muteChannel);
  }

  /// True, if the current user can send custom events.
  bool get canSendCustomEvents {
    return ownCapabilities.contains(ChannelCapability.sendCustomEvents);
  }

  /// True, if the current user has read events capability.
  bool get canReceiveReadEvents {
    return ownCapabilities.contains(ChannelCapability.readEvents);
  }

  /// True, if the current user has connect events capability.
  bool get canReceiveConnectEvents {
    return ownCapabilities.contains(ChannelCapability.connectEvents);
  }

  /// True, if the current user can send and receive typing events.
  bool get canUseTypingEvents {
    return ownCapabilities.contains(ChannelCapability.typingEvents);
  }

  /// True, if channel slow mode is active.
  bool get isInSlowMode {
    return ownCapabilities.contains(ChannelCapability.slowMode);
  }

  /// True, if the current user is allowed to post messages as usual even if the
  /// channel is in slow mode.
  bool get canSkipSlowMode {
    return ownCapabilities.contains(ChannelCapability.skipSlowMode);
  }

  /// True, if the current user can create a poll.
  bool get canSendPoll {
    return ownCapabilities.contains(ChannelCapability.sendPoll);
  }

  /// True, if the current user can vote in a poll.
  bool get canCastPollVote {
    return ownCapabilities.contains(ChannelCapability.castPollVote);
  }

  /// True, if the current user can query poll votes.
  bool get canQueryPollVotes {
    return ownCapabilities.contains(ChannelCapability.queryPollVotes);
  }
}
