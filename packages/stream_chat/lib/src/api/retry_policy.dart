import 'package:meta/meta.dart';
import 'package:stream_chat/src/client.dart';
import 'package:stream_chat/src/exceptions.dart';

/// The retry options
class RetryPolicy {
  /// Instantiate a new RetryPolicy
  RetryPolicy({
    required this.shouldRetry,
    required this.retryTimeout,
    this.attempt = 0,
  });

  /// The number of attempts tried so far
  int attempt = 0;

  /// This function evaluates if we should retry the failure
  final bool Function(StreamChatClient client, int attempt, ApiError? apiError)
      shouldRetry;

  /// In the case that we want to retry a failed request the retryTimeout
  /// method is called to determine the timeout
  final Duration Function(
      StreamChatClient client, int attempt, ApiError? apiError) retryTimeout;

  /// Creates a copy of [RetryPolicy] with specified attributes overridden.
  RetryPolicy copyWith({
    bool Function(StreamChatClient client, int attempt, ApiError? apiError)?
        shouldRetry,
    Duration Function(StreamChatClient client, int attempt, ApiError? apiError)?
        retryTimeout,
    int? attempt,
  }) =>
      RetryPolicy(
        retryTimeout: retryTimeout ?? this.retryTimeout,
        shouldRetry: shouldRetry ?? this.shouldRetry,
        attempt: attempt ?? this.attempt,
      );
}
