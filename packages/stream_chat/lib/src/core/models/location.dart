import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_core/stream_core.dart' show LocationCoordinate;
import 'channel_model.dart';
import 'message.dart';

part 'location.freezed.dart';

/// {@template location}
/// A model class representing a shared location.
///
/// The [Location] represents a location shared in a channel message.
///
/// It can be of two types:
/// 1. **Static Location**: A location that does not change over time and has
/// no end time.
/// 2. **Live Location**: A location that updates in real-time and has an
/// end time.
/// {@endtemplate}
@Freezed(copyWith: false)
class Location with _$Location {
  /// {@macro location}
  Location({
    this.channelCid,
    this.channel,
    this.messageId,
    this.message,
    this.userId,
    required this.latitude,
    required this.longitude,
    this.createdByDeviceId,
    DateTime? endAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : endAt = endAt?.toUtc(),
       createdAt = createdAt ?? DateTime.timestamp(),
       updatedAt = updatedAt ?? DateTime.timestamp();

  /// The channel CID where the message exists.
  ///
  /// Only set on a location that has been received, not on one built locally.
  @override
  final String? channelCid;

  /// The channel where the message exists.
  @override
  final ChannelModel? channel;

  /// The ID of the message that contains the shared location.
  @override
  final String? messageId;

  /// The message that contains the shared location.
  @override
  final Message? message;

  /// The ID of the user who shared the location.
  @override
  final String? userId;

  /// The latitude of the shared location.
  @override
  final double latitude;

  /// The longitude of the shared location.
  @override
  final double longitude;

  /// The ID of the device that shared the location.
  @override
  final String? createdByDeviceId;

  /// The date at which the shared location will end.
  @override
  final DateTime? endAt;

  /// The date at which the location was shared.
  @override
  final DateTime createdAt;

  /// The date at which the location was last updated.
  @override
  final DateTime updatedAt;

  /// Whether this is a live location whose [endAt] is still in the future.
  bool get isActive {
    final endAt = this.endAt;
    if (endAt == null) return false;

    return endAt.isAfter(DateTime.now());
  }

  /// Whether this location is not [isActive]: a static location, or a live one whose [endAt] has passed.
  bool get isExpired => !isActive;

  /// Whether this is a live location, one with an [endAt].
  bool get isLive => endAt != null;

  /// Whether this is a static location, one without an [endAt].
  bool get isStatic => endAt == null;

  /// Returns the coordinates of the shared location.
  LocationCoordinate get coordinates => .new(latitude: latitude, longitude: longitude);

  /// Creates a copy of [Location] with specified attributes overridden.
  Location copyWith({
    String? channelCid,
    ChannelModel? channel,
    String? messageId,
    Message? message,
    String? userId,
    double? latitude,
    double? longitude,
    String? createdByDeviceId,
    DateTime? endAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Location(
      channelCid: channelCid ?? this.channelCid,
      channel: channel ?? this.channel,
      messageId: messageId ?? this.messageId,
      message: message ?? this.message,
      userId: userId ?? this.userId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdByDeviceId: createdByDeviceId ?? this.createdByDeviceId,
      endAt: endAt ?? this.endAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
