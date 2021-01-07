import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/src/models/user.dart';

void main() {
  group('src/models/user', () {
    const jsonExample = '''
      {
        "id": "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e"
      }     
      ''';

    test('should parse json correctly', () {
      final user = User.fromJson(json.decode(jsonExample));
      expect(user.id, 'bbb19d9a-ee50-45bc-84e5-0584e79d0c9e');
    });

    test('should serialize to json correctly', () {
      final user =
          User(id: 'bbb19d9a-ee50-45bc-84e5-0584e79d0c9e', role: "abc");

      expect(user.toJson(), {
        'id': "bbb19d9a-ee50-45bc-84e5-0584e79d0c9e",
      });
    });
  });
}
