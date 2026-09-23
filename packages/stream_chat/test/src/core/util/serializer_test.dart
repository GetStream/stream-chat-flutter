import 'package:stream_chat/src/core/util/serializer.dart';
import 'package:test/test.dart';

void main() {
  test(
    'moveToExtraDataFromRoot moves unknown keys into extra_data',
    () {
      final json = Serializer.moveToExtraDataFromRoot(
        {'test': 'test', 'name': 'Sahil', 'age': 22, 'country': 'India'},
        ['test'],
      );

      expect(json, {
        'test': 'test',
        'extra_data': {'name': 'Sahil', 'age': 22, 'country': 'India'},
      });
    },
  );

  test(
    'moveFromExtraDataToRoot moves the entries of extra_data to the root',
    () {
      final json = Serializer.moveFromExtraDataToRoot({
        'test': 'test',
        'extra_data': {'name': 'Sahil', 'age': 22, 'country': 'India'},
      });

      expect(json, {
        'test': 'test',
        'name': 'Sahil',
        'age': 22,
        'country': 'India',
      });
    },
  );

  test(
    'moveFromExtraDataToRoot lets extra_data override root keys',
    () {
      final json = Serializer.moveFromExtraDataToRoot({
        'name': 'root',
        'extra_data': {'name': 'extra'},
      });

      expect(json, {'name': 'extra'});
    },
  );
}
