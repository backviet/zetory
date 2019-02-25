// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumEntity _$AlbumEntityFromJson(Map<String, dynamic> json) {
  return AlbumEntity(
      name: json['name'] as String,
      caption: json['caption'] as String,
      icon: json['icon'] as String,
      created: (json['created'] as num)?.toDouble(),
      medias: (json['medias'] as List)
          ?.map((e) => e == null
              ? null
              : MediaEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$AlbumEntityToJson(AlbumEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'caption': instance.caption,
      'icon': instance.icon,
      'created': instance.created,
      'medias': instance.medias
    };
