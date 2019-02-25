// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaEntity _$MediaEntityFromJson(Map<String, dynamic> json) {
  return MediaEntity(
      type: json['type'] as String,
      showAt: (json['show_at'] as num)?.toDouble(),
      image: json['image'] as String,
      width: (json['width'] as num)?.toDouble(),
      height: (json['height'] as num)?.toDouble());
}

Map<String, dynamic> _$MediaEntityToJson(MediaEntity instance) =>
    <String, dynamic>{
      'type': instance.type,
      'show_at': instance.showAt,
      'image': instance.image,
      'width': instance.width,
      'height': instance.height
    };
