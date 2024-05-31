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

  group('Message List Extension Tests', () {
    group('lastUnreadMessage', () {
      test('should return null when list is empty', () {
        final messages = <Message>[];
        final userRead = Read(
          lastRead: DateTime.now(),
          user: User(id: 'user1'),
        );
        expect(messages.lastUnreadMessage(userRead), isNull);
      });

      test('should return null when userRead is null', () {
        final messages = <Message>[
          Message(id: '1'),
          Message(id: '2'),
        ];
        expect(messages.lastUnreadMessage(null), isNull);
      });

      test('should return null when all messages are read', () {
        final lastRead = DateTime.now();
        final messages = <Message>[
          Message(
              id: '1',
              createdAt: lastRead.subtract(const Duration(seconds: 1))),
          Message(id: '2', createdAt: lastRead),
        ];
        final userRead = Read(
          lastRead: lastRead,
          user: User(id: 'user1'),
        );
        expect(messages.lastUnreadMessage(userRead), isNull);
      });

      test('should return null when all messages are mine', () {
        final lastRead = DateTime.now();
        final userRead = Read(
          lastRead: lastRead,
          user: User(id: 'user1'),
        );
        final messages = <Message>[
          Message(
              id: '1',
              user: userRead.user,
              createdAt: lastRead.add(const Duration(seconds: 1))),
          Message(id: '2', user: userRead.user, createdAt: lastRead),
        ];
        expect(messages.lastUnreadMessage(userRead), isNull);
      });

      test('should return the message', () {
        final lastRead = DateTime.now();
        final otherUser = User(id: 'user2');
        final userRead = Read(
          lastRead: lastRead,
          user: User(id: 'user1'),
        );

        final messages = <Message>[
          Message(
            id: '1',
            user: otherUser,
            createdAt: lastRead.add(const Duration(seconds: 2)),
          ),
          Message(
            id: '2',
            user: otherUser,
            createdAt: lastRead.add(const Duration(seconds: 1)),
          ),
          Message(
            id: '3',
            user: otherUser,
            createdAt: lastRead.subtract(const Duration(seconds: 1)),
          ),
        ];

        final lastUnreadMessage = messages.lastUnreadMessage(userRead);
        expect(lastUnreadMessage, isNotNull);
        expect(lastUnreadMessage!.id, '2');
      });

      test('should not return the last message read', () {
        final lastRead = DateTime.timestamp();
        final otherUser = User(id: 'user2');
        final userRead = Read(
          lastRead: lastRead,
          user: User(id: 'user1'),
          lastReadMessageId: '3',
        );

        final messages = <Message>[
          Message(
            id: '1',
            user: otherUser,
            createdAt: lastRead.add(const Duration(seconds: 2)),
          ),
          Message(
            id: '2',
            user: otherUser,
            createdAt: lastRead.add(const Duration(milliseconds: 1)),
          ),
          Message(
            id: '3',
            user: otherUser,
            createdAt: lastRead.add(const Duration(microseconds: 1)),
          ),
          Message(
            id: '4',
            user: otherUser,
            createdAt: lastRead.subtract(const Duration(seconds: 1)),
          ),
        ];

        final lastUnreadMessage = messages.lastUnreadMessage(userRead);
        expect(lastUnreadMessage, isNotNull);
        expect(lastUnreadMessage!.id, '2');
      });
    });
  });
}
