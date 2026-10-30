import 'dart:convert';

import '../http/stream_http_client.dart';
import '../models/message.dart';
import '../models/scheduled_message.dart';
import 'responses.dart';

/// Defines the api dedicated to scheduled messages operations
class ScheduledMessagesApi {
  /// Initialize a new scheduled messages api
  const ScheduledMessagesApi(this._client);

  final StreamHttpClient _client;

  /// Returns a page of the current user's scheduled messages, scheduled and
  /// sending ones first, then failed ones, each by
  /// [ScheduledMessage.scheduledAt].
  ///
  /// The page holds only messages in the channel [cid] when given, and only
  /// messages with one of [statuses] when given. Pass [next] from a previous
  /// page to get the page after it.
  Future<QueryScheduledMessagesResponse> queryScheduledMessages({
    String? cid,
    List<ScheduledMessageStatus>? statuses,
    int? limit,
    String? next,
  }) async {
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

  /// Replaces the scheduled message [id] with [message], moves it to
  /// [scheduledAt], or both.
  Future<ScheduledMessageResponse> updateScheduledMessage(
    String id, {
    Message? message,
    DateTime? scheduledAt,
  }) async {
    final response = await _client.patch(
      '/scheduled_messages/$id',
      data: jsonEncode({
        if (message != null)
          'message': {
            ...message.toJson(),
            // Every mentioned user is kept, whether or not the text mentions
            // them by name.
            'mentioned_users': [for (final user in message.mentionedUsers) user.id],
          },
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
