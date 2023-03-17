import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('IntExtension.toHumanReadableSize', () {
    test('should convert file size to human readable size', () {
      expect(10000.toHumanReadableSize(), '9.77 KB');
      expect(100000.toHumanReadableSize(), '97.66 KB');
      expect(100000000.toHumanReadableSize(), '95.37 MB');
    });
  });

  group('DurationExtension.toMinutesAndSeconds', () {
    test('should convert Duration to readable time', () {
      expect(const Duration(seconds: 50).toMinutesAndSeconds(), '00:50');
      expect(const Duration(seconds: 100).toMinutesAndSeconds(), '01:40');
      expect(const Duration(seconds: 200).toMinutesAndSeconds(), '03:20');
      expect(const Duration(minutes: 45).toMinutesAndSeconds(), '45:00');
    });
  });

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
    });
  });
}
