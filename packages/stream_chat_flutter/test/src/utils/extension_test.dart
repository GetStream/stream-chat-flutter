import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('List<User>.search', () {
    test('should work fine', () {
      final tommaso = User(id: 'tommaso', name: 'Tommaso');
      final thierry = User(id: 'thierry', name: 'Thierry');
      final users = [tommaso, thierry];

      expect(users.search('Tom'), [tommaso]);
      expect(users.search('Thier'), [thierry]);
    });

    test('should search using UpperCased', () {
      final tommaso = User(id: 'tommaso', name: 'Tommaso');
      final thierry = User(id: 'thierry', name: 'Thierry');
      final users = [tommaso, thierry];

      expect(users.search('tom'), [tommaso]);
      expect(users.search('thier'), [thierry]);
    });

    test('should search by .id or .name', () {
      final user1 = User(id: 'searchingThis');
      final user2 = User(id: 'x', name: 'searchingThis');

      expect([user1].search('sear'), [user1]);
      expect([user2].search('sear'), [user2]);
    });

    test('should search transliterated', () {
      final tommaso = User(id: 'tommaso', name: 'Tommaso');
      final thierry = User(id: 'thierry', name: 'Thierry');
      final users = [tommaso, thierry];

      expect(users.search('tóm'), [tommaso]);
      expect(users.search('thíer'), [thierry]);
    });

    test('search and sorted by distance', () {
      final tommaso = User(id: 'tommaso', name: 'Tommaso');
      final tomas = User(id: 'tomas', name: 'Tomas');
      final users = [tommaso, tomas];

      expect(users.search('tom'), [tomas, tommaso]);
    });

    test('should work fine with cyrillic diacritics', () {
      final petyo = User(id: '42', name: 'Петьо');
      final anastasia = User(id: '13', name: 'Анастасiя');
      final dmitriy = User(id: '99', name: 'Дмитрий');
      final users = [petyo, anastasia, dmitriy];

      expect(users.search('petyo'), []);
      expect(users.search('Пе'), [petyo]);
      expect(users.search('Ана'), [anastasia]);
      expect(users.search('Дмитри'), [dmitriy]);
      expect(users.search('Дмитрии'), [dmitriy]);
    });

    test('should work fine with french diacritics', () {
      final user = User(id: 'fra', name: 'françois');

      expect([user].search('françois'), [user]);
      expect([user].search('franc'), [user]);
    });
  });

  group('String.isOnlyEmoji', () {
    test('should return false for empty or > 3 strings', () {
      expect(''.isOnlyEmoji, false);
      expect('aaa📝💜'.isOnlyEmoji, false);
      expect('📝💜📝💜'.isOnlyEmoji, false);
    });

    test('should detect strings made only by emojis', () {
      expect('a📝💜'.isOnlyEmoji, false);
      expect('📝💜📝'.isOnlyEmoji, true);
      expect('🌶'.isOnlyEmoji, true);
      expect('🌶1'.isOnlyEmoji, false);
      expect('👨‍👨👨‍👨'.isOnlyEmoji, true);
      expect('👨‍👨👨‍👨 '.isOnlyEmoji, true);
      expect('👨👨👨👨'.isOnlyEmoji, false);
      expect('⭐⭐⭐'.isOnlyEmoji, true);
      expect('⭕⭕⭐'.isOnlyEmoji, true);
      expect('✅'.isOnlyEmoji, true);
      expect('☺️'.isOnlyEmoji, true);
    });

    test('Korean vowels', () {
      expect('ㅏ'.isOnlyEmoji, false);
      expect('ㅑ'.isOnlyEmoji, false);
      expect('ㅓ'.isOnlyEmoji, false);
      expect('ㅕ'.isOnlyEmoji, false);
      expect('ㅗ'.isOnlyEmoji, false);
      expect('ㅛ'.isOnlyEmoji, false);
      expect('ㅜ'.isOnlyEmoji, false);
      expect('ㅠ'.isOnlyEmoji, false);
      expect('ㅡ'.isOnlyEmoji, false);
      expect('ㅣ'.isOnlyEmoji, false);
    });

    test('Korean consonants', () {
      expect('ㄱ'.isOnlyEmoji, false);
      expect('ㄴ'.isOnlyEmoji, false);
      expect('ㄷ'.isOnlyEmoji, false);
      expect('ㄹ'.isOnlyEmoji, false);
      expect('ㅁ'.isOnlyEmoji, false);
      expect('ㅂ'.isOnlyEmoji, false);
      expect('ㅅ'.isOnlyEmoji, false);
      expect('ㅇ'.isOnlyEmoji, false);
      expect('ㅈ'.isOnlyEmoji, false);
      expect('ㅊ'.isOnlyEmoji, false);
      expect('ㅋ'.isOnlyEmoji, false);
      expect('ㅌ'.isOnlyEmoji, false);
      expect('ㅍ'.isOnlyEmoji, false);
      expect('ㅎ'.isOnlyEmoji, false);
    });

    test('Korean syllables', () {
      expect('가'.isOnlyEmoji, false);
      expect('나'.isOnlyEmoji, false);
      expect('다'.isOnlyEmoji, false);
      expect('라'.isOnlyEmoji, false);
      expect('마'.isOnlyEmoji, false);
      expect('바'.isOnlyEmoji, false);
      expect('사'.isOnlyEmoji, false);
      expect('아'.isOnlyEmoji, false);
      expect('자'.isOnlyEmoji, false);
      expect('차'.isOnlyEmoji, false);
      expect('카'.isOnlyEmoji, false);
      expect('타'.isOnlyEmoji, false);
      expect('파'.isOnlyEmoji, false);
      expect('하'.isOnlyEmoji, false);
    });

    // https://github.com/GetStream/stream-chat-flutter/issues/1502
    test('Issue:#1502', () {
      expect('ㄴ'.isOnlyEmoji, false);
      expect('ㄴㅇ'.isOnlyEmoji, false);
      expect('ㅇㅋ'.isOnlyEmoji, false);
    });

    // https://github.com/GetStream/stream-chat-flutter/issues/1505
    test('Issue:#1505', () {
      expect('ㅎㅎㅎ'.isOnlyEmoji, false);
      expect('ㅎㅎㅎㅎ'.isOnlyEmoji, false);
    });
  });
}
