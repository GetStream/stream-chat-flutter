import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'call_payload.g.dart';

/// Model containing the information about a call.
@JsonSerializable(createToJson: false)
class CallPayload extends Equatable {
  /// Create a new instance.
  const CallPayload({
    required this.id,
    required this.provider,
    this.agora,
    this.hms,
  });

  /// Create a new instance from a [json].
  factory CallPayload.fromJson(Map<String, dynamic> json) =>
      _$CallPayloadFromJson(json);

  /// The call id.
  final String id;

  /// The call provider.
  final String provider;

  /// The payload specific to Agora.
  final AgoraPayload? agora;

  /// The payload specific to 100ms.
  final HMSPayload? hms;

  @override
  List<Object?> get props => [id, provider, agora, hms];
}

/// Payload for Agora call.
@JsonSerializable(createToJson: false)
class AgoraPayload extends Equatable {
  /// Create a new instance.
  const AgoraPayload({required this.channel});

  /// Create a new instance from a [json].
  factory AgoraPayload.fromJson(Map<String, dynamic> json) =>
      _$AgoraPayloadFromJson(json);

  /// The Agora channel.
  final String channel;

  @override
  List<Object?> get props => [channel];
}

/// Payload for 100ms call.
@JsonSerializable(createToJson: false)
class HMSPayload extends Equatable {
  /// Create a new instance.
  const HMSPayload({required this.roomId, required this.roomName});

  /// Create a new instance from a [json].
  factory HMSPayload.fromJson(Map<String, dynamic> json) =>
      _$HMSPayloadFromJson(json);

  /// The id of the 100ms room.
  final String roomId;

  /// The name of the 100ms room.
  final String roomName;

  @override
  List<Object?> get props => [roomId, roomName];
}
