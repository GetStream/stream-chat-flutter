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

    test('fromSql throws ArgumentError for invalid String', () {
      expect(
        () => converter.fromSql('invalid_value'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
