import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';



part 'call_token_payload.g.dart';

@JsonSerializable(includeIfNull: false)
class CallTokenPayload extends Equatable {
  final String token;
  final int? agoraUid;
  final String? agoraAppId;
  const CallTokenPayload({required this.token, this.agoraUid, this.agoraAppId});

  factory CallTokenPayload.fromJson(Map<String, dynamic> json) =>
      _$CallTokenPayloadFromJson(json);

  @override
  List<Object?> get props => [token, agoraAppId, agoraUid];
}
