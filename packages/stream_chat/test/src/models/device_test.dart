import 'dart:convert';

import 'package:test/test.dart';
import 'package:stream_chat/src/models/device.dart';

void main() {
  group('src/models/device', () {
    const jsonExample = r'''{
      "id": "device-id",
      "push_provider": "push-provider"
    }''';

    test('should parse json correctly', () {
      final device = Device.fromJson(json.decode(jsonExample));
      expect(device.id, 'device-id');
      expect(device.pushProvider, 'push-provider');
    });

    test('should serialize to json correctly', () {
      final device = Device(id: 'device-id', pushProvider: 'push-provider');

      expect(
        device.toJson(),
        {
          'id': 'device-id',
          'push_provider': 'push-provider',
        },
      );
    });
  });
}
