import 'package:freezed_annotation/freezed_annotation.dart';

import '../poll_option.dart';

part 'poll_option_response.freezed.dart';

/// The result of creating, fetching or updating an option of a poll.
@freezed
class PollOptionResponse with _$PollOptionResponse {
  /// Creates a new [PollOptionResponse].
  const PollOptionResponse({
    required this.duration,
    required this.pollOption,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The option as it stands after the request.
  @override
  final PollOption pollOption;
}
