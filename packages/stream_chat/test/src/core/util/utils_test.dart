import 'package:stream_chat/src/core/util/utils.dart';
import 'package:test/test.dart';

void main() {
  test('should generate a `randomId` of length 33', () {
    final id = randomId(size: 33);
    expect(id.length, 33);
  });

  test('should `generateHash` for the passed objects', () {
    final objects = ['Sahil', 23, 'Flutter Engineer', 'India'];
    final hash = generateHash(objects);
    expect(hash, 'WyJTYWhpbCIsMjMsIkZsdXR0ZXIgRW5naW5lZXIiLCJJbmRpYSJd');
  });
}
