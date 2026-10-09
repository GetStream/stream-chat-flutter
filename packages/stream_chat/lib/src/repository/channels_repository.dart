import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api;
import '../core/models/request/message_delivery.dart';
import '../core/models/response/delete_channel_response.dart';
import '../core/models/response/hide_channel_response.dart';
import '../core/models/response/mark_delivered_response.dart';
import '../core/models/response/mark_read_response.dart';
import '../core/models/response/show_channel_response.dart';
import '../core/models/response/update_channel_partial_response.dart';
import '../core/models/response/update_member_partial_response.dart';
import 'mapper/channels_mapper.dart';
import 'mapper/result_mapper.dart';

/// Repository dedicated to channel operations.
class ChannelsRepository {
  /// Creates a new channels repository.
  const ChannelsRepository(this._api);

  final api.DefaultApi _api;

  /// Partially updates a channel: sets the fields in [set] and removes the fields named in [unset], leaving every
  /// other field as it is.
  ///
  /// At least one of [set] and [unset] is required.
  Future<Result<UpdateChannelPartialResponse>> updateChannelPartial(
    String channelId,
    String channelType, {
    Map<String, Object?>? set,
    List<String>? unset,
  }) async {
    final result = await _api.updateChannelPartial(
      type: channelType,
      id: channelId,
      updateChannelPartialRequest: api.UpdateChannelPartialRequest(set: set, unset: unset),
    );

    return result.map((response) => response.toModel());
  }

  /// Partially updates the current user's membership of a channel: sets the fields in [set] and removes the fields
  /// named in [unset], leaving every other field as it is.
  ///
  /// At least one of [set] and [unset] is required.
  Future<Result<UpdateMemberPartialResponse>> updateMemberPartial(
    String channelId,
    String channelType, {
    Map<String, Object?>? set,
    List<String>? unset,
  }) async {
    final result = await _api.updateMemberPartial(
      type: channelType,
      id: channelId,
      updateMemberPartialRequest: api.UpdateMemberPartialRequest(set: set, unset: unset),
    );

    return result.map((response) => response.toModel());
  }

  /// Hides a channel from the current user's channel list until a new message is added to it.
  ///
  /// If [clearHistory] is true, the channel's messages are also cleared for the current user.
  Future<Result<HideChannelResponse>> hideChannel(
    String channelId,
    String channelType, {
    bool clearHistory = false,
  }) async {
    final result = await _api.hideChannel(
      type: channelType,
      id: channelId,
      hideChannelRequest: api.HideChannelRequest(clearHistory: clearHistory),
    );

    return result.map((response) => response.toModel());
  }

  /// Shows a channel the current user hid.
  Future<Result<ShowChannelResponse>> showChannel(
    String channelId,
    String channelType,
  ) async {
    final result = await _api.showChannel(type: channelType, id: channelId);

    return result.map((response) => response.toModel());
  }

  /// Deletes a channel and its messages.
  Future<Result<DeleteChannelResponse>> deleteChannel(
    String channelId,
    String channelType,
  ) async {
    final result = await _api.deleteChannel(type: channelType, id: channelId);

    return result.map((response) => response.toModel());
  }

  /// Marks a channel, or one of its threads, as read for the current user.
  ///
  /// With [threadId], the id of a thread's parent message, marks that thread as read. Otherwise marks the channel's
  /// messages as read up to and including the one with [messageId], or all of them when [messageId] is null.
  Future<Result<MarkReadResponse>> markRead(
    String channelId,
    String channelType, {
    String? messageId,
    String? threadId,
  }) async {
    final result = await _api.markRead(
      type: channelType,
      id: channelId,
      markReadRequest: api.MarkReadRequest(messageId: messageId, threadId: threadId),
    );

    return result.map((response) => response.toModel());
  }

  /// Marks a channel, or one of its threads, as unread for the current user.
  ///
  /// Takes exactly one of [messageId], [messageTimestamp] and [threadId]. [messageId] marks that message and every
  /// later one as unread, [messageTimestamp] every message created after it, and [threadId], the id of a thread's
  /// parent message, that thread.
  Future<Result<void>> markUnread(
    String channelId,
    String channelType, {
    String? messageId,
    DateTime? messageTimestamp,
    String? threadId,
  }) async {
    final result = await _api.markUnread(
      type: channelType,
      id: channelId,
      markUnreadRequest: api.MarkUnreadRequest(
        messageId: messageId,
        messageTimestamp: messageTimestamp,
        threadId: threadId,
      ),
    );

    return result.ignoreValue();
  }

  /// Marks all of the current user's channels as read.
  Future<Result<MarkReadResponse>> markChannelsRead() async {
    final result = await _api.markChannelsRead(markChannelsReadRequest: const api.MarkChannelsReadRequest());

    return result.map((response) => response.toModel());
  }

  /// Sends delivery receipts for the messages in [deliveries].
  Future<Result<MarkDeliveredResponse>> markDelivered(Iterable<MessageDelivery> deliveries) async {
    final result = await _api.markDelivered(
      markDeliveredRequest: api.MarkDeliveredRequest(
        latestDeliveredMessages: [...deliveries.map((it) => it.toRequest())],
      ),
    );

    return result.map((response) => response.toModel());
  }
}
