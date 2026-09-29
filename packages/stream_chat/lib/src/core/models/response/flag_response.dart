import 'package:freezed_annotation/freezed_annotation.dart';

part 'flag_response.freezed.dart';

/// The outcome of flagging a message or a user for moderator review.
@freezed
class FlagResponse with _$FlagResponse {
  /// Creates a new [FlagResponse].
  const FlagResponse({
    required this.duration,
    required this.itemId,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// Identifies the flagged item in the review queue.
  ///
  /// Moderator-facing review actions are addressed to this id rather than to
  /// the message or user that was flagged.
  @override
  final String itemId;
}
