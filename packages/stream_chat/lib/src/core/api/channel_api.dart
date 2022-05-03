import 'dart:convert';

import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/channel_state.dart';
import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/models/filter.dart';
import 'package:stream_chat/src/core/models/message.dart';

/// Defines the api dedicated to channel operations
class ChannelApi {
  /// Initialize a new channel api
  ChannelApi(this._client);

  final StreamHttpClient _client;

  String _getChannelUrl(String channelId, String channelType) =>
      '/channels/$channelType/$channelId';

  /// Query the API, get messages, members or other channel fields
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
  }) async {
    var channelPath = '/channels/$channelType';
    if (channelId != null) channelPath = '$channelPath/$channelId';
    final response = await _client.post(
      '$channelPath/query',
      data: {
        'state': state,
        'watch': watch,
        'presence': presence,
        if (channelData != null) 'data': channelData,
        if (messagesPagination != null) 'messages': messagesPagination,
        if (membersPagination != null) 'members': membersPagination,
        if (watchersPagination != null) 'watchers': watchersPagination,
      },
    );
    return ChannelState.fromJson(response.data);
  }

  /// Requests channels with a given query from the API.
  Future<QueryChannelsResponse> queryChannels({
    Filter? filter,
    List<SortOption<ChannelModel>>? sort,
    int? memberLimit,
    int? messageLimit,
    bool state = true,
    bool watch = true,
    bool presence = false,
    PaginationParams paginationParams = const PaginationParams(),
  }) async {
    final response = await _client.get(
      '/channels',
      queryParameters: {
        'payload': jsonEncode({
          // default options
          'state': state,
          'watch': watch,
          'presence': presence,

          // passed options
          if (sort != null) 'sort': sort,
          if (filter != null) 'filter_conditions': filter,
          if (memberLimit != null) 'member_limit': memberLimit,
          if (messageLimit != null) 'message_limit': messageLimit,

          // pagination
          ...paginationParams.toJson(),
        }),
      },
    );
    return QueryChannelsResponse.fromJson(response.data);
  }

  /// Mark all channels for this user as read
  Future<EmptyResponse> markAllRead() async {
    final response = await _client.post(
      '/channels/read',
      data: {},
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Replaces the [channelId] of type [ChannelType] data with [data]
  Future<UpdateChannelResponse> updateChannel(
    String channelId,
    String channelType,
    Map<String, Object?> data, {
    Message? message,
  }) async {
    final response = await _client.post(
      _getChannelUrl(channelId, channelType),
      data: {
        'data': data,
        if (message != null)
          'message': message.copyWith(updatedAt: DateTime.now()),
      },
    );
    return UpdateChannelResponse.fromJson(response.data);
  }

  /// Updates the [channelId] of type [ChannelType] data with [data]
  Future<PartialUpdateChannelResponse> updateChannelPartial(
    String channelId,
    String channelType, {
    Map<String, Object?>? set,
    List<String>? unset,
  }) async {
    final response = await _client.patch(
      _getChannelUrl(channelId, channelType),
      data: {
        if (set != null) 'set': set,
        if (unset != null) 'unset': unset,
      },
    );
    return PartialUpdateChannelResponse.fromJson(response.data);
  }

  /// Enable slowdown
  Future<PartialUpdateChannelResponse> enableSlowdown(
    String channelId,
    String channelType,
    int cooldown,
  ) async {
    final response = await updateChannelPartial(
      channelId,
      channelType,
      set: {
        'cooldown': cooldown,
      },
    );
    return response;
  }

  /// Disable slowdown
  Future<PartialUpdateChannelResponse> disableSlowdown(
    String channelId,
    String channelType,
  ) async {
    final response = await updateChannelPartial(
      channelId,
      channelType,
      unset: ['cooldown'],
    );
    return response;
  }

  /// Accept invitation to the channel
  Future<AcceptInviteResponse> acceptChannelInvite(
    String channelId,
    String channelType, {
    Message? message,
  }) async {
    final response = await _client.post(
      _getChannelUrl(channelId, channelType),
      data: {
        'accept_invite': true,
        'message': message,
      },
    );
    return AcceptInviteResponse.fromJson(response.data);
  }

  /// Reject invitation to the channel
  Future<RejectInviteResponse> rejectChannelInvite(
    String channelId,
    String channelType, {
    Message? message,
  }) async {
    final response = await _client.post(
      _getChannelUrl(channelId, channelType),
      data: {
        'reject_invite': true,
        'message': message,
      },
    );
    return RejectInviteResponse.fromJson(response.data);
  }

  /// Invite members to the channel
  Future<InviteMembersResponse> inviteChannelMembers(
    String channelId,
    String channelType,
    List<String> memberIds, {
    Message? message,
  }) async {
    final response = await _client.post(
      _getChannelUrl(channelId, channelType),
      data: {
        'invites': memberIds,
        'message': message,
      },
    );
    return InviteMembersResponse.fromJson(response.data);
  }

  /// Add members to the channel
  Future<AddMembersResponse> addMembers(
    String channelId,
    String channelType,
    List<String> memberIds, {
    Message? message,
  }) async {
    final response = await _client.post(
      _getChannelUrl(channelId, channelType),
      data: {
        'add_members': memberIds,
        'message': message,
      },
    );
    return AddMembersResponse.fromJson(response.data);
  }

  /// Remove members from the channel
  Future<RemoveMembersResponse> removeMembers(
    String channelId,
    String channelType,
    List<String> memberIds, {
    Message? message,
  }) async {
    final response = await _client.post(
      _getChannelUrl(channelId, channelType),
      data: {
        'remove_members': memberIds,
        'message': message,
      },
    );
    return RemoveMembersResponse.fromJson(response.data);
  }

  /// Send an event on this channel
  Future<EmptyResponse> sendEvent(
    String channelId,
    String channelType,
    Event event,
  ) async {
    final response = await _client.post(
      '${_getChannelUrl(channelId, channelType)}/event',
      data: {'event': event},
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Delete this channel. Messages are permanently removed.
  Future<EmptyResponse> deleteChannel(
    String channelId,
    String channelType,
  ) async {
    final response = await _client.delete(
      _getChannelUrl(channelId, channelType),
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Removes all messages from the channel
  Future<EmptyResponse> truncateChannel(
    String channelId,
    String channelType, {
    Message? message,
    bool? skipPush,
    DateTime? truncatedAt,
  }) async {
    final response = await _client.post(
      '${_getChannelUrl(channelId, channelType)}/truncate',
      data: {
        if (message != null) 'message': message,
        if (skipPush != null) 'skip_push': skipPush,
        if (truncatedAt != null) 'truncated_at': truncatedAt,
      },
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Hides the channel from [StreamChatClient.queryChannels] for the user
  /// until a message is added If [clearHistory] is set to true - all messages
  /// will be removed for the user
  Future<EmptyResponse> hideChannel(
    String channelId,
    String channelType, {
    bool clearHistory = false,
  }) async {
    final response = await _client.post(
      '${_getChannelUrl(channelId, channelType)}/hide',
      data: {'clear_history': clearHistory},
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Removes the hidden status for the channel
  Future<EmptyResponse> showChannel(
    String channelId,
    String channelType,
  ) async {
    final response = await _client.post(
      '${_getChannelUrl(channelId, channelType)}/show',
      data: {},
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Mark [channelId] of type [channelType] all messages as read
  /// Optionally provide a [messageId] if you want to mark a
  /// particular message as read
  Future<EmptyResponse> markRead(
    String channelId,
    String channelType, {
    String? messageId,
  }) async {
    final response = await _client.post(
      '${_getChannelUrl(channelId, channelType)}/read',
      data: {if (messageId != null) 'message_id': messageId},
    );
    return EmptyResponse.fromJson(response.data);
  }

  /// Stop watching the channel
  Future<EmptyResponse> stopWatching(
    String channelId,
    String channelType,
  ) async {
    final response = await _client.post(
      '${_getChannelUrl(channelId, channelType)}/stop-watching',
      data: {},
    );
    return EmptyResponse.fromJson(response.data);
  }
}
