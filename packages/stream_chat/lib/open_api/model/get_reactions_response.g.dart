// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_reactions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetReactionsResponse _$GetReactionsResponseFromJson(
  Map<String, dynamic> json,
) => GetReactionsResponse(
  duration: json['duration'] as String,
  reactions: (json['reactions'] as List<dynamic>)
      .map((e) => ReactionResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetReactionsResponseToJson(
  GetReactionsResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'reactions': instance.reactions.map((e) => e.toJson()).toList(),
};
