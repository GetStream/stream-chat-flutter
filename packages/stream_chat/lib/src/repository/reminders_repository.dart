import 'package:stream_core/stream_core.dart' show PatternMatching, Result;

import '../../open_api/api.dart' as api;
import '../core/models/message_reminder.dart';
import '../core/models/response/create_reminder_response.dart';
import '../core/models/response/delete_reminder_response.dart';
import '../core/models/response/query_reminders_response.dart';
import '../core/models/response/update_reminder_response.dart';
import 'mapper/reminders_mapper.dart';
import 'mapper/sort_mapper.dart';

/// Repository dedicated to message reminder operations.
class RemindersRepository {
  /// Initialize a new reminders repository.
  const RemindersRepository(this._api);

  final api.DefaultApi _api;

  /// Fetches one page of the current user's reminders matching [filter], ordered by [sort].
  ///
  /// [next] and [prev] are the cursors a previous page returned; at most one of them may be given.
  Future<Result<QueryRemindersResponse>> queryReminders({
    MessageReminderFilter? filter,
    List<MessageReminderSort>? sort,
    int? limit,
    String? next,
    String? prev,
  }) async {
    final result = await _api.queryReminders(
      queryRemindersRequest: api.QueryRemindersRequest(
        filter: filter?.toJson(),
        sort: sort?.map((it) => it.toRequest()).toList(),
        limit: limit,
        next: next,
        prev: prev,
      ),
    );

    return result.map((response) => response.toModel());
  }

  /// Creates a reminder on the message with the id [messageId], due at [remindAt], or a bookmark without it.
  Future<Result<CreateReminderResponse>> createReminder(String messageId, {DateTime? remindAt}) async {
    final result = await _api.createReminder(
      messageId: messageId,
      createReminderRequest: api.CreateReminderRequest(remindAt: remindAt),
    );

    return result.map((response) => response.toModel());
  }

  /// Sets the reminder on the message with the id [messageId] to be due at [remindAt], or turns it into a bookmark
  /// without it.
  Future<Result<UpdateReminderResponse>> updateReminder(String messageId, {DateTime? remindAt}) async {
    final result = await _api.updateReminder(
      messageId: messageId,
      updateReminderRequest: api.UpdateReminderRequest(remindAt: remindAt),
    );

    return result.map((response) => response.toModel());
  }

  /// Deletes the reminder on the message with the id [messageId].
  Future<Result<DeleteReminderResponse>> deleteReminder(String messageId) async {
    final result = await _api.deleteReminder(messageId: messageId);

    return result.map((response) => response.toModel());
  }
}
