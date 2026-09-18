import '../../../open_api/models.dart' show CreateDeviceRequestPushProvider;

/// Provider used to send push notifications.
///
/// An extension type over `String`, so a provider is its own wire value:
/// `PushProvider.firebase` and `'firebase'` compare equal and interchange.
///
/// - [PushProvider.firebase] — Google's Firebase Cloud Messaging
/// - [PushProvider.huawei] — Huawei's Push Kit
/// - [PushProvider.xiaomi] — Xiaomi's Mi Push Service
/// - [PushProvider.apn] — Apple's Push Notification service
typedef PushProvider = CreateDeviceRequestPushProvider;
