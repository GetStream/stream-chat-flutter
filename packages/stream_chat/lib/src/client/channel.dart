import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart'
    show IterableExtension, ListEquality;
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/client/retry_queue.dart';
import 'package:stream_chat/src/core/util/utils.dart';
import 'package:stream_chat/stream_chat.dart';

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

  /// Stores time at which cooldown was started
  DateTime? cooldownStartedAt;

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
  List<String> get ownCapabilities =>
      state?._channelState.channel?.ownCapabilities ?? [];

  /// List of user permissions on this channel
  Stream<List<String>> get ownCapabilitiesStream {
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

    void updateAttachment(Attachment attachment) {
      final index = message!.attachments.indexWhere(
        (it) => it.id == attachment.id,
      );
      if (index != -1) {
        final newAttachments = [...message!.attachments]..[index] = attachment;
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

      final isImage = it.type == 'image';
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
    // Cancelling previous completer in case it's called again in the process
    // Eg. Updating the message while the previous call is in progress.
    _messageAttachmentsUploadCompleter
        .remove(message.id)
        ?.completeError('Message Cancelled');

    final quotedMessage = state!.messages.firstWhereOrNull(
      (m) => m.id == message.quotedMessageId,
    );
    // ignore: parameter_assignments
    message = message.copyWith(
      createdAt: message.createdAt,
      user: _client.state.currentUser,
      quotedMessage: quotedMessage,
      status: MessageSendingStatus.sending,
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

      final response = await _client.sendMessage(
        message,
        id!,
        type,
        skipPush: skipPush,
        skipEnrichUrl: skipEnrichUrl,
      );
      state!.updateMessage(response.message);
      if (cooldown > 0) cooldownStartedAt = DateTime.now();
      return response;
    } catch (e) {
      if (e is StreamChatNetworkError && e.isRetriable) {
        state!._retryQueue.add([message]);
      }
      rethrow;
    }
  }

  /// Updates the [message] in this channel.
  ///
  /// Waits for a [_messageAttachmentsUploadCompleter] to complete
  /// before actually updating the message.
  Future<UpdateMessageResponse> updateMessage(
    Message message, {
    bool skipEnrichUrl = false,
  }) async {
    final originalMessage = message;

    // Cancelling previous completer in case it's called again in the process
    // Eg. Updating the message while the previous call is in progress.
    _messageAttachmentsUploadCompleter
        .remove(message.id)
        ?.completeError('Message Cancelled');

    // ignore: parameter_assignments
    message = message.copyWith(
      status: MessageSendingStatus.updating,
      updatedAt: message.updatedAt,
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

      final response = await _client.updateMessage(
        message,
        skipEnrichUrl: skipEnrichUrl,
      );

      final m = response.message.copyWith(
        ownReactions: message.ownReactions,
      );

      state?.updateMessage(m);

      return response;
    } catch (e) {
      if (e is StreamChatNetworkError) {
        if (e.isRetriable) {
          state!._retryQueue.add([message]);
        } else {
          state?.updateMessage(originalMessage);
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
    try {
      final response = await _client.partialUpdateMessage(
        message.id,
        set: set,
        unset: unset,
        skipEnrichUrl: skipEnrichUrl,
      );

      final updatedMessage = response.message.copyWith(
        ownReactions: message.ownReactions,
      );

      state?.updateMessage(updatedMessage);

      return response;
    } catch (e) {
      if (e is StreamChatNetworkError && e.isRetriable) {
        state!._retryQueue.add([message]);
      }
      rethrow;
    }
  }

  /// Deletes the [message] from the channel.
  Future<EmptyResponse> deleteMessage(Message message, {bool? hard}) async {
    final hardDelete = hard ?? false;

    // Directly deleting the local messages which are not yet sent to server
    if (message.status == MessageSendingStatus.sending ||
        message.status == MessageSendingStatus.failed) {
      state!.deleteMessage(
        message.copyWith(
          type: 'deleted',
          status: MessageSendingStatus.sent,
        ),
        hardDelete: hardDelete,
      );

      // Removing the attachments upload completer to stop the `sendMessage`
      // waiting for attachments to complete.
      _messageAttachmentsUploadCompleter
          .remove(message.id)
          ?.completeError(Exception('Message deleted'));
      return EmptyResponse();
    }

    try {
      // ignore: parameter_assignments
      message = message.copyWith(
        type: 'deleted',
        status: MessageSendingStatus.deleting,
        deletedAt: message.deletedAt ?? DateTime.now(),
      );

      state?.deleteMessage(message, hardDelete: hardDelete);

      final response = await _client.deleteMessage(message.id, hard: hard);

      state?.deleteMessage(
        message.copyWith(status: MessageSendingStatus.sent),
        hardDelete: hardDelete,
      );

      return response;
    } catch (e) {
      if (e is StreamChatNetworkError && e.isRetriable) {
        state!._retryQueue.add([message]);
      }
      rethrow;
    }
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
    final messageId = message.id;
    final now = DateTime.now();
    final user = _client.state.currentUser;

    var latestReactions = [...message.latestReactions ?? <Reaction>[]];
    if (enforceUnique) {
      latestReactions.removeWhere((it) => it.userId == user!.id);
    }

    final newReaction = Reaction(
      messageId: messageId,
      createdAt: now,
      type: type,
      user: user,
      score: score,
      extraData: extraData,
    );

    latestReactions = (latestReactions
          // Inserting at the 0th index as it's the latest reaction
          ..insert(0, newReaction))
        .take(10)
        .toList();
    final ownReactions = enforceUnique
        ? <Reaction>[newReaction]
        : <Reaction>[
            ...message.ownReactions ?? [],
            newReaction,
          ];

    final newMessage = message.copyWith(
      reactionCounts: {...message.reactionCounts ?? <String, int>{}}
        ..update(type, (value) {
          if (enforceUnique) return value;
          return value + 1;
        }, ifAbsent: () => 1), // ignore: prefer-trailing-comma
      reactionScores: {...message.reactionScores ?? <String, int>{}}
        ..update(type, (value) {
          if (enforceUnique) return value;
          return value + 1;
        }, ifAbsent: () => 1), // ignore: prefer-trailing-comma
      latestReactions: latestReactions,
      ownReactions: ownReactions,
    );

    state?.updateMessage(newMessage);

    try {
      final reactionResp = await _client.sendReaction(
        messageId,
        type,
        score: score,
        extraData: extraData,
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
    final type = reaction.type;

    final reactionCounts = {...message.reactionCounts ?? <String, int>{}};
    if (reactionCounts.containsKey(type)) {
      reactionCounts.update(type, (value) => value - 1);
    }
    final reactionScores = {...message.reactionScores ?? <String, int>{}};
    if (reactionScores.containsKey(type)) {
      reactionScores.update(type, (value) => value - 1);
    }

    final latestReactions = [...message.latestReactions ?? <Reaction>[]]
      ..removeWhere((r) =>
          r.userId == reaction.userId &&
          r.type == reaction.type &&
          r.messageId == reaction.messageId);

    final ownReactions = message.ownReactions
      ?..removeWhere((r) =>
          r.userId == reaction.userId &&
          r.type == reaction.type &&
          r.messageId == reaction.messageId);

    final newMessage = message.copyWith(
      reactionCounts: reactionCounts..removeWhere((_, value) => value == 0),
      reactionScores: reactionScores..removeWhere((_, value) => value == 0),
      latestReactions: latestReactions,
      ownReactions: ownReactions,
    );

    state?.updateMessage(newMessage);

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
  /// Optionally provide a [messageId] if you want to mark a
  /// particular message as read.
  Future<EmptyResponse> markRead({String? messageId}) async {
    _checkInitialized();
    client.state.totalUnreadCount =
        max(0, (client.state.totalUnreadCount) - (state!.unreadCount));
    state!.unreadCount = 0;
    return _client.markChannelRead(id!, type, messageId: messageId);
  }

  /// Loads the initial channel state and watches for changes.
  Future<ChannelState> watch() async {
    ChannelState response;

    try {
      response = await query(watch: true);
    } catch (error, stackTrace) {
      if (!_initializedCompleter.isCompleted) {
        _initializedCompleter.completeError(error, stackTrace);
      }
      rethrow;
    }

    if (state == null) {
      _initState(response);
    }

    return response;
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
    final cachedReplies = await _client.chatPersistenceClient?.getReplies(
      parentId,
      options: options,
    );
    if (cachedReplies != null && cachedReplies.isNotEmpty) {
      state?.updateThreadInfo(parentId, cachedReplies);
      if (preferOffline) {
        return QueryRepliesResponse()..messages = cachedReplies;
      }
    }
    final repliesResponse = await _client.getReplies(
      parentId,
      options: options,
    );
    state?.updateThreadInfo(parentId, repliesResponse.messages);
    return repliesResponse;
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
    state?.updateChannelState(ChannelState(messages: messages));
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
  Future<ChannelState> create() async => query(state: false);

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
    if (preferOffline && cid != null) {
      final updatedState = await _client.chatPersistenceClient
          ?.getChannelStateByCid(cid!, messagePagination: messagesPagination);
      if (updatedState != null &&
          updatedState.messages != null &&
          updatedState.messages!.isNotEmpty) {
        if (this.state == null) {
          _initState(updatedState);
        } else {
          this.state?.updateChannelState(updatedState);
        }
        return updatedState;
      }
    }

    try {
      final updatedState = await _client.queryChannel(
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
        _id = updatedState.channel!.id;
        _cid = updatedState.channel!.cid;
      }

      this.state?.updateChannelState(updatedState);
      return updatedState;
    } catch (e) {
      if (!_client.persistenceEnabled) {
        rethrow;
      }
      return _client.chatPersistenceClient!.getChannelStateByCid(
        cid!,
        messagePagination: messagesPagination,
      );
    }
  }

  /// Query channel members.
  Future<QueryMembersResponse> queryMembers({
    Filter? filter,
    List<SortOption>? sort,
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
    List<SortOption>? sort,
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

  /// Mutes the channel.
  Future<EmptyResponse> mute({Duration? expiration}) {
    _checkInitialized();
    return _client.muteChannel(cid!, expiration: expiration);
  }

  /// Unmute the channel.
  Future<EmptyResponse> unmute() {
    _checkInitialized();
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
    final response = await _client.hideChannel(
      id!,
      type,
      clearHistory: clearHistory,
    );
    if (clearHistory) {
      state!.truncate();
      final cid = _cid;
      if (cid != null) {
        await _client.chatPersistenceClient?.deleteMessageByCid(cid);
      }
    }
    return response;
  }

  /// Removes the hidden status for the channel.
  Future<EmptyResponse> show() async {
    _checkInitialized();
    return _client.showChannel(id!, type);
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
    _keyStrokeHandler.cancel();
  }

  void _checkInitialized() {
    assert(
      _initializedCompleter.isCompleted,
      "Channel $cid hasn't been initialized yet. Make sure to call .watch()"
      ' or to instantiate the client using [Channel.fromState]',
    );
  }
}

/// The class that handles the state of the channel listening to the events.
class ChannelClientState {
  /// Creates a new instance listening to events and updating the state.
  ChannelClientState(
    this._channel,
    ChannelState channelState,
    //ignore: unnecessary_parenthesis
  ) : _debouncedUpdatePersistenceChannelState = ((ChannelState state) =>
                _channel._client.chatPersistenceClient
                    ?.updateChannelState(state))
            .debounced(const Duration(seconds: 1)) {
    _retryQueue = RetryQueue(
      channel: _channel,
      logger: _channel.client.detachedLogger(
        '⟳ (${generateHash([_channel.cid])})',
      ),
    );

    _checkExpiredAttachmentMessages(channelState);

    _channelStateController = BehaviorSubject.seeded(channelState);

    _listenTypingEvents();

    _listenMessageNew();

    _listenMessageDeleted();

    _listenMessageUpdated();

    _listenReactions();

    _listenReactionDeleted();

    _listenReadEvents();

    _listenChannelTruncated();

    _listenChannelUpdated();

    _listenMemberAdded();

    _listenMemberRemoved();

    _listenMemberUpdated();

    _listenMemberBanned();

    _listenMemberUnbanned();

    _listenUserStartWatching();

    _listenUserStopWatching();

    _startCleaningStaleTypingEvents();

    _startCleaningStalePinnedMessages();

    _channel._client.chatPersistenceClient
        ?.getChannelThreads(_channel.cid!)
        .then((threads) {
      _threads = threads;
    }).then((_) {
      _channel._client.chatPersistenceClient
          ?.getChannelStateByCid(_channel.cid!)
          .then((state) {
        // Replacing the persistence state members with the latest
        // `channelState.members` as they may have changes over the time.
        updateChannelState(state.copyWith(members: channelState.members));
        retryFailedMessages();
      });
    });
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
      final member = e.member;
      final existingMembers = channelState.members ?? [];
      updateChannelState(channelState.copyWith(
        members: [
          ...existingMembers,
          member!,
        ],
      ));
    }));
  }

  void _listenMemberRemoved() {
    _subscriptions.add(_channel.on(EventType.memberRemoved).listen((Event e) {
      final user = e.user;
      final existingMembers = channelState.members ?? [];
      final existingRead = channelState.read ?? [];
      updateChannelState(channelState.copyWith(
        members: existingMembers
            .where((m) => m.userId != user!.id)
            .toList(growable: false),
        read: existingRead
            .where((r) => r.user.id != user!.id)
            .toList(growable: false),
      ));
    }));
  }

  void _listenMemberUpdated() {
    _subscriptions.add(_channel.on(EventType.memberUpdated).listen((Event e) {
      final member = e.member;
      final existingMembers = channelState.members ?? [];
      updateChannelState(channelState.copyWith(
        members: existingMembers
            .map((m) => m.userId == member!.userId ? member : m)
            .toList(growable: false),
      ));
    }));
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
              ...?existingWatchers,
              watcher,
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
            watchers: existingWatchers
                ?.where((user) => user.id != watcher.id)
                .toList(growable: false),
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

  set isUpToDate(bool isUpToDate) => _isUpToDateController.add(isUpToDate);

  /// [isUpToDate] flag count as a stream.
  Stream<bool> get isUpToDateStream => _isUpToDateController.stream;

  final BehaviorSubject<bool> _isUpToDateController =
      BehaviorSubject.seeded(true);

  /// The retry queue associated to this channel.
  late final RetryQueue _retryQueue;

  /// Retry failed message.
  Future<void> retryFailedMessages() async {
    final failedMessages = [...messages, ...threads.values.expand((v) => v)]
        .where(
          (message) =>
              message.status != MessageSendingStatus.sent &&
              message.createdAt.isBefore(
                DateTime.now().subtract(const Duration(seconds: 5)),
              ),
        )
        .toList();

    _retryQueue.add(failedMessages);
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
        ownReactions: oldMessage?.ownReactions,
      );
      updateMessage(message);

      if (message.pinned) {
        final _existingPinnedMessages = _channelState.pinnedMessages ?? [];
        _channelState = _channelState.copyWith(
          pinnedMessages: [
            ..._existingPinnedMessages,
            message,
          ],
        );
      }
    }));
  }

  void _listenMessageDeleted() {
    _subscriptions.add(_channel.on(EventType.messageDeleted).listen((event) {
      final message = event.message!;
      if (event.hardDelete == true) {
        removeMessage(message);
      } else {
        updateMessage(message);
      }
    }));
  }

  void _listenMessageNew() {
    _subscriptions.add(_channel
        .on(
      EventType.messageNew,
      EventType.notificationMessageNew,
    )
        .listen((event) {
      final message = event.message!;
      if (isUpToDate ||
          (message.parentId != null && message.showInChannel != true)) {
        updateMessage(message);
      }

      if (_countMessageAsUnread(message)) {
        unreadCount += 1;
      }
    }));
  }

  /// Updates the [message] in the state if it exists. Adds it otherwise.
  void updateMessage(Message message) {
    if (message.parentId == null || message.showInChannel == true) {
      final newMessages = [...messages];
      final oldIndex = newMessages.indexWhere((m) => m.id == message.id);
      if (oldIndex != -1) {
        Message? m;
        if (message.quotedMessageId != null && message.quotedMessage == null) {
          final oldMessage = newMessages[oldIndex];
          m = message.copyWith(
            quotedMessage: oldMessage.quotedMessage,
          );
        }
        newMessages[oldIndex] = m ?? message;
      } else {
        newMessages.add(message);
      }

      final newPinnedMessages = [...pinnedMessages];
      final oldPinnedIndex =
          newPinnedMessages.indexWhere((m) => m.id == message.id);

      // Handle pinned messages
      if (message.pinned) {
        if (oldPinnedIndex != -1) {
          newPinnedMessages[oldPinnedIndex] = message;
        } else {
          newPinnedMessages.add(message);
        }
      } else {
        newPinnedMessages.removeWhere((m) => m.id == message.id);
      }

      _channelState = _channelState.copyWith(
        messages: newMessages..sort(_sortByCreatedAt),
        pinnedMessages: newPinnedMessages,
        channel: _channelState.channel?.copyWith(
          lastMessageAt: message.createdAt,
        ),
      );
    }

    if (message.parentId != null) {
      updateThreadInfo(message.parentId!, [message]);
    }
  }

  /// Remove a [message] from this [channelState].
  void removeMessage(Message message) async {
    await _channel._client.chatPersistenceClient?.deleteMessageById(message.id);

    final parentId = message.parentId;
    // i.e. it's a thread message, Remove it
    if (parentId != null) {
      final newThreads = {...threads};
      // Early return in case the thread is not available
      if (!newThreads.containsKey(parentId)) return;

      // Remove thread message shown in thread page.
      newThreads.update(
        parentId,
        (messages) => [...messages.where((e) => e.id != message.id)],
      );

      _threads = newThreads;

      // Early return if the thread message is not shown in channel.
      if (message.showInChannel == false) return;
    }

    // Remove regular message, thread message shown in channel
    final allMessages = [...messages];
    _channelState = _channelState.copyWith(
      messages: allMessages..removeWhere((e) => e.id == message.id),
    );
  }

  /// Removes/Updates the [message] based on the [hardDelete] value.
  void deleteMessage(Message message, {bool hardDelete = false}) {
    if (hardDelete) return removeMessage(message);
    return updateMessage(message);
  }

  void _listenReadEvents() {
    if (_channelState.channel?.config.readEvents == false) {
      return;
    }

    _subscriptions.add(
      _channel.on(EventType.messageRead, EventType.notificationMarkRead).listen(
        (event) {
          final readList = List<Read>.from(_channelState.read ?? []);
          final userReadIndex =
              read.indexWhere((r) => r.user.id == event.user!.id);

          if (userReadIndex != -1) {
            final userRead = readList.removeAt(userReadIndex);
            if (userRead.user.id == _channel._client.state.currentUser!.id) {
              unreadCount = 0;
            }
            readList.add(Read(
              user: event.user!,
              lastRead: event.createdAt,
            ));
            _channelState = _channelState.copyWith(read: readList);
          }
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
            members!.map((e) => e!.copyWith(user: users[e.user!.id])).toList(),
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
        (watchers, users) => watchers!.map((e) => users[e.id] ?? e).toList(),
      ).distinct(const ListEquality().equals);

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
    final reads = [...read];
    final currentUserReadIndex = reads.indexWhere(_isCurrentUserRead);

    if (currentUserReadIndex < 0) return;

    reads[currentUserReadIndex] =
        reads[currentUserReadIndex].copyWith(unreadMessages: count);
    _channelState = _channelState.copyWith(read: reads);
  }

  bool _countMessageAsUnread(Message message) {
    final userId = _channel.client.state.currentUser?.id;
    final userIsMuted =
        _channel.client.state.currentUser?.mutes.firstWhereOrNull(
              (m) => m.user.id == message.user?.id,
            ) !=
            null;
    final isThreadMessage = message.parentId != null;

    return !message.silent &&
        !message.shadowed &&
        message.user?.id != userId &&
        !userIsMuted &&
        !isThreadMessage;
  }

  /// Update threads with updated information about messages.
  void updateThreadInfo(String parentId, List<Message> messages) {
    final newThreads = Map<String, List<Message>>.from(threads);

    if (newThreads.containsKey(parentId)) {
      newThreads[parentId] = [
        ...messages,
        ...newThreads[parentId]!.where(
          (newMessage) => !messages.any((m) => m.id == newMessage.id),
        ),
      ]..sort(_sortByCreatedAt);
    } else {
      newThreads[parentId] = messages;
    }

    _threads = newThreads;
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
    final _existingStateMessages = _channelState.messages ?? [];
    final _updatedStateMessages = updatedState.messages ?? [];
    final newMessages = <Message>[
      ..._updatedStateMessages,
      ..._existingStateMessages
          .where((m) =>
              !_updatedStateMessages.any((newMessage) => newMessage.id == m.id))
          .toList(),
    ]..sort(_sortByCreatedAt);

    final _existingStateWatchers = _channelState.watchers ?? [];
    final _updatedStateWatchers = updatedState.watchers ?? [];
    final newWatchers = <User>[
      ..._updatedStateWatchers,
      ..._existingStateWatchers
          .where((w) =>
              !_updatedStateWatchers.any((newWatcher) => newWatcher.id == w.id))
          .toList(),
    ];

    final newMembers = <Member>[
      ...updatedState.members ?? [],
    ];

    final _existingStateRead = _channelState.read ?? [];
    final _updatedStateRead = updatedState.read ?? [];
    final newReads = <Read>[
      ..._updatedStateRead,
      ..._existingStateRead
          .where((r) =>
              !_updatedStateRead.any((newRead) => newRead.user.id == r.user.id))
          .toList(),
    ];

    _checkExpiredAttachmentMessages(updatedState);

    _channelState = _channelState.copyWith(
      messages: newMessages,
      channel: _channelState.channel?.merge(updatedState.channel),
      watchers: newWatchers,
      watcherCount: updatedState.watcherCount,
      members: newMembers,
      read: newReads,
      pinnedMessages: updatedState.pinnedMessages,
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

  final Debounce _debouncedUpdatePersistenceChannelState;

  set _channelState(ChannelState v) {
    _channelStateController.add(v);
    _debouncedUpdatePersistenceChannelState.call([v]);
  }

  /// The channel threads related to this channel.
  Map<String, List<Message>> get threads =>
      _threadsController.value.map(MapEntry.new);

  /// The channel threads related to this channel as a stream.
  Stream<Map<String, List<Message>>> get threadsStream =>
      _threadsController.stream;
  final BehaviorSubject<Map<String, List<Message>>> _threadsController =
      BehaviorSubject.seeded({});

  set _threads(Map<String, List<Message>> threads) {
    _threadsController.add(threads);
    _channel.client.chatPersistenceClient?.updateChannelThreads(
      _channel.cid!,
      threads,
    );
  }

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
              _typingEventsController.add(events);
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
              _typingEventsController.add(events);
            }
          },
        ),
      )
      ..add(
        _channel.on().where((event) {
          final user = event.user;
          if (user == null) return false;
          return members.any((m) => m.userId == user.id);
        }).listen(
          (event) {
            final newMembers = List<Member>.from(members);
            final oldMemberIndex =
                newMembers.indexWhere((m) => m.userId == event.user!.id);
            if (oldMemberIndex > -1) {
              final oldMember = newMembers.removeAt(oldMemberIndex);
              updateChannelState(
                ChannelState(
                  members: [
                    ...newMembers,
                    oldMember.copyWith(
                      user: event.user,
                    ),
                  ],
                ),
              );
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

  /// Call this method to dispose this object.
  void dispose() {
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
  final now = DateTime.now();
  return message.pinExpires!.isAfter(now);
}
