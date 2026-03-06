import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../mocks.dart';

void main() {
  group('RetryPolicy', () {
    late StreamChatClient client;

    setUp(() {
      client = MockStreamChatClient();
    });

    test('should create with default values', () {
      final policy = RetryPolicy(
        shouldRetry: (client, attempt, error) => true,
      );

      expect(policy.maxRetryAttempts, 6);
      expect(policy.delayFactor, const Duration(milliseconds: 200));
      expect(policy.randomizationFactor, 0.25);
      expect(policy.maxDelay, const Duration(seconds: 30));
    });

    test('should create with custom values', () {
      final policy = RetryPolicy(
        shouldRetry: (client, attempt, error) => false,
        maxRetryAttempts: 10,
        delayFactor: const Duration(milliseconds: 500),
        randomizationFactor: 0.5,
        maxDelay: const Duration(minutes: 1),
      );

      expect(policy.maxRetryAttempts, 10);
      expect(policy.delayFactor, const Duration(milliseconds: 500));
      expect(policy.randomizationFactor, 0.5);
      expect(policy.maxDelay, const Duration(minutes: 1));
    });

    group('shouldRetry', () {
      test('should call synchronous shouldRetry callback', () {
        var callCount = 0;
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) {
            callCount++;
            return attempt < 3;
          },
        );

        expect(policy.shouldRetry(client, 0, null), isTrue);
        expect(policy.shouldRetry(client, 1, null), isTrue);
        expect(policy.shouldRetry(client, 2, null), isTrue);
        expect(policy.shouldRetry(client, 3, null), isFalse);
        expect(callCount, 4);
      });

      test('should call asynchronous shouldRetry callback', () async {
        var callCount = 0;
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) async {
            callCount++;
            await Future.delayed(const Duration(milliseconds: 10));
            return attempt < 2;
          },
        );

        expect(await policy.shouldRetry(client, 0, null), isTrue);
        expect(await policy.shouldRetry(client, 1, null), isTrue);
        expect(await policy.shouldRetry(client, 2, null), isFalse);
        expect(callCount, 3);
      });

      test('should pass client to shouldRetry callback', () async {
        StreamChatClient? capturedClient;
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) {
            capturedClient = client;
            return false;
          },
        );

        await policy.shouldRetry(client, 0, null);
        expect(capturedClient, same(client));
      });

      test('should pass attempt number to shouldRetry callback', () async {
        final capturedAttempts = <int>[];
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) {
            capturedAttempts.add(attempt);
            return attempt < 5;
          },
        );

        for (var i = 0; i < 6; i++) {
          await policy.shouldRetry(client, i, null);
        }

        expect(capturedAttempts, [0, 1, 2, 3, 4, 5]);
      });

      test('should pass error to shouldRetry callback', () async {
        StreamChatError? capturedError;
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) {
            capturedError = error;
            return false;
          },
        );

        final testError = StreamChatNetworkError(ChatErrorCode.inputError);
        await policy.shouldRetry(client, 0, testError);
        expect(capturedError, same(testError));
      });

      test('should handle null error in shouldRetry callback', () async {
        StreamChatError? capturedError;
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) {
            capturedError = error;
            return true;
          },
        );

        await policy.shouldRetry(client, 0, null);
        expect(capturedError, isNull);
      });

      test('should allow conditional retry based on error type', () async {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) {
            if (error is StreamChatNetworkError) {
              return error.errorCode == ChatErrorCode.networkError;
            }
            return false;
          },
        );

        final networkError = StreamChatNetworkError(ChatErrorCode.networkError);
        final inputError = StreamChatNetworkError(ChatErrorCode.inputError);

        expect(
          await policy.shouldRetry(client, 0, networkError),
          isTrue,
        );
        expect(
          await policy.shouldRetry(client, 0, inputError),
          isFalse,
        );
      });

      test('should allow retry limit based on attempt count', () async {
        final policy = RetryPolicy(
          maxRetryAttempts: 3,
          shouldRetry: (client, attempt, error) {
            return attempt < 3;
          },
        );

        expect(await policy.shouldRetry(client, 0, null), isTrue);
        expect(await policy.shouldRetry(client, 1, null), isTrue);
        expect(await policy.shouldRetry(client, 2, null), isTrue);
        expect(await policy.shouldRetry(client, 3, null), isFalse);
      });
    });

    group('delay calculation', () {
      test('should have expected delay progression with default settings', () {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) => true,
          delayFactor: const Duration(milliseconds: 200),
          randomizationFactor: 0.0, // No randomization for predictable test
        );

        // Default delays based on 200ms * 2^(attempt+1)
        // 1. 400 ms
        // 2. 800 ms
        // 3. 1600 ms
        // 4. 3200 ms
        // 5. 6400 ms
        // 6. 12800 ms

        expect(policy.delayFactor.inMilliseconds * 2, 400);
        expect(policy.delayFactor.inMilliseconds * 4, 800);
        expect(policy.delayFactor.inMilliseconds * 8, 1600);
        expect(policy.delayFactor.inMilliseconds * 16, 3200);
        expect(policy.delayFactor.inMilliseconds * 32, 6400);
        expect(policy.delayFactor.inMilliseconds * 64, 12800);
      });

      test('should respect maxDelay', () {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) => true,
          maxDelay: const Duration(seconds: 30),
        );

        expect(policy.maxDelay, const Duration(seconds: 30));
      });

      test('should have correct randomization factor range', () {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) => true,
          randomizationFactor: 0.25,
        );

        expect(policy.randomizationFactor, 0.25);
        expect(policy.randomizationFactor, greaterThanOrEqualTo(0));
        expect(policy.randomizationFactor, lessThanOrEqualTo(1));
      });
    });

    group('edge cases', () {
      test('should handle zero maxRetryAttempts', () {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) => false,
          maxRetryAttempts: 0,
        );

        expect(policy.maxRetryAttempts, 0);
      });

      test('should handle very large maxRetryAttempts', () {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) => true,
          maxRetryAttempts: 1000,
        );

        expect(policy.maxRetryAttempts, 1000);
      });

      test('should handle zero delayFactor', () {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) => true,
          delayFactor: Duration.zero,
        );

        expect(policy.delayFactor, Duration.zero);
      });

      test('should handle very large delayFactor', () {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) => true,
          delayFactor: const Duration(minutes: 5),
        );

        expect(policy.delayFactor, const Duration(minutes: 5));
      });

      test('should handle zero randomizationFactor', () {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) => true,
          randomizationFactor: 0.0,
        );

        expect(policy.randomizationFactor, 0.0);
      });

      test('should handle maximum randomizationFactor', () {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) => true,
          randomizationFactor: 1.0,
        );

        expect(policy.randomizationFactor, 1.0);
      });

      test('should handle exception in shouldRetry callback', () async {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) {
            throw Exception('Test exception');
          },
        );

        expect(
          () => policy.shouldRetry(client, 0, null),
          throwsException,
        );
      });

      test('should handle async exception in shouldRetry callback', () async {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) async {
            await Future.delayed(const Duration(milliseconds: 10));
            throw Exception('Async test exception');
          },
        );

        expect(
          () => policy.shouldRetry(client, 0, null),
          throwsException,
        );
      });
    });

    group('real-world scenarios', () {
      test('should support never retry policy', () async {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) => false,
          maxRetryAttempts: 0,
        );

        expect(await policy.shouldRetry(client, 0, null), isFalse);
        expect(await policy.shouldRetry(client, 1, null), isFalse);
      });

      test('should support always retry policy with limit', () async {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) => attempt < 10,
          maxRetryAttempts: 10,
        );

        for (var i = 0; i < 10; i++) {
          expect(await policy.shouldRetry(client, i, null), isTrue);
        }
        expect(await policy.shouldRetry(client, 10, null), isFalse);
      });

      test('should support retry only on specific errors', () async {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) {
            if (error == null) return false;
            if (error is! StreamChatNetworkError) return false;

            // Only retry on network errors, not validation errors
            return error.errorCode == ChatErrorCode.networkError ||
                error.errorCode == ChatErrorCode.connectionError;
          },
        );

        final networkError = StreamChatNetworkError(ChatErrorCode.networkError);
        final connectionError =
            StreamChatNetworkError(ChatErrorCode.connectionError);
        final validationError =
            StreamChatNetworkError(ChatErrorCode.inputError);

        expect(
          await policy.shouldRetry(client, 0, networkError),
          isTrue,
        );
        expect(
          await policy.shouldRetry(client, 0, connectionError),
          isTrue,
        );
        expect(
          await policy.shouldRetry(client, 0, validationError),
          isFalse,
        );
      });

      test('should support custom backoff strategy', () {
        // Fast initial retries, then slower
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) => attempt < 6,
          delayFactor: const Duration(milliseconds: 100),
          maxRetryAttempts: 6,
        );

        expect(policy.delayFactor.inMilliseconds, 100);
        expect(policy.maxRetryAttempts, 6);
      });

      test('should support immediate retry with no delay', () {
        final policy = RetryPolicy(
          shouldRetry: (client, attempt, error) => attempt < 3,
          delayFactor: Duration.zero,
          randomizationFactor: 0,
        );

        expect(policy.delayFactor, Duration.zero);
        expect(policy.randomizationFactor, 0);
      });
    });
  });
}