import 'package:stream_chat/src/core/models/converters/v1_json_converters.dart';
import 'package:stream_chat/src/core/models/device.dart';
import 'package:test/test.dart';

void main() {
  const converter = DeviceV1JsonConverter();

  test('DeviceV1JsonConverter should read a v1 device, ignoring the fields a Device does not carry', () {
    final device = converter.fromJson({
      'id': 'device-id',
      'push_provider': 'firebase',
      'push_provider_name': 'staging',
      'user_id': 'user-id',
      'created_at': '2020-04-23T14:36:21.838196Z',
      'disabled': false,
    });

    expect(device.id, 'device-id');
    expect(device.pushProvider, 'firebase');
  });

  test('DeviceV1JsonConverter should write the device under its wire keys', () {
    final json = converter.toJson(Device(id: 'device-id', pushProvider: 'apn'));

    expect(json, {'id': 'device-id', 'push_provider': 'apn'});
  });

  test('DeviceV1JsonConverter should read back what it writes', () {
    final device = converter.fromJson(converter.toJson(Device(id: 'device-id', pushProvider: 'huawei')));

    expect(device.id, 'device-id');
    expect(device.pushProvider, 'huawei');
  });
}
