import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../device.dart';

// Converters for plain models embedded in json_serializable models that still decode v1 JSON. Each one is deleted
// by the migration group that turns its parent into a plain model.

/// Converts a [Device] to and from its v1 `id` and `push_provider` keys.
// TODO(openapi-migration): remove in group 09
@internal
class DeviceV1JsonConverter implements JsonConverter<Device, Map<String, dynamic>> {
  /// Creates a new [DeviceV1JsonConverter].
  const DeviceV1JsonConverter();

  // Reads the keys directly rather than through the generated device type: that type requires `user_id` and
  // `created_at`, which a device written by [toJson] does not carry.
  @override
  Device fromJson(Map<String, dynamic> json) => Device(
    id: json['id'] as String,
    pushProvider: json['push_provider'] as String,
  );

  @override
  Map<String, dynamic> toJson(Device device) => {
    'id': device.id,
    'push_provider': device.pushProvider,
  };
}
