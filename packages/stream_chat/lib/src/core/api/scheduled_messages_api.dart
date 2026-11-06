import 'dart:convert';

import '../http/stream_http_client.dart';
import '../models/message.dart';
import '../models/scheduled_message.dart';
import 'requests.dart';
import 'responses.dart';

/// The API for scheduled message requests.
class ScheduledMessagesApi {
  /// Creates a scheduled messages API.
  const ScheduledMessagesApi(this._client);

  final StreamHttpClient _client;

  /// Schedules [message] to be sent at [scheduledAt].
  ///
  /// The message goes to the channel [channelId] of [channelType].
  ///
  /// If [scheduledAt] has passed by the time the message is scheduled, the
  /// message is sent right away and [SendMessageResponse.scheduledMessage] is
  /// null.
  Future<SendMessageResponse> scheduleMessage(
    String channelId,
    String channelType,
    Message message,
    DateTime scheduledAt, {
    bool skipPush = false,
    bool skipEnrichUrl = false,
  }) async {
    final response = await _client.post(
      '/channels/$channelType/$channelId/message',
      data: {
        'message': message,
        'skip_push': skipPush,
        'skip_enrich_url': skipEnrichUrl,
        'scheduled_at': scheduledAt.toUtc().toIso8601String(),
      },
    );

    return SendMessageResponse.fromJson(response.data);
  }

  /// Queries a page of the current user's scheduled messages.
  ///
  /// The page lists the scheduled and sending ones first, then the failed ones,
  /// each by [ScheduledMessage.scheduledAt].
  ///
  /// If [cid] is given, the page lists only the ones in that channel. If
  /// [statuses] is given, it lists only the ones with one of those statuses.
  ///
  /// The [pagination] sets the page size, and its `next` cursor from a previous
  /// page gets the page after it.
  Future<QueryScheduledMessagesResponse> queryScheduledMessages({
    String? cid,
    List<ScheduledMessageStatus>? statuses,
    PaginationParams? pagination,
  }) async {
    final response = await _client.post(
      '/scheduled_messages/query',
      data: jsonEncode({
        'filter': {
          if (cid != null) 'cid': cid,
          if (statuses != null) 'status': statuses,
        },
        if (pagination != null) ...pagination.toJson(),
      }),
    );

    return QueryScheduledMessagesResponse.fromJson(response.data);
  }

  /// Changes the scheduled message [id].
  ///
  /// Its message is replaced with [message] and its time moved to
  /// [scheduledAt], whichever of them are given.
  Future<ScheduledMessageResponse> updateScheduledMessage(
    String id, {
    Message? message,
    DateTime? scheduledAt,
  }) async {
    final response = await _client.patch(
      '/scheduled_messages/$id',
      data: jsonEncode({
        if (message != null) 'message': message,
        if (scheduledAt != null) 'scheduled_at': scheduledAt.toUtc().toIso8601String(),
      }),
    );

    return ScheduledMessageResponse.fromJson(response.data);
  }

  /// Deletes the scheduled message [id] before it is sent.
  Future<ScheduledMessageResponse> deleteScheduledMessage(String id) async {
    final response = await _client.delete('/scheduled_messages/$id');

    return ScheduledMessageResponse.fromJson(response.data);
  }

  /// Sends the scheduled message [id] right away.
  Future<ScheduledMessageResponse> sendScheduledMessageNow(String id) async {
    final response = await _client.post('/scheduled_messages/$id/send_now');

    return ScheduledMessageResponse.fromJson(response.data);
  }
}
