import 'package:stream_chat/src/core/models/pending_operation.dart';
import 'package:test/test.dart';

void main() {
  group('src/models/pending_operation', () {
    PendingOperation build({
      int? id,
      String type = 'reaction.add',
      Map<String, dynamic>? payload,
    }) => PendingOperation(
      id: id,
      type: type,
      targetMessageId: 'm1',
      payload: payload ?? const {'reaction': 'like'},
    );

    test('equality ignores the autoincrement id', () {
      // A stored operation (with an id) equals its pre-store form so equality
      // compares by content, not database identity.
      expect(build(id: 42), build());
    });

    test('operations with different types are not equal', () {
      expect(build(type: 'reaction.add'), isNot(build(type: 'reaction.delete')));
    });

    test('operations with different payloads are not equal', () {
      expect(build(payload: const {'a': 1}), isNot(build(payload: const {'a': 2})));
    });
  });
}
