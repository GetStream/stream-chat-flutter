import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/api/responses.dart';
import '../../core/models/scheduled_message.dart';

/// A query for a page of the current user's scheduled messages.
///
/// The page lists the scheduled and sending ones first, then the failed ones,
/// each by [ScheduledMessage.scheduledAt].
///
/// ```dart
/// final query = ScheduledMessagesQuery(
///   cid: 'messaging:general',
///   statuses: [ScheduledMessageStatus.failed],
///   limit: 25,
/// );
///
/// final page = await client.queryScheduledMessages(query: query);
/// final nextPage = await client.queryScheduledMessages(
///   query: query.copyWith(next: page.next),
/// );
/// ```
@immutable
final class ScheduledMessagesQuery extends Equatable {
  /// Creates a query for a page of the current user's scheduled messages.
  const ScheduledMessagesQuery({
    this.cid,
    this.statuses,
    this.limit,
    this.next,
  });

  /// The channel whose scheduled messages are listed, or null for every
  /// channel.
  final String? cid;

  /// The statuses the listed ones have, or null for any status.
  ///
  /// A status is one of [ScheduledMessageStatus.scheduled],
  /// [ScheduledMessageStatus.sending] and [ScheduledMessageStatus.failed].
  final List<ScheduledMessageStatus>? statuses;

  /// The number of scheduled messages in the page, from 1 to 100.
  final int? limit;

  /// The cursor of the page to get, taken from
  /// [QueryScheduledMessagesResponse.next] of the previous page.
  ///
  /// Null gets the first page.
  final String? next;

  /// Returns a copy with the given fields replaced.
  ScheduledMessagesQuery copyWith({
    String? cid,
    List<ScheduledMessageStatus>? statuses,
    int? limit,
    String? next,
  }) {
    return ScheduledMessagesQuery(
      cid: cid ?? this.cid,
      statuses: statuses ?? this.statuses,
      limit: limit ?? this.limit,
      next: next ?? this.next,
    );
  }

  @override
  List<Object?> get props => [cid, statuses, limit, next];
}
