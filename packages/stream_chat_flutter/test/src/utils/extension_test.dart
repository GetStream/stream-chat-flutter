// ignore_for_file: deprecated_member_use_from_same_package

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

  group('Message Extension Tests', () {
    test('replaceMentions should replace user mentions with names and IDs', () {
      final user1 = User(id: 'user1', name: 'Alice');
      final user2 = User(id: 'user2', name: 'Bob');

      final message = Message(
        text: 'Hello, @user1 and @user2!',
        mentionedUsers: [user1, user2],
      );

      final modifiedMessage = message.replaceMentions();

      expect(modifiedMessage.text, contains('[@Alice](user1)'));
      expect(modifiedMessage.text, contains('[@Bob](user2)'));
    });

    test('replaceMentions without linkify should not add links', () {
      final user = User(id: 'user1', name: 'Alice');

      final message = Message(
        text: 'Hello, @user1!',
        mentionedUsers: [user],
      );

      final modifiedMessage = message.replaceMentions(linkify: false);

      expect(modifiedMessage.text, contains('@Alice'));
    });

    test('replaceMentions should handle mentions with usernames', () {
      final user = User(id: 'user1', name: 'Alice');

      final message = Message(
        text: 'Hello, @Alice!',
        mentionedUsers: [user],
      );

      final modifiedMessage = message.replaceMentions();

      expect(modifiedMessage.text, contains('[@Alice](user1)'));
    });

    test(
      '''replaceMentions without linkify should not change mentions with usernames''',
      () {
        final user = User(id: 'user1', name: 'Alice');

        final message = Message(
          text: 'Hello, @Alice!',
          mentionedUsers: [user],
        );

        final modifiedMessage = message.replaceMentions(linkify: false);

        expect(modifiedMessage.text, contains('@Alice'));
      },
    );

    test(
      'replaceMentions should replace mixed user mentions with names and IDs',
      () {
        final user1 = User(id: 'user1', name: 'Alice');
        final user2 = User(id: 'user2', name: 'Bob');

        final message = Message(
          text: 'Hello, @user1 and @Bob!',
          mentionedUsers: [user1, user2],
        );

        final modifiedMessage = message.replaceMentions();

        expect(modifiedMessage.text, contains('[@Alice](user1)'));
        expect(modifiedMessage.text, contains('[@Bob](user2)'));
      },
    );

    group('replaceMentions with special regex characters', () {
      test('should handle usernames with parentheses', () {
        final user = User(id: 'user1', name: 'Tester (X)');

        final message = Message(
          text: 'Hello, @Tester (X)!',
          mentionedUsers: [user],
        );

        final modifiedMessage = message.replaceMentions();

        expect(modifiedMessage.text, equals('Hello, [@Tester (X)](user1)!'));
      });

      test('should handle usernames with square brackets', () {
        final user = User(id: 'user1', name: 'User[123]');

        final message = Message(
          text: 'Hello, @User[123]!',
          mentionedUsers: [user],
        );

        final modifiedMessage = message.replaceMentions();

        expect(modifiedMessage.text, equals('Hello, [@User[123]](user1)!'));
      });

      test('should handle usernames with dots and asterisks', () {
        final user = User(id: 'user1', name: 'user.name*');

        final message = Message(
          text: 'Hello, @user.name*!',
          mentionedUsers: [user],
        );

        final modifiedMessage = message.replaceMentions();

        expect(modifiedMessage.text, equals('Hello, [@user.name*](user1)!'));
      });

      test('should handle usernames with plus and question marks', () {
        final user = User(id: 'user1', name: 'test+user?');

        final message = Message(
          text: 'Hello, @test+user?!',
          mentionedUsers: [user],
        );

        final modifiedMessage = message.replaceMentions();

        expect(modifiedMessage.text, equals('Hello, [@test+user?](user1)!'));
      });

      test('should handle usernames without linkify', () {
        final user = User(id: 'user1', name: 'Tester (X)');

        final message = Message(
          text: 'Hello, @Tester (X)!',
          mentionedUsers: [user],
        );

        final modifiedMessage = message.replaceMentions(linkify: false);

        expect(modifiedMessage.text, equals('Hello, @Tester (X)!'));
      });

      test('should not replace partial matches', () {
        final user = User(id: 'user1', name: 'Test (X)');

        final message = Message(
          text: 'Hello, @Test (X) and @Test (Y)!',
          mentionedUsers: [user],
        );

        final modifiedMessage = message.replaceMentions();

        expect(
          modifiedMessage.text,
          equals('Hello, [@Test (X)](user1) and @Test (Y)!'),
        );
      });

      test('should handle userIds with special characters', () {
        final user = User(id: 'user.id+123', name: 'TestUser');

        final message = Message(
          text: 'Hello, @user.id+123!',
          mentionedUsers: [user],
        );

        final modifiedMessage = message.replaceMentions();

        expect(
          modifiedMessage.text,
          equals('Hello, [@TestUser](user.id+123)!'),
        );
      });

      test('should handle both userId and userName with special characters', () {
        final user = User(id: 'user[123]', name: 'Test (X)');

        final message = Message(
          text: 'Hello, @user[123] and @Test (X)!',
          mentionedUsers: [user],
        );

        final modifiedMessage = message.replaceMentions();

        expect(
          modifiedMessage.text,
          equals('Hello, [@Test (X)](user[123]) and [@Test (X)](user[123])!'),
        );
      });
    });

    test('replaceMentionsWithId should replace user names with IDs', () {
      final user1 = User(id: 'user1', name: 'Alice');
      final user2 = User(id: 'user2', name: 'Bob');

      final message = Message(
        text: 'Hello, @Alice and @Bob!',
        mentionedUsers: [user1, user2],
      );

      final modifiedMessage = message.replaceMentionsWithId();

      expect(modifiedMessage.text, contains('@user1'));
      expect(modifiedMessage.text, contains('@user2'));
      expect(modifiedMessage.text, isNot(contains('@Alice')));
      expect(modifiedMessage.text, isNot(contains('@Bob')));
    });

    test(
      'replaceMentionsWithId should not change message without mentions',
      () {
        final message = Message(
          text: 'Hello, @Alice!',
        );

        final modifiedMessage = message.replaceMentionsWithId();

        expect(modifiedMessage.text, equals('Hello, @Alice!'));
        expect(modifiedMessage.text, isNot(contains('@user1')));
      },
    );

    test('replaceMentionsWithId should handle message with only mention', () {
      final user = User(id: 'user1', name: 'Alice');

      final message = Message(
        text: '@Alice',
        mentionedUsers: [user],
      );

      final modifiedMessage = message.replaceMentionsWithId();

      expect(modifiedMessage.text, contains('@user1'));
      expect(modifiedMessage.text, isNot(contains('@Alice')));
    });
  });
}
