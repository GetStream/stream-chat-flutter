import '../../../open_api/api.dart' as api;
import '../../core/models/location.dart';
import '../../core/models/response/shared_location_response.dart';
import '../../core/models/response/shared_locations_response.dart';
import 'channels_mapper.dart';
import 'messages_mapper.dart';

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

/// Maps a generated [api.SharedLocationResponse] to a [SharedLocationResponse].
extension SharedLocationResponseMapper on api.SharedLocationResponse {
  /// Converts this response into a [SharedLocationResponse].
  SharedLocationResponse toModel() => SharedLocationResponse(
    duration: duration,
    location: Location(
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
    ),
  );
}

/// Maps a generated [api.SharedLocationsResponse] to a
/// [SharedLocationsResponse].
extension SharedLocationsResponseMapper on api.SharedLocationsResponse {
  /// Converts this response into a [SharedLocationsResponse].
  SharedLocationsResponse toModel() => SharedLocationsResponse(
    duration: duration,
    activeLiveLocations: activeLiveLocations.map((location) => location.toModel()).toList(),
  );
}

/// Maps a [Location] to the generated [api.SharedLocation] a message sends.
extension LocationRequestMapper on Location {
  /// Converts this location into the shape a message sends.
  ///
  /// It carries the coordinates, the device sharing them and, for a live
  /// location, when the sharing ends.
  api.SharedLocation toRequest() => api.SharedLocation(
    latitude: latitude,
    longitude: longitude,
    createdByDeviceId: createdByDeviceId,
    endAt: endAt,
  );
}
