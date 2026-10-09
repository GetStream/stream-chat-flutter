import 'package:freezed_annotation/freezed_annotation.dart';

import '../draft.dart';

part 'query_drafts_response.freezed.dart';

/// One page of the current user's drafts matching a query.
@freezed
class QueryDraftsResponse with _$QueryDraftsResponse {
  /// Creates a new [QueryDraftsResponse].
  const QueryDraftsResponse({
    required this.duration,
    required this.drafts,
    this.next,
    this.prev,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The drafts on this page.
  @override
  final List<Draft> drafts;

  /// The cursor for the next page, or null on the last page.
  @override
  final String? next;

  /// The cursor for the previous page, or null on the first page.
  @override
  final String? prev;
}
