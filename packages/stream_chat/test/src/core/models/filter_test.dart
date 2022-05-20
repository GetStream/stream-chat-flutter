import 'dart:convert';

import 'package:stream_chat/src/core/models/filter.dart';
import 'package:test/test.dart';

void main() {
  group('operators', () {
    test('equal', () {
      const key = 'testKey';
      const value = 'testValue';
      final filter = Filter.equal(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.equal.toString());
    });

    test('notEqual', () {
      const key = 'testKey';
      const value = 'testValue';
      final filter = Filter.notEqual(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.notEqual.toString());
    });

    test('greater', () {
      const key = 'testKey';
      const value = 'testValue';
      final filter = Filter.greater(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.greater.toString());
    });

    test('greaterOrEqual', () {
      const key = 'testKey';
      const value = 'testValue';
      final filter = Filter.greaterOrEqual(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.greaterOrEqual.toString());
    });

    test('less', () {
      const key = 'testKey';
      const value = 'testValue';
      final filter = Filter.less(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.less.toString());
    });

    test('lessOrEqual', () {
      const key = 'testKey';
      const value = 'testValue';
      final filter = Filter.lessOrEqual(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.lessOrEqual.toString());
    });

    test('in', () {
      const key = 'testKey';
      const values = ['testValue'];
      final filter = Filter.in_(key, values);
      expect(filter.key, key);
      expect(filter.value, values);
      expect(filter.operator, FilterOperator.in_.toString());
    });

    test('in', () {
      const key = 'testKey';
      const values = ['testValue'];
      final filter = Filter.in_(key, values);
      expect(filter.key, key);
      expect(filter.value, values);
      expect(filter.operator, FilterOperator.in_.toString());
    });

    test('notIn', () {
      const key = 'testKey';
      const values = ['testValue'];
      final filter = Filter.notIn(key, values);
      expect(filter.key, key);
      expect(filter.value, values);
      expect(filter.operator, FilterOperator.notIn.toString());
    });

    test('query', () {
      const key = 'testKey';
      const value = 'testQuery';
      final filter = Filter.query(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.query.toString());
    });

    test('autoComplete', () {
      const key = 'testKey';
      const value = 'testQuery';
      final filter = Filter.autoComplete(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.autoComplete.toString());
    });

    test('exists', () {
      const key = 'testKey';
      final filter = Filter.exists(key);
      expect(filter.key, key);
      expect(filter.value, isTrue);
      expect(filter.operator, FilterOperator.exists.toString());
    });

    test('notExists', () {
      const key = 'testKey';
      final filter = Filter.notExists(key);
      expect(filter.key, key);
      expect(filter.value, isFalse);
      expect(filter.operator, FilterOperator.exists.toString());
    });

    test('custom', () {
      const key = 'testKey';
      const value = 'testValue';
      const operator = r'$customOperator';
      const filter = Filter.custom(operator: operator, key: key, value: value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, operator);
    });

    test('raw', () {
      const value = {
        'test': ['a', 'b'],
      };
      const filter = Filter.raw(value: value);
      expect(filter.value, value);
    });

    test('empty', () {
      const filter = Filter.empty();
      expect(filter.value, {});
    });

    test('contains', () {
      const key = 'testKey';
      const values = 'testValue';
      final filter = Filter.contains(key, values);
      expect(filter.key, key);
      expect(filter.value, values);
      expect(filter.operator, FilterOperator.contains.toString());
    });

    group('groupedOperator', () {
      final filter1 = Filter.equal('testKey', 'testValue');
      final filter2 = Filter.in_('testKey', const ['testValue']);
      final filters = [filter1, filter2];

      test('and', () {
        final filter = Filter.and(filters);
        expect(filter.key, isNull);
        expect(filter.value, filters);
        expect(filter.operator, FilterOperator.and.toString());
      });

      test('or', () {
        final filter = Filter.or(filters);
        expect(filter.key, isNull);
        expect(filter.value, filters);
        expect(filter.operator, FilterOperator.or.toString());
      });

      test('nor', () {
        final filter = Filter.nor(filters);
        expect(filter.key, isNull);
        expect(filter.value, filters);
        expect(filter.operator, FilterOperator.nor.toString());
      });
    });
  });

  group('encoding', () {
    group('nonGroupedFilter', () {
      test('simpleValue', () {
        const key = 'testKey';
        const value = 'testValue';
        final filter = Filter.equal(key, value);
        final encoded = json.encode(filter);
        expect(
          encoded,
          '''''{"$key":{"${FilterOperator.equal.toString()}":${json.encode(value)}}}''',
        );
      });
      test('listValue', () {
        const key = 'testKey';
        const values = ['testValue'];
        final filter = Filter.in_(key, values);
        final encoded = json.encode(filter);
        expect(
          encoded,
          '''{"$key":{"${FilterOperator.in_.toString()}":${json.encode(values)}}}''',
        );
      });

      test('custom with no operator', () {
        const key = 'testKey';
        const values = ['testValue'];
        const filter = Filter.custom(key: key, value: values);
        final encoded = json.encode(filter);
        expect(
          encoded,
          '{"$key":${json.encode(values)}}',
        );
      });

      test('raw', () {
        const value = {
          'test': ['a', 'b'],
        };
        const filter = Filter.raw(value: value);

        final encoded = json.encode(filter);
        expect(
          encoded,
          json.encode(value),
        );
      });

      test('empty', () {
        const filter = Filter.empty();
        final encoded = json.encode(filter);
        expect(encoded, '{}');
      });
    });

    test('groupedFilter', () {
      final filter1 = Filter.equal('testKey', 'testValue');
      final filter2 = Filter.in_('testKey', const ['testValue']);
      final filters = [filter1, filter2];

      final filter = Filter.and(filters);
      final encoded = json.encode(filter);
      expect(
        encoded,
        '{"${FilterOperator.and.toString()}":${json.encode(filters)}}',
      );
    });

    group('equality', () {
      test('simpleFilter', () {
        final filter1 = Filter.equal('testKey', 'testValue');
        final filter2 = Filter.equal('testKey', 'testValue');
        expect(filter1, filter2);
      });

      test('groupedFilter', () {
        final filter1 = Filter.and([Filter.equal('testKey', 'testValue')]);
        final filter2 = Filter.and([Filter.equal('testKey', 'testValue')]);
        expect(filter1, filter2);
      });
    });
  });
}
