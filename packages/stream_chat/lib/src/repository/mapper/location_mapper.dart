import '../../../open_api/api.dart' as api;
import '../../core/models/location.dart';
import 'channels_mapper.dart';
import 'message_mapper.dart';

// TODO(openapi-migration): re-point this mapper in group 10.

/// Maps a generated [api.SharedLocationResponseData] to a [Location].
extension SharedLocationResponseDataMapper on api.SharedLocationResponseData {
  /// Converts this response into a [Location].
  Location toModel() => Location(
    channelCid: channelCid,
    channel: channel?.toModel(),
    messageId: messageId,
    message: message?.toModel(),
    userId: userId,
    latitude: latitude,
    longitude: longitude,
    createdByDeviceId: createdByDeviceId,
    endAt: endAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
