/// A service that delivers push notifications to a device.
///
/// Any provider the server supports can be named, including one without a
/// constant here, by wrapping its wire value: `PushProvider('firebase')`.
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
