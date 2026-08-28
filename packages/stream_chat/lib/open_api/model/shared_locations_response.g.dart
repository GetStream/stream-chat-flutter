// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_locations_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedLocationsResponse _$SharedLocationsResponseFromJson(
  Map<String, dynamic> json,
) => SharedLocationsResponse(
  activeLiveLocations: (json['active_live_locations'] as List<dynamic>)
      .map(
        (e) => SharedLocationResponseData.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$SharedLocationsResponseToJson(
  SharedLocationsResponse instance,
) => <String, dynamic>{
  'active_live_locations': instance.activeLiveLocations
      .map((e) => e.toJson())
      .toList(),
  'duration': instance.duration,
};
