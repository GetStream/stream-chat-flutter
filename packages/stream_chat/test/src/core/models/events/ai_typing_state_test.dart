import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

void main() {
  test('AITypingState reports checkingSources as checking sources', () {
    expect(const AITypingState('AI_STATE_CHECKING_SOURCES').isCheckingSources, isTrue);
  });

  test('AITypingState reports checkingExternalSources as checking sources', () {
    expect(const AITypingState('AI_STATE_EXTERNAL_SOURCES').isCheckingSources, isTrue);
  });

  test('AITypingState does not report another state as checking sources', () {
    expect(AITypingState.thinking.isCheckingSources, isFalse);
  });
}
