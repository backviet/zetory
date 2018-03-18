import 'package:meta/meta.dart';

import 'package:json_annotation/json_annotation.dart';
part 'media.g.dart';

@JsonSerializable()
class MediaEntity extends Object with _$MediaEntitySerializerMixin {
  MediaEntity({
    String type,
    @required this.showAt,
    @required this.image,
    @required this.width,
    @required this.height,
  }) : this.type = type ??  "photo";

  final String type;

  @JsonKey(name: 'show_at')
  final double showAt;

  final String image;

  final double width;

  final double height;

  factory MediaEntity.fromJson(Map<String, dynamic> json) => _$MediaEntityFromJson(json);

  @override
  String toString() {
    return '''
    type: ${type}, showAt: ${showAt}, image: ${image}, width: ${width}, , height: ${height}
    ''';
  }
}