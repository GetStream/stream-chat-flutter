import 'dart:convert';

import 'package:stream_chat/src/core/api/requests.dart';
import 'package:stream_chat/src/core/api/responses.dart';
import 'package:stream_chat/src/core/api/sort_order.dart';
import 'package:stream_chat/src/core/http/stream_http_client.dart';
import 'package:stream_chat/src/core/models/filter.dart';
import 'package:stream_chat/src/core/models/message_reminder.dart';

/// Defines the api dedicated to message reminders operations
class RemindersApi {
  /// Initialize a new reminders api
  const RemindersApi(this._client);

  final StreamHttpClient _client;

  /// Retrieves the list of reminders for the current user.
  ///
  /// Optionally, you can filter and sort the reminders using the [filter] and
  /// [sort] parameters respectively. You can also paginate the results using
  /// [pagination].
  ///
  /// Returns a [QueryRemindersResponse] containing the list of reminders.
  Future<QueryRemindersResponse> queryReminders({
    Filter? filter,
    SortOrder<MessageReminder>? sort,
    PaginationParams? pagination,
  }) async {
    final response = await _client.post(
      '/reminders/query',
      data: jsonEncode({
        if (filter != null) 'filter': filter,
        if (sort != null) 'sort': sort,
        if (pagination != null) ...pagination.toJson(),
      }),
    );

    return QueryRemindersResponse.fromJson(response.data);
  }

  /// Creates a new reminder for the specified [messageId].
  ///
  /// You can specify the time to remind using the [remindAt] parameter.
  ///
  /// Returns a [CreateReminderResponse] containing the created reminder.
  Future<CreateReminderResponse> createReminder(
    String messageId, {
    DateTime? remindAt,
  }) async {
    final response = await _client.post(
      '/messages/$messageId/reminders',
      data: jsonEncode({
        if (remindAt != null) 'remind_at': remindAt.toUtc().toIso8601String(),
      }),
    );

    return CreateReminderResponse.fromJson(response.data);
  }

  /// Updates an existing reminder for the specified [messageId].
  ///
  /// You can change the reminder time using the [remindAt] parameter.
  ///
  /// Returns an [UpdateReminderResponse] containing the updated reminder.
  Future<UpdateReminderResponse> updateReminder(
    String messageId, {
    DateTime? remindAt,
  }) async {
    final response = await _client.patch(
      '/messages/$messageId/reminders',
      data: jsonEncode({
        if (remindAt != null) 'remind_at': remindAt.toUtc().toIso8601String(),
      }),
    );

    return UpdateReminderResponse.fromJson(response.data);
  }

  /// Deletes a reminder for the specified [messageId].
  ///
  /// Returns an [EmptyResponse] indicating the deletion was successful.
  Future<EmptyResponse> deleteReminder(
    String messageId,
  ) async {
    final response = await _client.delete(
      '/messages/$messageId/reminders',
    );

    return EmptyResponse.fromJson(response.data);
  }
}
