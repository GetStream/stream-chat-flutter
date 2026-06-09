import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/location_coordinates.dart';
import 'package:stream_chat/src/core/models/message.dart';

part 'location.g.dart';

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
@JsonSerializable()
class Location extends Equatable {
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

  /// Create a new instance from a json
  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  /// The channel CID where the message exists.
  ///
  /// This is only available if the location is coming from server response.
  @JsonKey(includeToJson: false)
  final String? channelCid;

  /// The channel where the message exists.
  @JsonKey(includeToJson: false)
  final ChannelModel? channel;

  /// The ID of the message that contains the shared location.
  @JsonKey(includeToJson: false)
  final String? messageId;

  /// The message that contains the shared location.
  @JsonKey(includeToJson: false)
  final Message? message;

  /// The ID of the user who shared the location.
  @JsonKey(includeToJson: false)
  final String? userId;

  /// The latitude of the shared location.
  final double latitude;

  /// The longitude of the shared location.
  final double longitude;

  /// The ID of the device that created the reminder.
  @JsonKey(includeIfNull: false)
  final String? createdByDeviceId;

  /// The date at which the shared location will end.
  @JsonKey(includeIfNull: false)
  final DateTime? endAt;

  /// The date at which the reminder was created.
  @JsonKey(includeToJson: false)
  final DateTime createdAt;

  /// The date at which the reminder was last updated.
  @JsonKey(includeToJson: false)
  final DateTime updatedAt;

  /// Returns true if the live location is still active (end_at > now)
  bool get isActive {
    final endAt = this.endAt;
    if (endAt == null) return false;

    return endAt.isAfter(DateTime.now());
  }

  /// Returns true if the live location is expired (end_at <= now)
  bool get isExpired => !isActive;

  /// Returns true if this is a live location (has end_at)
  bool get isLive => endAt != null;

  /// Returns true if this is a static location (no end_at)
  bool get isStatic => endAt == null;

  /// Returns the coordinates of the shared location.
  LocationCoordinates get coordinates {
    return LocationCoordinates(
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Serialize to json
  Map<String, dynamic> toJson() => _$LocationToJson(this);

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

  @override
  List<Object?> get props => [
    channelCid,
    channel,
    messageId,
    message,
    userId,
    latitude,
    longitude,
    createdByDeviceId,
    endAt,
    createdAt,
    updatedAt,
  ];
}
