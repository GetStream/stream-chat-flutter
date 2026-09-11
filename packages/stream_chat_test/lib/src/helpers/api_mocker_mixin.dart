import 'package:meta/meta.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';

import 'mocks.dart';

/// Mixin providing API mocking and verification methods.
///
/// The callback in every method invokes the call being stubbed or verified on
/// one of the chat API's sub-APIs, passing the **exact** arguments the
/// production code is expected to send. A mocktail stub only answers on an
/// argument match, so stubbing this way doubles as request verification —
/// prefer exact values over `any()` matchers.
///
/// An optional named argument omitted in the callback is filled with the
/// sub-API's declared default, so the stub only matches a production call
/// passing that same default; when the SDK passes a non-default value (e.g.
/// `channelData: {}`), the callback must pass it too.
///
/// Example:
/// ```dart
/// tester.mockApi(
///   (api) => api.message.getMessage('message-id'),
///   result: createDefaultGetMessageResponse(),
/// );
///
/// tester.verifyApi((api) => api.message.getMessage('message-id'));
/// ```
mixin ApiMockerMixin {
  /// The fake chat API whose sub-APIs are mocks.
  @protected
  FakeChatApi get chatApi;

  /// Mocks an API call to return the given [result].
  ///
  /// When [delay] is provided, the returned future completes only after it
  /// elapses, keeping the request in flight for that duration.
  void mockApi<T>(
    Future<T> Function(StreamChatApi api) apiCall, {
    required T result,
    Duration? delay,
  }) {
    return when(() => apiCall(chatApi)).thenAnswer((_) async {
      if (delay != null) await Future<void>.delayed(delay);
      return result;
    });
  }

  /// Mocks an API call to fail with the given [error].
  ///
  /// The returned future completes with the error — matching the real API
  /// layer, which always fails asynchronously. Defaults to a
  /// [StreamChatNetworkError] with [ChatErrorCode.internalSystemError].
  ///
  /// When [delay] is provided, the returned future fails only after it
  /// elapses, keeping the request in flight for that duration.
  void mockApiFailure<T>(
    Future<T> Function(StreamChatApi api) apiCall, {
    Object? error,
    Duration? delay,
  }) {
    final failure = error ?? StreamChatNetworkError(ChatErrorCode.internalSystemError);
    return when(() => apiCall(chatApi)).thenAnswer((_) {
      if (delay case final delay?) {
        return Future<void>.delayed(delay).then((_) => Future<T>.error(failure));
      }
      return Future<T>.error(failure);
    });
  }

  /// Mocks an API call to fail with the given [error] on the first invocation
  /// and return [result] on every subsequent one.
  ///
  /// Both outcomes complete asynchronously — matching the real API layer.
  /// [error] defaults to a [StreamChatNetworkError] with
  /// [ChatErrorCode.internalSystemError], which carries no response data and
  /// is therefore retriable: the failed first call arms the SDK's retry queue
  /// and the queue's immediate retry attempt succeeds without waiting on
  /// backoff timers.
  void mockApiFailureOnce<T>(
    Future<T> Function(StreamChatApi api) apiCall, {
    Object? error,
    required T result,
  }) {
    final failure = error ?? StreamChatNetworkError(ChatErrorCode.internalSystemError);
    var firstCall = true;
    return when(() => apiCall(chatApi)).thenAnswer((_) {
      if (firstCall) {
        firstCall = false;
        return Future.error(failure);
      }
      return Future.value(result);
    });
  }

  /// Verifies that an API call was made exactly once.
  void verifyApi<T>(Future<T> Function(StreamChatApi api) apiCall) {
    return verifyApiCalled(apiCall, times: 1);
  }

  /// Verifies that an API call was made exactly [times] times.
  void verifyApiCalled<T>(
    Future<T> Function(StreamChatApi api) apiCall, {
    required int times,
  }) {
    verify(() => apiCall(chatApi)).called(times);
  }

  /// Captures the arguments of an API call for detailed assertions.
  ///
  /// The arguments to capture are marked with `captureAny()` /
  /// `captureAny(named: ...)` matchers in the callback:
  ///
  /// ```dart
  /// final captured = tester.captureApi(
  ///   (api) => api.message.getMessage(captureAny()),
  /// );
  /// expect(captured.single, 'message-id');
  /// ```
  List<Object?> captureApi<T>(Future<T> Function(StreamChatApi api) apiCall) {
    return verify(() => apiCall(chatApi)).captured;
  }

  /// Verifies that an API call was never made.
  VerificationResult verifyNeverCalled<T>(Future<T> Function(StreamChatApi api) apiCall) {
    return verifyNever(() => apiCall(chatApi));
  }

  /// Verifies that the sub-API selected by [subApi] received no interactions
  /// beyond the ones already verified.
  ///
  /// ```dart
  /// tester.verifyApi((api) => api.channel.markRead('channel-id', 'type'));
  /// tester.verifyNoMoreApiInteractions((api) => api.channel);
  /// ```
  void verifyNoMoreApiInteractions(Object Function(StreamChatApi api) subApi) {
    return verifyNoMoreInteractions(subApi(chatApi));
  }
}
