import 'package:freezed_annotation/freezed_annotation.dart';

import '../location.dart';

part 'shared_locations_response.freezed.dart';

/// The current user's live locations that are still being shared.
///
/// See also:
///
///  * [StreamChatClient.getUserLiveLocations], which returns it.
@freezed
class SharedLocationsResponse with _$SharedLocationsResponse {
  /// Creates a new [SharedLocationsResponse].
  const SharedLocationsResponse({
    required this.duration,
    required this.activeLiveLocations,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The live locations the current user is still sharing.
  @override
  final List<Location> activeLiveLocations;
}
