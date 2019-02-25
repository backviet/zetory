// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubUserEntity _$GithubUserEntityFromJson(Map<String, dynamic> json) {
  return GithubUserEntity(
      type: json['type'] as String,
      login: json['login'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      url: json['url'] as String,
      avatarUrl: json['avatar_url'] as String,
      blog: json['blog'] as String);
}

Map<String, dynamic> _$GithubUserEntityToJson(GithubUserEntity instance) =>
    <String, dynamic>{
      'type': instance.type,
      'login': instance.login,
      'name': instance.name,
      'url': instance.url,
      'avatar_url': instance.avatarUrl,
      'blog': instance.blog,
      'location': instance.location
    };
