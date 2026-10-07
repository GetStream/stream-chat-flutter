import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/converter/voting_visibility_converter.dart';

void main() {
  group('VotingVisibilityConverter', () {
    const converter = VotingVisibilityConverter();

    test('toSql converts VotingVisibility to String', () {
      expect(converter.toSql(VotingVisibility.anonymous), 'anonymous');
      expect(converter.toSql(VotingVisibility.public), 'public');
    });

    test('fromSql converts String to VotingVisibility', () {
      expect(converter.fromSql('anonymous'), VotingVisibility.anonymous);
      expect(converter.fromSql('public'), VotingVisibility.public);
    });

    test('fromSql keeps a visibility the SDK does not name', () {
      expect(converter.fromSql('members_only'), const VotingVisibility('members_only'));
    });
  });
}
