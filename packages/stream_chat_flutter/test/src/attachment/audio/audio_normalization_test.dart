import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/attachment/audio/list_normalization.dart';

void main() {
  group(
    'List normalization test',
    () {
      test('Width - Final size of list should be correct - shrink1', () async {
        const listSize = 60;
        final inputList = List<double>.filled(10245, 0);

        final result = ListNormalization.normalizeBars(inputList, listSize, 0);

        expect(result.length, listSize);
      });

// test('Width - Final size of list should be correct2 - shrink2', () async {
//   const listSize = 60;
//   final inputList = List<double>.filled(80, 0);
//
//   final result = ListNormalization.normalizeBars(inputList, listSize, 0);
//
//   expect(result.length, listSize);
// });

      test('Width - Final size of list should be correct2 - expand1', () async {
        const listSize = 10245;
        final inputList = List<double>.filled(60, 0);

        final result = ListNormalization.normalizeBars(inputList, listSize, 0);

        expect(result.length, listSize);
      });

      test('Width - Final size of list should be correct2 - expand2', () async {
        const listSize = 80;
        final inputList = List<double>.filled(60, 0);

        final result = ListNormalization.normalizeBars(inputList, listSize, 0);

        expect(result.length, listSize);
      });

      test('Width - Simple median should be correct1', () async {
        const listSize = 60;
        final inputList = List<double>.filled(10245, 0);

        final result = ListNormalization.shrinkList(inputList, listSize);
        expect(result.last, 0);
      });

      test('Width - Simple median should be correct2', () async {
        const listSize = 60;
        final inputList = List<double>.filled(10245, 3);

        final result = ListNormalization.shrinkList(inputList, listSize);
        expect(result.first, 3);
      });

      test('Width - Simple median should be correct3 - constant list',
          () async {
        const listSize = 60;
        final inputList = List<double>.filled(10245, 3);

        final result = ListNormalization.shrinkList(inputList, listSize);
        expect(result.last, 3);
      });

      test('Width - Simple median should be correct4 - variable list',
          () async {
        const listSize = 1;
        final inputList =
            List<double>.generate(10, (index) => index.toDouble());

        final result = ListNormalization.shrinkList(inputList, listSize);
        expect(result.first, 4.5);
      });

      test('Normalized list should be positive1', () async {
        const listSize = 100;
        final inputList = List<double>.filled(60, -5);

        final result = ListNormalization.normalizeBars(inputList, listSize, -5);

        expect(result.any((element) => element < 0), false);
      });

      test('Normalized list should be positive2', () async {
        const listSize = 100;
        final inputList = List<double>.generate(60, (e) => e - 30);

        final result =
            ListNormalization.normalizeBars(inputList, listSize, -30);

        expect(result.any((element) => element < 0), false);
      });

      test('At least one number should be 1', () async {
        const listSize = 100;
        final inputList = List<double>.generate(60, (e) => e - 30);

        final result =
            ListNormalization.normalizeBars(inputList, listSize, -30);

        expect(result.any((element) => element == 1), true);
      });
    },
  );
}
