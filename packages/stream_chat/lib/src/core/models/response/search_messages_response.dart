import 'package:freezed_annotation/freezed_annotation.dart';

import '../search_message_result.dart';

part 'search_messages_response.freezed.dart';

/// One page of the messages matching a search.
///
/// See also:
///
///  * [StreamChatClient.search] and [Channel.search], which return it.
@freezed
class SearchMessagesResponse with _$SearchMessagesResponse {
  /// Creates a new [SearchMessagesResponse].
  const SearchMessagesResponse({
    required this.duration,
    required this.results,
    this.next,
    this.previous,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The matching messages on this page, each with its channel when it is
  /// known.
  @override
  final List<SearchMessageResult> results;

  /// The cursor for the next page, or null on the last page.
  @override
  final String? next;

  /// The cursor for the previous page, or null on the first page.
  @override
  final String? previous;
}
