import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_persistence/src/db/query_utils.dart';

void main() {
  group('chunked', () {
    test('returns an empty iterable for an empty input', () {
      expect(chunked(<int>[]).toList(), isEmpty);
    });

    test('yields a single chunk when input fits in one chunk', () {
      final input = List.generate(5, (i) => i);
      expect(chunked(input, 10).toList(), [input]);
    });

    test('splits input into evenly sized chunks', () {
      final input = List.generate(6, (i) => i);
      expect(chunked(input, 2).toList(), [
        [0, 1],
        [2, 3],
        [4, 5],
      ]);
    });

    test('handles a trailing partial chunk', () {
      final input = List.generate(7, (i) => i);
      expect(chunked(input, 3).toList(), [
        [0, 1, 2],
        [3, 4, 5],
        [6],
      ]);
    });

    test('uses a default size of 900', () {
      final input = List.generate(1000, (i) => i);
      final chunks = chunked(input).toList();
      expect(chunks, hasLength(2));
      expect(chunks[0], hasLength(900));
      expect(chunks[1], hasLength(100));
    });

    test('throws ArgumentError when size is zero', () {
      expect(() => chunked([1, 2, 3], 0).toList(), throwsArgumentError);
    });

    test('throws ArgumentError when size is negative', () {
      expect(() => chunked([1, 2, 3], -1).toList(), throwsArgumentError);
    });
  });
}
