import 'package:freezed_annotation/freezed_annotation.dart';

import '../thread.dart';

part 'update_thread_partial_response.freezed.dart';

/// The outcome of partially updating a thread.
@freezed
class UpdateThreadPartialResponse with _$UpdateThreadPartialResponse {
  /// Creates a new [UpdateThreadPartialResponse].
  const UpdateThreadPartialResponse({
    required this.duration,
    required this.thread,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The thread after the update.
  ///
  /// Its [Thread.latestReplies] and [Thread.read] are empty and it has no [Thread.draft], so merging it into a loaded
  /// thread with [Thread.merge] clears them.
  @override
  final Thread thread;
}
