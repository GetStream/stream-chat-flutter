/// A service that delivers push notifications to a device.
///
/// A provider without a constant here can still be named by wrapping its
/// value: `PushProvider('firebase')`.
extension type const PushProvider(String rawType) implements String {
  /// Google's Firebase Cloud Messaging.
  static const firebase = PushProvider('firebase');

  /// Huawei's Push Kit.
  static const huawei = PushProvider('huawei');

  /// Xiaomi's Mi Push Service.
  static const xiaomi = PushProvider('xiaomi');

  /// Apple's Push Notification service.
  static const apn = PushProvider('apn');
}
