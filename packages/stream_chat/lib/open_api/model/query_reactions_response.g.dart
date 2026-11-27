// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_reactions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryReactionsResponse _$QueryReactionsResponseFromJson(
  Map<String, dynamic> json,
) => QueryReactionsResponse(
  duration: json['duration'] as String,
  next: json['next'] as String?,
  prev: json['prev'] as String?,
  reactions: (json['reactions'] as List<dynamic>)
      .map((e) => ReactionResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QueryReactionsResponseToJson(
  QueryReactionsResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'next': instance.next,
  'prev': instance.prev,
  'reactions': instance.reactions.map((e) => e.toJson()).toList(),
};
