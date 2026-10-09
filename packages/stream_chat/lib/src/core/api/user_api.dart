import 'dart:convert';

import 'package:stream_core/stream_core.dart' show LocationCoordinate;

import '../http/stream_http_client.dart';
import '../models/location.dart';
import '../models/user.dart';
import 'requests.dart';
import 'responses.dart';

/// Defines the api dedicated to users operations
class UserApi {
  /// Initialize a new user api
  UserApi(this._client);

  final StreamHttpClient _client;

  /// Requests users with a given query.
  Future<QueryUsersResponse> queryUsers({
    bool presence = false,
    UserFilter? filter,
    List<UserSort>? sort,
    PaginationParams? pagination,
  }) async {
    final response = await _client.get(
      '/users',
      queryParameters: {
        'payload': jsonEncode({
          'presence': presence,
          if (sort != null) 'sort': sort,
          // Sent even when empty: a query without it is rejected, where `{}`
          // is accepted.
          'filter_conditions': filter ?? const <String, Object?>{},
          if (pagination != null) ...pagination.toJson(),
        }),
      },
    );
    return QueryUsersResponse.fromJson(response.data);
  }

  /// Retrieves all the active live locations of the current user.
  Future<GetActiveLiveLocationsResponse> getActiveLiveLocations() async {
    final response = await _client.get(
      '/users/live_locations',
    );

    return GetActiveLiveLocationsResponse.fromJson(response.data);
  }

  /// Updates an existing live location created by the current user.
  Future<Location> updateLiveLocation({
    required String messageId,
    String? createdByDeviceId,
    LocationCoordinate? location,
    DateTime? endAt,
  }) async {
    final response = await _client.put(
      '/users/live_locations',
      data: json.encode({
        'message_id': messageId,
        if (createdByDeviceId != null) 'created_by_device_id': createdByDeviceId,
        if (location?.latitude case final latitude) 'latitude': latitude,
        if (location?.longitude case final longitude) 'longitude': longitude,
        if (endAt != null) 'end_at': endAt.toIso8601String(),
      }),
    );

    return Location.fromJson(response.data);
  }
}
