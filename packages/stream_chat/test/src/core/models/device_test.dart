import 'package:stream_chat/src/core/models/device.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/device', () {
    test('should parse json correctly', () {
      final device = Device.fromJson(jsonFixture('device.json'));
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
