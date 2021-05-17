import 'dart:convert';

import 'package:test/test.dart';
import 'package:stream_chat/src/models/filter.dart';

void main() {
  group('operators', () {
    test('equal', () {
      const key = 'testKey';
      const value = 'testValue';
      final filter = Filter.equal(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.equal.rawValue);
    });

    test('notEqual', () {
      const key = 'testKey';
      const value = 'testValue';
      final filter = Filter.notEqual(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.notEqual.rawValue);
    });

    test('greater', () {
      const key = 'testKey';
      const value = 'testValue';
      final filter = Filter.greater(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.greater.rawValue);
    });

    test('greaterOrEqual', () {
      const key = 'testKey';
      const value = 'testValue';
      final filter = Filter.greaterOrEqual(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.greaterOrEqual.rawValue);
    });

    test('less', () {
      const key = 'testKey';
      const value = 'testValue';
      final filter = Filter.less(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.less.rawValue);
    });

    test('lessOrEqual', () {
      const key = 'testKey';
      const value = 'testValue';
      final filter = Filter.lessOrEqual(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.lessOrEqual.rawValue);
    });

    test('in', () {
      const key = 'testKey';
      const values = ['testValue'];
      final filter = Filter.in_(key, values);
      expect(filter.key, key);
      expect(filter.value, values);
      expect(filter.operator, FilterOperator.in_.rawValue);
    });

    test('in', () {
      const key = 'testKey';
      const values = ['testValue'];
      final filter = Filter.in_(key, values);
      expect(filter.key, key);
      expect(filter.value, values);
      expect(filter.operator, FilterOperator.in_.rawValue);
    });

    test('notIn', () {
      const key = 'testKey';
      const values = ['testValue'];
      final filter = Filter.notIn(key, values);
      expect(filter.key, key);
      expect(filter.value, values);
      expect(filter.operator, FilterOperator.notIn.rawValue);
    });

    test('query', () {
      const key = 'testKey';
      const value = 'testQuery';
      final filter = Filter.query(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.query.rawValue);
    });

    test('autoComplete', () {
      const key = 'testKey';
      const value = 'testQuery';
      final filter = Filter.autoComplete(key, value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, FilterOperator.autoComplete.rawValue);
    });

    test('exists', () {
      const key = 'testKey';
      final filter = Filter.exists(key);
      expect(filter.key, key);
      expect(filter.value, isTrue);
      expect(filter.operator, FilterOperator.exists.rawValue);
    });

    test('notExists', () {
      const key = 'testKey';
      final filter = Filter.exists(key, exists: false);
      expect(filter.key, key);
      expect(filter.value, isFalse);
      expect(filter.operator, FilterOperator.exists.rawValue);
    });

    test('custom', () {
      const key = 'testKey';
      const value = 'testValue';
      const operator = '\$customOperator';
      const filter = Filter.custom(operator: operator, key: key, value: value);
      expect(filter.key, key);
      expect(filter.value, value);
      expect(filter.operator, operator);
    });

    group('groupedOperator', () {
      final filter1 = Filter.equal('testKey', 'testValue');
      final filter2 = Filter.in_('testKey', const ['testValue']);
      final filters = [filter1, filter2];

      test('and', () {
        final filter = Filter.and(filters);
        expect(filter.key, isNull);
        expect(filter.value, filters);
        expect(filter.operator, FilterOperator.and.rawValue);
      });

      test('or', () {
        final filter = Filter.or(filters);
        expect(filter.key, isNull);
        expect(filter.value, filters);
        expect(filter.operator, FilterOperator.or.rawValue);
      });

      test('nor', () {
        final filter = Filter.nor(filters);
        expect(filter.key, isNull);
        expect(filter.value, filters);
        expect(filter.operator, FilterOperator.nor.rawValue);
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
          '{"$key":{"${FilterOperator.equal.rawValue}":${json.encode(value)}}}',
        );
      });
      test('listValue', () {
        const key = 'testKey';
        const values = ['testValue'];
        final filter = Filter.in_(key, values);
        final encoded = json.encode(filter);
        expect(
          encoded,
          '{"$key":{"${FilterOperator.in_.rawValue}":${json.encode(values)}}}',
        );
      });

      test('custom with no operator', () {
        const key = 'testKey';
        const values = ['testValue'];
        final filter = Filter.custom(key: key, value: values);
        final encoded = json.encode(filter);
        expect(
          encoded,
          '{"$key":${json.encode(values)}}',
        );
        print('asdasda');
        print('{"$key":${json.encode(values)}}');
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
        '{"${FilterOperator.and.rawValue}":${json.encode(filters)}}',
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
