import 'package:json_annotation/json_annotation.dart';

part 'github_user.g.dart';

@JsonSerializable(nullable: false)
class GithubUserEntity {
  const GithubUserEntity({
    this.type,
    this.login,
    this.name,
    this.location,
    this.url,
    this.avatarUrl,
    this.blog,
  });

  final String type;
  final String login;
  final String name;
  final String url;
  final String avatarUrl;
  final String blog;
  final String location;

  factory GithubUserEntity.fromJson(Map<String, dynamic> json) => _$GithubUserEntityFromJson(json);
  Map<String, dynamic> toJson() => _$GithubUserEntityToJson(this);
}
