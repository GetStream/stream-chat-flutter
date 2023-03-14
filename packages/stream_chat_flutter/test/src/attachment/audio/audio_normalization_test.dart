import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/attachment/audio/list_normalization.dart';

void main() {
  group(
    'List normalization test',
    () {
      test('Final size of list is should be close to approximation1', () async {
        const listSize = 60;
        final inputList = List<double>.filled(10245, 0);

        final result = ListNormalization.normalizeList(inputList, listSize);

        final error = result.length - listSize;

        expect(error, lessThanOrEqualTo(3));
      });

      test('Simple median should be correct1', () async {
        const listSize = 60;
        final inputList = List<double>.filled(10245, 0);

        final result = ListNormalization.normalizeList(inputList, listSize);
        expect(result.last, 0);
      });

      test('Simple median should be correct2', () async {
        const listSize = 60;
        final inputList = List<double>.filled(10245, 3);

        final result = ListNormalization.normalizeList(inputList, listSize);
        expect(result.first, 3);
      });

      test('Simple median should be correct3 - constant list', () async {
        const listSize = 60;
        final inputList = List<double>.filled(10245, 3);

        final result = ListNormalization.normalizeList(inputList, listSize);
        expect(result.last, 3);
      });

      test('Simple median should be correct4 - variable list', () async {
        const listSize = 1;
        final inputList =
            List<double>.generate(10, (index) => index.toDouble());

        final result = ListNormalization.normalizeList(inputList, listSize);
        expect(result.first, 4.5);
      });
    },
  );
}
