import 'package:freezed_annotation/freezed_annotation.dart';

part 'device.freezed.dart';

/// Provider used to send push notifications.
enum PushProvider {
  /// Send notifications using Google's Firebase Cloud Messaging.
  firebase,

  /// Send notifications using Huawei's Push Kit.
  huawei,

  /// Send notifications using Xiaomi's Mi Push Service.
  xiaomi,

  /// Send notifications using Apple's Push Notification service.
  apn,
}

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

  /// The name of the provider that delivers pushes to this device, such as `firebase` or `apn`.
  ///
  /// One of the [PushProvider] names.
  @override
  final String pushProvider;
}
