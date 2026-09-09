import 'package:meta/meta.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';

import 'mocks.dart';

/// Mixin providing convenient API mocking and verification methods.
///
/// The callback in every method receives the chat API and should invoke the
/// call being stubbed or verified on one of its sub-APIs, passing the **exact**
/// arguments the production code is expected to send. Because a mocktail stub
/// only answers on an argument match, stubbing this way doubles as request
/// verification — prefer exact values over `any()` matchers.
///
/// Chat sub-APIs return plain futures and **throw** [StreamChatNetworkError]
/// on failure, so [mockApiFailure] configures the call to throw.
///
/// Note: an optional named argument *omitted* in the callback is filled with
/// the sub-API's declared default, so the stub only matches a production call
/// passing that same default. When the SDK passes a non-default value (e.g.
/// `channelData: {}`), the stub must pass it too.
///
/// Example:
/// ```dart
/// tester.mockApi(
///   (api) => api.message.sendMessage(message, channelId, channelType),
///   result: createDefaultSendMessageResponse(message: message),
/// );
///
/// tester.verifyApi(
///   (api) => api.message.sendMessage(message, channelId, channelType),
/// );
/// ```
mixin ApiMockerMixin {
  /// The fake chat API whose sub-APIs are mocks.
  @protected
  FakeChatApi get chatApi;

  /// Mocks an API call to return the given [result].
  ///
  /// Example:
  /// ```dart
  /// tester.mockApi(
  ///   (api) => api.general.getAppSettings(),
  ///   result: createDefaultGetAppSettingsResponse(),
  /// );
  /// ```
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
  ///
  /// Example:
  /// ```dart
  /// tester.mockApiFailure(
  ///   (api) => api.message.sendMessage(message, channelId, channelType),
  ///   error: StreamChatNetworkError(ChatErrorCode.internalSystemError),
  /// );
  /// ```
  void mockApiFailure<T>(
    Future<T> Function(StreamChatApi api) apiCall, {
    Object? error,
  }) {
    final failure = error ?? StreamChatNetworkError(ChatErrorCode.internalSystemError);
    return when(() => apiCall(chatApi)).thenAnswer((_) => Future.error(failure));
  }

  /// Verifies that an API call was made exactly once.
  ///
  /// Example:
  /// ```dart
  /// tester.verifyApi(
  ///   (api) => api.message.sendMessage(message, channelId, channelType),
  /// );
  /// ```
  void verifyApi<T>(Future<T> Function(StreamChatApi api) apiCall) {
    return verifyApiCalled(apiCall, times: 1);
  }

  /// Verifies that an API call was made exactly [times] times.
  ///
  /// Example:
  /// ```dart
  /// tester.verifyApiCalled(
  ///   (api) => api.channel.queryChannels(payload: payload),
  ///   times: 2,
  /// );
  /// ```
  void verifyApiCalled<T>(
    Future<T> Function(StreamChatApi api) apiCall, {
    required int times,
  }) {
    verify(() => apiCall(chatApi)).called(times);
  }

  /// Captures the arguments of an API call for detailed assertions.
  ///
  /// Use `captureAny()` / `captureAny(named: ...)` matchers in the callback
  /// for the arguments to capture.
  ///
  /// Example:
  /// ```dart
  /// final captured = tester.captureApi(
  ///   (api) => api.channel.queryChannels(payload: captureAny(named: 'payload')),
  /// );
  /// final payload = captured.single! as QueryChannelsRequest;
  /// ```
  List<Object?> captureApi<T>(Future<T> Function(StreamChatApi api) apiCall) {
    return verify(() => apiCall(chatApi)).captured;
  }

  /// Verifies that an API call was never made.
  ///
  /// Example:
  /// ```dart
  /// tester.verifyNeverCalled(
  ///   (api) => api.message.deleteMessage(messageId),
  /// );
  /// ```
  VerificationResult verifyNeverCalled<T>(Future<T> Function(StreamChatApi api) apiCall) {
    return verifyNever(() => apiCall(chatApi));
  }
}
