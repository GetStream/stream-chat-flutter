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
  void mockApi<T>(
    Future<T> Function(StreamChatApi api) apiCall, {
    required T result,
  }) {
    return when(() => apiCall(chatApi)).thenAnswer((_) async => result);
  }

  /// Mocks an API call to fail with the given [error].
  ///
  /// The returned future completes with the error — matching the real API
  /// layer, which always fails asynchronously. Defaults to a
  /// [StreamChatNetworkError] with [ChatErrorCode.internalSystemError].
  void mockApiFailure<T>(
    Future<T> Function(StreamChatApi api) apiCall, {
    Object? error,
  }) {
    final failure = error ?? StreamChatNetworkError(ChatErrorCode.internalSystemError);
    return when(() => apiCall(chatApi)).thenAnswer((_) => Future.error(failure));
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
}
