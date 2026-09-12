import 'package:stream_chat/src/client/client.dart';
import 'package:stream_chat/version.dart';
import 'package:stream_core/stream_core.dart' show CurrentPlatform;
import 'package:test/test.dart';

void main() {
  // The manager itself is `stream_core`'s and is covered there. What this
  // package owns is the baseline it is constructed with, which is what ends up
  // in the `X-Stream-Client` header on every request.
  test('reports the chat SDK baseline in the default user agent', () {
    expect(
      StreamChatClient.defaultUserAgent,
      'stream-chat-dart-v$PACKAGE_VERSION|os=${CurrentPlatform.operatingSystem}',
    );
  });
}
