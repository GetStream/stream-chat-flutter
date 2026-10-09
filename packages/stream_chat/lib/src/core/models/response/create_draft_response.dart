import 'package:freezed_annotation/freezed_annotation.dart';

import '../draft.dart';

part 'create_draft_response.freezed.dart';

/// The outcome of creating or replacing a draft.
@freezed
class CreateDraftResponse with _$CreateDraftResponse {
  /// Creates a new [CreateDraftResponse].
  const CreateDraftResponse({
    required this.duration,
    required this.draft,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The draft that was saved.
  @override
  final Draft draft;
}
