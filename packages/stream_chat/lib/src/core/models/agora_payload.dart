import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agora_payload.g.dart';

@JsonSerializable()
class AgoraPayload {
  final String channel;
  const AgoraPayload({required this.channel});

  factory AgoraPayload.fromJson(Map<String, dynamic> json) =>
      _$AgoraPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$AgoraPayloadToJson(this);
}
