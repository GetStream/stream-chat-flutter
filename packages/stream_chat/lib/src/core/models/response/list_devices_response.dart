import 'package:freezed_annotation/freezed_annotation.dart';

import '../device.dart';

part 'list_devices_response.freezed.dart';

/// The devices registered for the current user.
@freezed
class ListDevicesResponse with _$ListDevicesResponse {
  /// Creates a new [ListDevicesResponse].
  const ListDevicesResponse({
    required this.duration,
    this.devices = const [],
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The devices registered for the current user.
  @override
  final List<Device> devices;
}
