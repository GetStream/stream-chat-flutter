import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api;
import '../core/api/requests.dart';
import '../core/models/channel_state.dart';
import '../core/models/member.dart';
import '../core/models/message.dart';
import '../core/models/request/channel_member_data.dart';
import '../core/models/request/create_channel_data.dart';
import '../core/models/request/message_delivery.dart';
import '../core/models/request/update_channel_data.dart';
import '../core/models/response/channel_state_response.dart';
import '../core/models/response/delete_channel_response.dart';
import '../core/models/response/event_response.dart';
import '../core/models/response/hide_channel_response.dart';
import '../core/models/response/mark_delivered_response.dart';
import '../core/models/response/mark_read_response.dart';
import '../core/models/response/query_channels_response.dart';
import '../core/models/response/query_members_response.dart';
import '../core/models/response/show_channel_response.dart';
import '../core/models/response/truncate_channel_response.dart';
import '../core/models/response/update_channel_partial_response.dart';
import '../core/models/response/update_channel_response.dart';
import '../core/models/response/update_member_partial_response.dart';
import 'mapper/channels_mapper.dart';
import 'mapper/filter_mapper.dart';
import 'mapper/messages_mapper.dart';
import 'mapper/result_mapper.dart';
import 'mapper/sort_mapper.dart';

/// Repository dedicated to channel operations.
class ChannelsRepository {
  /// Creates a new channels repository.
  const ChannelsRepository(this._api);

  final api.DefaultApi _api;

  /// Replaces all of a channel's [data].
  Future<Result<UpdateChannelResponse>> updateChannel(
    String channelId,
    String channelType,
    UpdateChannelData data, {
    Message? message,
  }) => _updateChannel(
    channelId,
    channelType,
    api.UpdateChannelRequest(data: data.toRequest(), message: message?.toRequest()),
  );

  /// Adds [members] to a channel.
  ///
  /// A [hideHistoryBefore] takes precedence over [hideHistory].
  Future<Result<UpdateChannelResponse>> addMembers(
    String channelId,
    String channelType,
    List<ChannelMemberData> members, {
    Message? message,
    bool hideHistory = false,
    DateTime? hideHistoryBefore,
  }) => _updateChannel(
    channelId,
    channelType,
    api.UpdateChannelRequest(
      addMembers: members.map((member) => member.toRequest()).toList(),
      message: message?.toRequest(),
      hideHistory: hideHistoryBefore == null ? hideHistory : null,
      hideHistoryBefore: hideHistoryBefore,
    ),
  );

  /// Removes the users with the ids [memberIds] from a channel.
  Future<Result<UpdateChannelResponse>> removeMembers(
    String channelId,
    String channelType,
    List<String> memberIds, {
    Message? message,
  }) => _updateChannel(
    channelId,
    channelType,
    api.UpdateChannelRequest(removeMembers: memberIds, message: message?.toRequest()),
  );

  /// Invites [members] into a channel.
  Future<Result<UpdateChannelResponse>> inviteMembers(
    String channelId,
    String channelType,
    List<ChannelMemberData> members, {
    Message? message,
  }) => _updateChannel(
    channelId,
    channelType,
    api.UpdateChannelRequest(
      invites: members.map((member) => member.toRequest()).toList(),
      message: message?.toRequest(),
    ),
  );

  /// Accepts the current user's invite to a channel.
  Future<Result<UpdateChannelResponse>> acceptInvite(
    String channelId,
    String channelType, {
    Message? message,
  }) => _updateChannel(
    channelId,
    channelType,
    api.UpdateChannelRequest(acceptInvite: true, message: message?.toRequest()),
  );

  /// Rejects the current user's invite to a channel.
  Future<Result<UpdateChannelResponse>> rejectInvite(
    String channelId,
    String channelType, {
    Message? message,
  }) => _updateChannel(
    channelId,
    channelType,
    api.UpdateChannelRequest(rejectInvite: true, message: message?.toRequest()),
  );

  Future<Result<UpdateChannelResponse>> _updateChannel(
    String channelId,
    String channelType,
    api.UpdateChannelRequest request,
  ) async {
    final result = await _api.updateChannel(type: channelType, id: channelId, updateChannelRequest: request);
    return result.map((response) => response.toModel());
  }

  /// Removes the messages of a channel up to [truncatedAt], or all of them.
  Future<Result<TruncateChannelResponse>> truncateChannel(
    String channelId,
    String channelType, {
    Message? message,
    bool? skipPush,
    DateTime? truncatedAt,
  }) async {
    final result = await _api.truncateChannel(
      type: channelType,
      id: channelId,
      truncateChannelRequest: api.TruncateChannelRequest(
        message: message?.toRequest(),
        skipPush: skipPush,
        truncatedAt: truncatedAt,
      ),
    );

    return result.map((response) => response.toModel());
  }

  /// Fetches the state of a channel, creating the channel first if it does
  /// not exist.
  ///
  /// Without a [channelId], the channel is the one the members in
  /// [channelData] identify.
  Future<Result<ChannelStateResponse>> getOrCreateChannel(
    String channelType, {
    String? channelId,
    CreateChannelData? channelData,
    bool state = true,
    bool watch = false,
    bool presence = false,
    PaginationParams? messagesPagination,
    PaginationParams? membersPagination,
    PaginationParams? watchersPagination,
  }) async {
    final request = api.ChannelGetOrCreateRequest(
      data: channelData?.toRequest(),
      state: state,
      watch: watch,
      presence: presence,
      messages: messagesPagination?.toMessagePaginationParams(),
      members: membersPagination?.toPaginationParams(),
      watchers: watchersPagination?.toPaginationParams(),
    );

    final result = switch (channelId) {
      final id? => await _api.getOrCreateChannel(type: channelType, id: id, channelGetOrCreateRequest: request),
      null => await _api.getOrCreateDistinctChannel(type: channelType, channelGetOrCreateRequest: request),
    };
    return result.map((response) => response.toModel());
  }

