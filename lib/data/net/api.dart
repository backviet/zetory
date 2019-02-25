import 'dart:async';
import 'package:zetory/data/entity/entity.dart';
import 'package:zetory/data/cache/album_cache.dart';
import 'connection.dart';
import 'dart:convert';

abstract class AbsNetApi<T> {
  Future<T> fetch();
}

class AlbumNetApi extends AbsNetApi<List<AlbumEntity>> {
  static const String kApiBaseUrl = "gist.githubusercontent.com";
  static const String kAlbumListUrl = "backviet/92342a9d8cb633061e64aa4ed6653808/raw/3842506330044a8235cf01036b37d1673346a801/albums.json";

  AlbumNetApi(this._cache) : _connection = new RestConnection();

  final RestConnection _connection;
  final AlbumCache _cache;

  @override
  Future<List<AlbumEntity>> fetch() async {
    print("url: ${kApiBaseUrl + "/" + kAlbumListUrl}");
    final String json = await _connection.getHttps(kApiBaseUrl, kAlbumListUrl, null);
    if (json == null) {
      return null;
    } else {
      Map<String, dynamic> albumsMap = jsonDecode(json);
      final List<AlbumEntity> albums = AlbumEntity.listFromJson(albumsMap);
      _cache.set(new List.from(albums));
      return albums;
    }
  }
}

class GithubUserApi extends AbsNetApi<GithubUserEntity> {
  static const _kGithubUrl = "https://api.github.com/users/backviet";

  GithubUserApi() : _connection = new RestConnection();

  final RestConnection _connection;

  @override
  Future<GithubUserEntity> fetch() async {
    final String json = await _connection.getURL(_kGithubUrl);
    print("GithubUserEntity: $json");
    if (json == null) {
      return null;
    } else {
      final map = jsonDecode(json);
      return GithubUserEntity.fromJson(map);
    }
  }
}
