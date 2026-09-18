import 'package:stream_core/stream_core.dart';

/// An alias of [StreamException], so code written against either name catches
/// the same failures.
///
/// Every failure the SDK reports is one of four kinds:
///
/// - [StreamApiException] — the server answered, and the answer was an error.
/// - [StreamNetworkException] — the server was never heard from, so the
///   outcome of the request is unknown.
/// - [StreamAuthenticationException] — credentials could not be produced or
///   sent.
/// - [StreamClientException] — the SDK itself failed.
///
/// The root is sealed, so a `switch` over the four kinds is exhaustive.
typedef StreamChatException = StreamException;

/// Whether a failed operation is worth attempting again.
extension StreamChatExceptionRetries on StreamChatException {
  /// Whether retrying the operation could succeed.
  ///
  /// Answers from the failure alone, which is necessary but not sufficient: a
  /// write is only safe to retry through an idempotent path, because a
  /// [StreamNetworkException] leaves the outcome unknown — the server may have
  /// performed the operation before the connection failed. Sending a message
  /// is idempotent here, since the id is client-generated.
  ///
  /// A `true` says nothing about *when*. Honour
  /// [StreamApiException.retryAfter] where the server named a wait, and back
  /// off otherwise.
  bool get isRetriable => switch (this) {
    // The server said retrying will not help, and it is authoritative.
    StreamApiException(unrecoverable: true) => false,

    // About the moment rather than the request: the wait heals it.
    StreamApiException(isRateLimited: true) => true,

    // Clock skew on the token's `nbf`/`iat` claims heals on its own, and a
    // fresh token minted by the same skewed clock would not help.
    StreamApiException(isTokenNotYetValid: true) => true,

    // A refused token that reached here is one a refresh already failed to
    // fix, so resending cannot help either.
    StreamApiException(isTokenExpired: true) => false,

    // 5xx is the server failing to answer rather than a verdict on the
    // request, and 408 says the request did not complete in time. Every other
    // 4xx is a verdict: the same request earns the same answer.
    StreamApiException(:final statusCode) => statusCode >= 500 || statusCode == 408,

    // The caller stopped it, so there is nothing to retry.
    StreamNetworkException(isCancelled: true) => false,

    // The request never reached a verdict. Prefer a connectivity signal over
    // blind backoff where one is available.
    StreamNetworkException() => true,

    // Credentials have to be fixed before the operation is worth attempting.
    StreamAuthenticationException() => false,

    // A bug does not heal on resend.
    StreamClientException() => false,
  };
}