  /// Fetches the channels that match [filter], ordered by [sort], or those of
  /// the [predefinedFilter].
  Future<Result<QueryChannelsResponse>> queryChannels({
    ChannelFilter? filter,
    List<ChannelSort>? sort,
    String? predefinedFilter,
    Map<String, Object?>? filterValues,
    Map<String, Object?>? sortValues,
    int? memberLimit,
    int? messageLimit,
    bool state = true,
    bool watch = true,
    bool presence = false,
    PaginationParams paginationParams = const PaginationParams(),
  }) async {
    final result = await _api.queryChannels(
      queryChannelsRequest: api.QueryChannelsRequest(
        filterConditions: filter?.toRequest(),
        sort: sort?.map((sort) => sort.toRequest()).toList(),
        predefinedFilter: predefinedFilter,
        filterValues: filterValues,
        sortValues: sortValues,
        memberLimit: memberLimit,
        messageLimit: messageLimit,
        state: state,
        watch: watch,
        presence: presence,
        limit: paginationParams.limit,
        offset: paginationParams.offset,
      ),
    );

    return result.map((response) => response.toModel());
  }

  /// Fetches the members of a channel that match [filter], ordered by [sort].
  ///
  /// Without a [channelId], the channel is the one whose members are
  /// [members].
  Future<Result<QueryMembersResponse>> queryMembers(
    String channelType, {
    MemberFilter? filter,
    String? channelId,
    List<Member>? members,
    List<MemberSort>? sort,
    PaginationParams? pagination,
  }) async {
    final result = await _api.queryMembers(
      payload: api.QueryMembersPayload(
        type: channelType,
        id: channelId,
        members: channelId == null ? members?.map((member) => member.toRequest()).toList() : null,
        filterConditions: filter?.toRequest() ?? const {},
        sort: sort?.map((sort) => sort.toRequest()).toList(),
        limit: pagination?.limit,
        offset: pagination?.offset,
        createdAtAfter: pagination?.createdAtAfter,
        createdAtAfterOrEqual: pagination?.createdAtAfterOrEqual,
        createdAtBefore: pagination?.createdAtBefore,
        createdAtBeforeOrEqual: pagination?.createdAtBeforeOrEqual,
      ),
    );

    return result.map((response) => response.toModel());
  }

  /// Partially updates a channel.
  ///
  /// Sets the fields in [set] and removes the custom fields named in [unset],
  /// leaving every other field as it is.
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

  /// Partially updates the current user's membership of a channel.
  ///
  /// Sets the fields in [set] and removes the fields named in [unset], leaving
  /// every other field as it is.
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

  /// Hides a channel for the current user.
  ///
  /// It stays out of the current user's channel list until a new message is
  /// added to it.
  ///
  /// Hiding also marks it read for the current user.
  ///
  /// If [clearHistory] is true, the channel's messages are also cleared
  /// for the current user.
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
  /// With [threadId], the id of a thread's parent message, marks that thread as
  /// read. Otherwise marks the channel's messages as read up to and including
  /// the one with [messageId], or all of them when [messageId] is null.
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
  /// Takes exactly one of [messageId], [messageTimestamp] and [threadId]. With
  /// [messageId], marks that message and every later one as unread. With
  /// [messageTimestamp], marks every message created after it as unread. With
  /// [threadId], the id of a thread's parent message, marks that thread as
  /// unread.
  Future<Result<void>> markUnread(
    String channelId,
    String channelType, {
    String? messageId,
    DateTime? messageTimestamp,
    String? threadId,
  }) async {
    assert(
      [messageId, messageTimestamp, threadId].nonNulls.length == 1,
      'Exactly one of messageId, messageTimestamp and threadId must be provided.',
    );

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
  Future<Result<MarkReadResponse>> markAllRead() async {
    final result = await _api.markChannelsRead(markChannelsReadRequest: const api.MarkChannelsReadRequest());

    return result.map((response) => response.toModel());
  }

  /// Sends delivery receipts for the messages in [deliveries].
  Future<Result<MarkDeliveredResponse>> markChannelsDelivered(Iterable<MessageDelivery> deliveries) async {
    final result = await _api.markDelivered(
      markDeliveredRequest: api.MarkDeliveredRequest(
        latestDeliveredMessages: [...deliveries.map((it) => it.toRequest())],
      ),
    );

    return result.map((response) => response.toModel());
  }

  /// Sends an event of the given [type] to the channel's watchers.
  ///
  /// The [type] names the event, such as [EventType.typingStart] or a custom
  /// event's name.
  ///
  /// A [parentId] ties the event to the thread of that message, and the
  /// [custom] data reaches the watchers alongside the event.
  Future<Result<EventResponse>> sendEvent(
    String channelId,
    String channelType, {
    required String type,
    String? parentId,
    Map<String, Object?>? custom,
  }) async {
    final result = await _api.sendEvent(
      type: channelType,
      id: channelId,
      sendEventRequest: api.SendEventRequest(
        event: api.EventRequest(type: type, parentId: parentId, custom: custom),
      ),
    );

    return result.map((response) => response.toModel());
  }
}
