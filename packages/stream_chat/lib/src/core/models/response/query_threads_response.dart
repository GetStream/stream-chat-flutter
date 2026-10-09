import 'package:freezed_annotation/freezed_annotation.dart';

import '../thread.dart';

part 'query_threads_response.freezed.dart';

/// One page of the threads matching a query.
@freezed
class QueryThreadsResponse with _$QueryThreadsResponse {
  /// Creates a new [QueryThreadsResponse].
  const QueryThreadsResponse({
    required this.duration,
    required this.threads,
    this.next,
    this.prev,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The threads on this page.
  @override
  final List<Thread> threads;

  /// The cursor for the next page, or null on the last page.
  @override
  final String? next;

  /// The cursor for the previous page, or null on the first page.
  @override
  final String? prev;
}
