import 'package:freezed_annotation/freezed_annotation.dart';

import '../poll.dart';

part 'poll_response.freezed.dart';

/// The result of creating, fetching or updating a poll.
@freezed
class PollResponse with _$PollResponse {
  /// Creates a new [PollResponse].
  const PollResponse({
    required this.duration,
    required this.poll,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The poll as it stands after the request.
  @override
  final Poll poll;
}
