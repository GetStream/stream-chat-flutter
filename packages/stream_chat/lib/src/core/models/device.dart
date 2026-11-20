import 'package:freezed_annotation/freezed_annotation.dart';

import 'push_provider.dart';

part 'device.freezed.dart';

/// A device registered to receive push notifications for the current user.
///
/// Returned by [StreamChatClient.getDevices] and carried in [OwnUser.devices].
@freezed
class Device with _$Device {
  /// Creates a new [Device].
  const Device({
    required this.id,
    required this.pushProvider,
  });

  /// The token the push provider issued for this device.
  @override
  final String id;

  /// The provider that delivers pushes to this device.
  @override
  final PushProvider pushProvider;
}
