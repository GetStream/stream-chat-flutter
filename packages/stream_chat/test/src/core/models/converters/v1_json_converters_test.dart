import 'package:stream_chat/src/core/models/converters/v1_json_converters.dart';
import 'package:stream_chat/src/core/models/device.dart';
import 'package:test/test.dart';

void main() {
  test('DeviceV1JsonConverter.fromJson reads a v1 device, ignoring the fields a Device does not carry', () {
    const converter = DeviceV1JsonConverter();

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

  test('DeviceV1JsonConverter.toJson writes the device under its wire keys', () {
    const converter = DeviceV1JsonConverter();

    final json = converter.toJson(Device(id: 'device-id', pushProvider: 'apn'));

    expect(json, {'id': 'device-id', 'push_provider': 'apn'});
  });

  test('DeviceV1JsonConverter.fromJson reads back what toJson writes', () {
    const converter = DeviceV1JsonConverter();

    final device = converter.fromJson(converter.toJson(Device(id: 'device-id', pushProvider: 'huawei')));

    expect(device.id, 'device-id');
    expect(device.pushProvider, 'huawei');
  });
}
