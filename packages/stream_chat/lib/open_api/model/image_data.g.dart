// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageData _$ImageDataFromJson(Map<String, dynamic> json) => ImageData(
  frames: json['frames'] as String,
  height: json['height'] as String,
  size: json['size'] as String,
  url: json['url'] as String,
  width: json['width'] as String,
);

Map<String, dynamic> _$ImageDataToJson(ImageData instance) => <String, dynamic>{
  'frames': instance.frames,
  'height': instance.height,
  'size': instance.size,
  'url': instance.url,
  'width': instance.width,
};
