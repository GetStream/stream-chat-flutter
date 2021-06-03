import 'package:stream_chat/src/client/client.dart';
import 'package:stream_chat/src/core/error/error.dart';

/// The retry options
class RetryPolicy {
  /// Instantiate a new RetryPolicy
  RetryPolicy({
    required this.shouldRetry,
    required this.retryTimeout,
    this.maxRetryAttempts = 6,
  });

  /// Hard limit on maximum retry attempts before giving up, defaults to 6
  /// Resets once connection recovers.
  final int maxRetryAttempts;

  /// This function evaluates if we should retry the failure
  final bool Function(
    StreamChatClient client,
    int attempt,
    StreamChatError? error,
  ) shouldRetry;

  /// In the case that we want to retry a failed request the retryTimeout
  /// method is called to determine the timeout
  final Duration Function(
    StreamChatClient client,
    int attempt,
    StreamChatError? error,
  ) retryTimeout;
}
