import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

/// Useful mapping functions for [LocationEntity]
extension LocationEntityX on LocationEntity {
  /// Maps a [LocationEntity] into [Location]
  Location toLocation({
    ChannelModel? channel,
    Message? message,
  }) => Location(
    channelCid: channelCid,
    channel: channel,
    messageId: messageId,
    message: message,
    userId: userId,
    latitude: latitude,
    longitude: longitude,
    createdByDeviceId: createdByDeviceId,
    endAt: endAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

/// Useful mapping functions for [Location]
extension LocationX on Location {
  /// Maps a [Location] into [LocationEntity]
  LocationEntity toEntity() => LocationEntity(
    channelCid: channelCid,
    messageId: messageId,
    userId: userId,
    latitude: latitude,
    longitude: longitude,
    createdByDeviceId: createdByDeviceId,
    endAt: endAt,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
