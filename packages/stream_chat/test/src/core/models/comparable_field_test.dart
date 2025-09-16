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

    group('compare strings', () {
      test('should compare strings alphabetically', () {
        final a = ComparableField.fromValue('banana');
        final b = ComparableField.fromValue('apple');

        expect(a!.compareTo(b!), greaterThan(0));
        expect(b.compareTo(a), lessThan(0));
        expect(a.compareTo(ComparableField.fromValue('banana')!), equals(0));
      });

      test('should respect case sensitivity in string comparison', () {
        final a = ComparableField.fromValue('Apple');
        final b = ComparableField.fromValue('apple');

        // Uppercase comes before lowercase in ASCII
        expect(a!.compareTo(b!), lessThan(0));
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
