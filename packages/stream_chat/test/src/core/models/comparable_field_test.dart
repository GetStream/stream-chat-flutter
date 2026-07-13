import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:test/test.dart';

void main() {
  group('ComparableField', () {
    group('fromValue', () {
      test('should create a comparable field from a non-null value', () {
        final field = ComparableField.fromValue('test');
        expect(field, isNotNull);
      });

      test('should return null when value is null', () {
        final field = ComparableField.fromValue(null);
        expect(field, isNull);
      });
    });

    group('compare numbers', () {
      test('should compare integers correctly', () {
        final a = ComparableField.fromValue(10);
        final b = ComparableField.fromValue(5);

        expect(a!.compareTo(b!), greaterThan(0));
        expect(b.compareTo(a), lessThan(0));
        expect(a.compareTo(ComparableField.fromValue(10)!), equals(0));
      });

      test('should compare doubles correctly', () {
        final a = ComparableField.fromValue(10.5);
        final b = ComparableField.fromValue(10.2);

        expect(a!.compareTo(b!), greaterThan(0));
        expect(b.compareTo(a), lessThan(0));
        expect(a.compareTo(ComparableField.fromValue(10.5)!), equals(0));
      });

      test('should compare mixed number types correctly', () {
        final a = ComparableField.fromValue<num>(10);
        final b = ComparableField.fromValue<num>(10.0);

        expect(a!.compareTo(b!), equals(0));
      });
    });

    // Regression: https://github.com/GetStream/stream-chat-flutter/issues/2601
    // The reporter observed lowercase-starting names and non-ASCII names
    // (Polish `Ł`, Norwegian `Ø`) getting pushed to the end of a list
    // sorted by `SortOption.asc('name')`, because the old comparator was
    // a raw codepoint compare.
    test('sorts issue #2601 names into a sensible order', () {
      final names = ['Zara', 'jhon', 'Łukasz', 'Øystein', 'Adam', 'Marek'];
      final sorted = [...names]..sort((a, b) => ComparableField.fromValue(a)!
          .compareTo(ComparableField.fromValue(b)!));

      expect(sorted, ['Adam', 'jhon', 'Łukasz', 'Marek', 'Øystein', 'Zara']);
    });

    group('compare strings', () {
      test('should compare strings alphabetically', () {
        final a = ComparableField.fromValue('banana');
        final b = ComparableField.fromValue('apple');

        expect(a!.compareTo(b!), greaterThan(0));
        expect(b.compareTo(a), lessThan(0));
        expect(a.compareTo(ComparableField.fromValue('banana')!), equals(0));
      });

      test('should ignore case in the primary comparison', () {
        final zara = ComparableField.fromValue('Zara');
        final jhon = ComparableField.fromValue('jhon');

        // With a naive codepoint compare 'jhon' would sort after 'Zara' (0x6A
        // > 0x5A). Case-insensitive normalization puts 'jhon' before 'Zara'.
        expect(jhon!.compareTo(zara!), lessThan(0));
      });

      test('should fold ligatures and stroked letters to base characters', () {
        // Backend sorts these against their base forms (Ł→l, Ø→o, Æ→ae) so
        // 'Łukasz' lands between 'Lukas' and 'Marek', not after 'Zara'.
        final lukas = ComparableField.fromValue('Lukas');
        final lukasz = ComparableField.fromValue('Łukasz');
        final marek = ComparableField.fromValue('Marek');
        final zara = ComparableField.fromValue('Zara');

        expect(lukas!.compareTo(lukasz!), lessThan(0));
        expect(lukasz.compareTo(marek!), lessThan(0));
        expect(lukasz.compareTo(zara!), lessThan(0));

        final oystein = ComparableField.fromValue('Øystein');
        expect(oystein!.compareTo(zara), lessThan(0));

        final aegon = ComparableField.fromValue('Ægon');
        final adam = ComparableField.fromValue('Adam');
        expect(adam!.compareTo(aegon!), lessThan(0));
        expect(aegon.compareTo(ComparableField.fromValue('Bob')!), lessThan(0));
      });

      test('should strip combining diacritical marks', () {
        // Accented characters compare as if the diacritic were absent: 'José'
        // sorts alongside 'Jose', not after all ASCII.
        final jose = ComparableField.fromValue('José');
        final joseAscii = ComparableField.fromValue('Jose');
        final juan = ComparableField.fromValue('Juan');

        expect(jose!.compareTo(juan!), lessThan(0));
        // Same normalized key — the comparator returns 0.
        expect(joseAscii!.compareTo(jose), equals(0));
      });

      test('should trim surrounding apostrophes and whitespace', () {
        // Backend applies `TrimApostrophe` and `TrimSpace` after
        // normalization, so leading/trailing U+0027 apostrophes and
        // whitespace fall off the primary key. `'Ali` sorts adjacent to
        // `Ali` (before `Bob`), not somewhere else entirely. Only U+0027
        // is trimmed — curly Unicode apostrophes (U+2018/U+2019) match the
        // backend's `IsApostrophe` predicate and stay in the key.
        final values = [
          'Bob',
          "'Ali",
          '  Ali  ',
          '’Ali', // curly apostrophe — NOT trimmed
          'Ali',
        ];

        final sorted = [...values]..sort((a, b) {
            final fa = ComparableField.fromValue(a)!;
            final fb = ComparableField.fromValue(b)!;
            return fa.compareTo(fb);
          });

        // The three ASCII-apostrophe/whitespace variants of `Ali` cluster
        // together and land before `Bob`; the curly-apostrophe variant
        // sorts after `Bob` because U+2019 stays in the primary key and
        // sorts higher than ASCII letters.
        expect(sorted.take(3).toSet(), {"'Ali", '  Ali  ', 'Ali'});
        expect(sorted[3], 'Bob');
        expect(sorted[4], '’Ali');
      });

      test('should preserve Vietnamese-specific characters', () {
        // Backend's `IsVietnameseSpecificRune` keeps `Đ/đ`, `Ơ/ơ`, `Ư/ư`, and
        // the tone-marked range U+1EA0..U+1EF1 out of the normalization fold.
        // So `Đăng` should sort by `đ` (U+0111 = 273), not by `d` (0x64).
        final dang = ComparableField.fromValue('Đăng');
        final ea = ComparableField.fromValue('Ea');
        // `đ` > `e` in raw codepoint order, so Vietnamese `Đăng` sorts after
        // the plain-Latin `Ea` — the opposite of what codepoint-blind folding
        // would produce.
        expect(dang!.compareTo(ea!), greaterThan(0));

        // But `Chi` still sorts before `Đăng` because `c` < `đ`.
        final chi = ComparableField.fromValue('Chi');
        expect(chi!.compareTo(dang), lessThan(0));

        // Non-Vietnamese diacritics on shared Latin letters (`ă` U+0103) are
        // still folded — only the Vietnamese-specific ranges are preserved.
        // So `Ăn` (U+0102 A-with-breve) still normalizes to `an`.
        final an = ComparableField.fromValue('Ăn');
        final bo = ComparableField.fromValue('Bo');
        expect(an!.compareTo(bo!), lessThan(0));
      });

      test('equal-normalized values compare as equal', () {
        final upper = ComparableField.fromValue('Apple');
        final lower = ComparableField.fromValue('apple');

        expect(upper!.compareTo(lower!), equals(0));
      });
    });

    group('compare dates', () {
      test('should compare dates correctly', () {
        final now = DateTime.now();
        final earlier = now.subtract(const Duration(days: 1));
        final later = now.add(const Duration(days: 1));

        final a = ComparableField.fromValue(now);
        final b = ComparableField.fromValue(earlier);
        final c = ComparableField.fromValue(later);

        expect(a!.compareTo(b!), greaterThan(0));
        expect(b.compareTo(a), lessThan(0));
        expect(c!.compareTo(a), greaterThan(0));
        expect(a.compareTo(ComparableField.fromValue(now)!), equals(0));
      });
    });

    group('compare booleans', () {
      test('should treat true as greater than false', () {
        final a = ComparableField.fromValue(true);
        final b = ComparableField.fromValue(false);

        expect(a!.compareTo(b!), greaterThan(0));
        expect(b.compareTo(a), lessThan(0));
      });

      test('should treat equal booleans as equal', () {
        final a = ComparableField.fromValue(true);
        final b = ComparableField.fromValue(true);
        final c = ComparableField.fromValue(false);
        final d = ComparableField.fromValue(false);

        expect(a!.compareTo(b!), equals(0));
        expect(c!.compareTo(d!), equals(0));
      });
    });

    group('compare different types', () {
      test('should handle custom objects gracefully', () {
        final a = ComparableField.fromValue(Object());
        final b = ComparableField.fromValue(Object());

        expect(a!.compareTo(b!), equals(0));
      });
    });

    group('ComparableFieldProvider', () {
      test('should retrieve comparable fields from implementation', () {
        final provider = TestProvider();

        final nameField = provider.getComparableField('name');
        final ageField = provider.getComparableField('age');
        final missingField = provider.getComparableField('missing');

        expect(nameField, isNotNull);
        expect(ageField, isNotNull);
        expect(missingField, isNull);
      });

      test('should compare fields correctly via provider', () {
        final provider1 = TestProvider(name: 'Adam', age: 30);
        final provider2 = TestProvider(name: 'Bob', age: 25);

        final name1 = provider1.getComparableField('name');
        final name2 = provider2.getComparableField('name');

        final age1 = provider1.getComparableField('age');
        final age2 = provider2.getComparableField('age');

        expect(name1!.compareTo(name2!), lessThan(0)); // Adam < Bob
        expect(age1!.compareTo(age2!), greaterThan(0)); // 30 > 25
      });
    });
  });
}

/// Test implementation of ComparableFieldProvider
class TestProvider implements ComparableFieldProvider {
  TestProvider({
    this.name = 'test',
    this.age = 0,
  });

  final String name;
  final int age;

  @override
  ComparableField? getComparableField(String sortKey) {
    return switch (sortKey) {
      'name' => ComparableField.fromValue(name),
      'age' => ComparableField.fromValue(age),
      _ => null,
    };
  }
}
