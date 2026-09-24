import '../device.dart';

/// The devices registered for the current user, returned by [StreamChatClient.getDevices].
class ListDevicesResponse {
  /// Creates a new [ListDevicesResponse].
  const ListDevicesResponse({
    required this.duration,
    this.devices = const [],
  });

  /// How long the server took to handle the request, such as `4.21ms`.
  final String duration;

  /// The devices registered for the current user.
  final List<Device> devices;
}
