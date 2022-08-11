import 'package:stream_chat/src/core/models/agora_payload.dart';
import 'package:stream_chat/src/core/models/hms_payload.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'call_payload.g.dart';

@JsonSerializable()
class CallPayload extends Equatable {
  final String id;
  final String provider;
  final AgoraPayload? agora;
  final HMSPayload? hms;

  const CallPayload(
      {required this.id, required this.provider, this.agora, this.hms});

  factory CallPayload.fromJson(Map<String, dynamic> json) =>
      _$CallPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$CallPayloadToJson(this);
  
  @override
  List<Object?> get props => [id, provider, agora, hms];
}
