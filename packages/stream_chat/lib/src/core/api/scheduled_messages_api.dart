import 'dart:convert';

import '../../client/scheduled_messages/scheduled_messages_query.dart';
import '../http/stream_http_client.dart';
import '../models/message.dart';
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
  /// message is sent right away and
  /// [ScheduleMessageResponse.scheduledMessage] is null.
  Future<ScheduleMessageResponse> scheduleMessage(
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

    return ScheduleMessageResponse.fromJson(response.data);
  }

  /// Queries the page of scheduled messages that [query] describes.
  Future<QueryScheduledMessagesResponse> queryScheduledMessages(
    ScheduledMessagesQuery query,
  ) async {
    final ScheduledMessagesQuery(:cid, :statuses, :limit, :next) = query;
    final response = await _client.post(
      '/scheduled_messages/query',
      data: jsonEncode({
        'filter': {
          if (cid != null) 'cid': cid,
          if (statuses != null) 'status': statuses,
        },
        if (limit != null) 'limit': limit,
        if (next != null) 'next': next,
      }),
    );

    return QueryScheduledMessagesResponse.fromJson(response.data);
  }

  /// Changes the scheduled message [id].
  ///
  /// Its message is replaced with [message] and its time moved to
  /// [scheduledAt], whichever of them are given.
  Future<UpdateScheduledMessageResponse> updateScheduledMessage(
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

    return UpdateScheduledMessageResponse.fromJson(response.data);
  }

  /// Deletes the scheduled message [id] before it is sent.
  Future<DeleteScheduledMessageResponse> deleteScheduledMessage(String id) async {
    final response = await _client.delete('/scheduled_messages/$id');

    return DeleteScheduledMessageResponse.fromJson(response.data);
  }

  /// Sends the scheduled message [id] right away.
  Future<SendScheduledMessageNowResponse> sendScheduledMessageNow(String id) async {
    final response = await _client.post('/scheduled_messages/$id/send_now');

    return SendScheduledMessageNowResponse.fromJson(response.data);
  }
}
