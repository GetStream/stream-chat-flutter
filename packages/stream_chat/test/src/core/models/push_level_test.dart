import 'package:stream_chat/src/core/models/push_level.dart';
import 'package:test/test.dart';

void main() {
  group('src/models/push_level', () {
    test('constants resolve to expected wire strings', () {
      expect(PushLevel.all, 'all');
      expect(PushLevel.allMentions, 'all_mentions');
      expect(PushLevel.directMentions, 'direct_mentions');
      expect(PushLevel.none, 'none');
    });
  });
}
