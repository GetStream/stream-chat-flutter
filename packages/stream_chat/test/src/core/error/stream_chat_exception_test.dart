import 'package:stream_chat/src/core/error/error.dart';
import 'package:stream_core/stream_core.dart'
    show
        StreamApiError,
        StreamApiException,
        StreamAuthenticationException,
        StreamClientException,
        StreamErrorCode,
        StreamNetworkException;
import 'package:test/test.dart';

void main() {
  group('StreamChatException', () {
    test('aliases every kind of Stream failure', () {
      const failures = <StreamChatException>[
        StreamApiException(message: 'refused', statusCode: 400),
        StreamNetworkException(message: 'offline'),
        StreamAuthenticationException(message: 'no token'),
        StreamClientException(message: 'our bug'),
      ];

      expect(failures, hasLength(4));
    });
  });

  group('isRetriable', () {
    test('honours the server declaring the failure unrecoverable', () {
      const error = StreamApiException(
        message: 'permission denied',
        statusCode: 500,
        unrecoverable: true,
      );

      // Outranks the 5xx status, which on its own would retry.
      expect(error.isRetriable, isFalse);
    });

    test('retries a rate limit', () {
      const error = StreamApiException(
        message: 'too many requests',
        statusCode: 429,
        code: StreamErrorCode.rateLimited,
      );

      expect(error.isRetriable, isTrue);
    });

    test('retries a token that is not valid yet, since clock skew heals', () {
      const notYetValid = StreamApiException(
        message: 'not valid yet',
        statusCode: 401,
        code: StreamErrorCode.tokenNotValidYet,
      );
      const usedBeforeIssued = StreamApiException(
        message: 'used before issued at',
        statusCode: 401,
        code: StreamErrorCode.tokenUsedBeforeIssuedAt,
      );

      expect(notYetValid.isRetriable, isTrue);
      expect(usedBeforeIssued.isRetriable, isTrue);
    });

    test('does not retry an expired token, which a refresh already failed to fix', () {
      const error = StreamApiException(
        message: 'token expired',
        statusCode: 401,
        code: StreamErrorCode.tokenExpired,
      );

      expect(error.isRetriable, isFalse);
    });

    test('retries a server that failed to answer', () {
      const internal = StreamApiException(message: 'internal error', statusCode: 500);
      const badGateway = StreamApiException(message: 'bad gateway', statusCode: 502);

      expect(internal.isRetriable, isTrue);
      expect(badGateway.isRetriable, isTrue);
    });

    test('retries a request that did not complete in time', () {
      const error = StreamApiException(
        message: 'request timeout',
        statusCode: 408,
        code: StreamErrorCode.requestTimeout,
      );

      expect(error.isRetriable, isTrue);
    });

    test('does not retry any other verdict on the request', () {
      const badRequest = StreamApiException(message: 'input error', statusCode: 400);
      const forbidden = StreamApiException(message: 'not allowed', statusCode: 403);
      const notFound = StreamApiException(message: 'not found', statusCode: 404);

      expect(badRequest.isRetriable, isFalse);
      expect(forbidden.isRetriable, isFalse);
      expect(notFound.isRetriable, isFalse);
    });

    test('retries a request that never reached a verdict', () {
      const offline = StreamNetworkException(message: 'no connection');
      const timedOut = StreamNetworkException(message: 'timed out', isTimeout: true);

      expect(offline.isRetriable, isTrue);
      expect(timedOut.isRetriable, isTrue);
    });

    test('does not retry what the caller cancelled', () {
      const error = StreamNetworkException(message: 'cancelled', isCancelled: true);

      expect(error.isRetriable, isFalse);
    });

    test('does not retry broken credentials or an SDK bug', () {
      const auth = StreamAuthenticationException(message: 'no token');
      const client = StreamClientException(message: 'undecodable body');

      expect(auth.isRetriable, isFalse);
      expect(client.isRetriable, isFalse);
    });

    test('reads unrecoverable off the server error payload', () {
      final error = StreamApiException.fromApiError(
        const StreamApiError(
          code: StreamErrorCode.notAllowed,
          details: [],
          duration: '0ms',
          message: 'permission denied',
          moreInfo: '',
          statusCode: 500,
          unrecoverable: true,
        ),
      );

      expect(error.isRetriable, isFalse);
    });
  });
}
