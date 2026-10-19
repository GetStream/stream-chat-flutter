import 'package:freezed_annotation/freezed_annotation.dart';

import '../draft.dart';

part 'get_draft_response.freezed.dart';

/// The result of fetching the draft of a channel or a thread, returned by
/// [StreamChatClient.getDraft] and [Channel.getDraft].
@freezed
class GetDraftResponse with _$GetDraftResponse {
  /// Creates a new [GetDraftResponse].
  const GetDraftResponse({
    required this.duration,
    required this.draft,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The draft that was fetched.
  @override
  final Draft draft;
}
