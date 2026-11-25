import 'package:freezed_annotation/freezed_annotation.dart';

import '../location.dart';

part 'shared_location_response.freezed.dart';

/// A live location after it was updated or stopped.
///
/// See also:
///
///  * [StreamChatClient.updateLiveLocation] and
///    [StreamChatClient.stopLiveLocation], which return it.
@freezed
class SharedLocationResponse with _$SharedLocationResponse {
  /// Creates a new [SharedLocationResponse].
  const SharedLocationResponse({
    required this.duration,
    required this.location,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The live location as it is after the call.
  @override
  final Location location;
}
