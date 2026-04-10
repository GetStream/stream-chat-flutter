import 'dart:async';

import 'package:stream_chat/src/client/client.dart';
import 'package:stream_chat/src/core/error/error.dart';

/// The retry policy associated to a client.
///
/// This policy is used to determine if a request should be retried and when.
///
/// also see:
///   - [RetryQueue]
class RetryPolicy {
  /// Instantiate a new RetryPolicy
  RetryPolicy({
    required this.shouldRetry,
    this.maxRetryAttempts = 6,
    this.delayFactor = const Duration(milliseconds: 200),
    this.randomizationFactor = 0.25,
    this.maxDelay = const Duration(seconds: 30),
  });

  /// Delay factor to double after every attempt.
  ///
  /// Defaults to 200 ms, which results in the following delays:
  ///
  ///  1. 400 ms
  ///  2. 800 ms
  ///  3. 1600 ms
  ///  4. 3200 ms
  ///  5. 6400 ms
  ///  6. 12800 ms
  ///
  /// Before application of [randomizationFactor].
  final Duration delayFactor;

  /// Percentage the delay should be randomized, given as fraction between
  /// 0 and 1.
  ///
  /// If [randomizationFactor] is `0.25` (default) this indicates 25 % of the
  /// delay should be increased or decreased by 25 %.
  final double randomizationFactor;

  /// Maximum delay between retries, defaults to 30 seconds.
  final Duration maxDelay;

  /// Maximum number of attempts before giving up, defaults to 6.
  final int maxRetryAttempts;

  /// Function to determine if a retry should be attempted.
  final FutureOr<bool> Function(
    StreamChatClient client,
    int attempt,
    StreamChatError? error,
  )
  shouldRetry;
}
