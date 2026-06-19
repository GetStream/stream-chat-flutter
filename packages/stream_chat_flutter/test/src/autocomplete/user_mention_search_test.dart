import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/autocomplete/user_mention_search.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('searchUsersForMention', () {
    test('empty query returns all users sorted alphabetically by name', () {
      final charlie = User(id: '3', name: 'Charlie');
      final alice = User(id: '1', name: 'Alice');
      final bob = User(id: '2', name: 'Bob');

      expect(
        searchUsersForMention([charlie, alice, bob], ''),
        [alice, bob, charlie],
      );
    });

    test('single-word query matches by prefix on a name word', () {
      final tommaso = User(id: 'tommaso', name: 'Tommaso');
      final thierry = User(id: 'thierry', name: 'Thierry');

      expect(searchUsersForMention([tommaso, thierry], 'Tom'), [tommaso]);
      expect(searchUsersForMention([tommaso, thierry], 'Thier'), [thierry]);
    });

    test('query matching is case-insensitive', () {
      final tommaso = User(id: 'tommaso', name: 'Tommaso');

      expect(searchUsersForMention([tommaso], 'TOM'), [tommaso]);
      expect(searchUsersForMention([tommaso], 'toM'), [tommaso]);
    });

    test('multi-word query requires full match on non-final words', () {
      final johnDoe = User(id: '1', name: 'John Doe');
      final johnDonovan = User(id: '2', name: 'John Donovan');
      final johnSmith = User(id: '3', name: 'John Smith');
      final users = [johnDoe, johnDonovan, johnSmith];

      expect(searchUsersForMention(users, 'john do'), [johnDoe, johnDonovan]);
      expect(searchUsersForMention(users, 'john doe'), [johnDoe]);
    });

    test('falls back to id when name is blank', () {
      final user = User(id: 'alice');

      expect(searchUsersForMention([user], 'al'), [user]);
    });

    test('query is diacritic-insensitive', () {
      final francois = User(id: 'fra', name: 'françois');

      expect(searchUsersForMention([francois], 'francois'), [francois]);
      expect(searchUsersForMention([francois], 'franc'), [francois]);
    });

    test('user name is diacritic-insensitive', () {
      final jose = User(id: 'jose', name: 'José');

      expect(searchUsersForMention([jose], 'jose'), [jose]);
    });

    test('results are sorted alphabetically by normalized name', () {
      final charlie = User(id: '3', name: 'Charlie');
      final alice = User(id: '1', name: 'Alice');
      final bob = User(id: '2', name: 'Bob');

      expect(searchUsersForMention([charlie, alice, bob], 'c'), [charlie]);
      expect(searchUsersForMention([charlie, alice, bob], 'a'), [alice]);
      // All three names start with a letter; querying a common token-start
      // returns them ordered alphabetically.
      final teamAlice = User(id: 't1', name: 'team alice');
      final teamBob = User(id: 't2', name: 'team bob');
      final teamCharlie = User(id: 't3', name: 'team charlie');
      expect(
        searchUsersForMention([teamCharlie, teamAlice, teamBob], 'team'),
        [teamAlice, teamBob, teamCharlie],
      );
    });

    test('non-matching query returns empty list', () {
      final tommaso = User(id: 'tommaso', name: 'Tommaso');

      expect(searchUsersForMention([tommaso], 'xyz'), isEmpty);
    });

    test('works with cyrillic names', () {
      final petyo = User(id: '42', name: 'Петьо');
      final anastasia = User(id: '13', name: 'Анастасiя');
      final dmitriy = User(id: '99', name: 'Дмитрий');
      final users = [petyo, anastasia, dmitriy];

      expect(searchUsersForMention(users, 'Пе'), [petyo]);
      expect(searchUsersForMention(users, 'Ана'), [anastasia]);
      expect(searchUsersForMention(users, 'Дмитри'), [dmitriy]);
      // No transliteration support; Latin queries against Cyrillic names
      // do not match.
      expect(searchUsersForMention(users, 'petyo'), isEmpty);
    });
  });
}
