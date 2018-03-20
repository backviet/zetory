import 'dart:async';
import '../entity/entity.dart';
import '../cache/album_cache.dart';
import 'connection.dart';
import 'dart:convert';

final String kApiBaseUrl = "gist.githubusercontent.com";
final String kAlbumListUrl = "backviet/92342a9d8cb633061e64aa4ed6653808/raw/2e25245dc88b5555d711788a261b887a32590094/albums.json";

abstract class AbsNetApi<T> {
  Future<T> fetch();
}

class AlbumNetApi extends AbsNetApi<List<AlbumEntity>> {

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
      Map<String, dynamic> albumsMap = JSON.decode(json);
      final List<AlbumEntity> albums = AlbumEntity.listFromJson(albumsMap);
      _cache.set(new List.from(albums));
      return albums;
    }
  }

}
