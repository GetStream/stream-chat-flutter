import 'package:freezed_annotation/freezed_annotation.dart';

import '../message_reminder.dart';

part 'query_reminders_response.freezed.dart';

/// One page of the current user's reminders matching a query.
@freezed
class QueryRemindersResponse with _$QueryRemindersResponse {
  /// Creates a new [QueryRemindersResponse].
  const QueryRemindersResponse({
    required this.duration,
    required this.reminders,
    this.next,
    this.prev,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The reminders on this page.
  @override
  final List<MessageReminder> reminders;

  /// The cursor for the next page, or null on the last page.
  @override
  final String? next;

  /// The cursor for the previous page, or null on the first page.
  @override
  final String? prev;
}
