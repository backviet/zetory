import 'dart:async';
import '../entity/entity.dart';
import 'preference_manager.dart';

import 'dart:convert';

abstract class AlbumCache {
  Future<List<AlbumEntity>> get();

  Future<bool> set(List<AlbumEntity> albums);

  Future<bool> isCached();

  Future<bool> isExpired();

  Future<bool> clear();
}

class AlbumCacheImpl extends AlbumCache {
  static final String _kFileName = "com.backviet.zetory.ALBUMS";
  static final String _kLastCache = "last_cache";

  static final int _kExpirationTime = 60 * 10 * 1000;

  AlbumCacheImpl(this._preferenceManager);

  final PreferenceManager _preferenceManager;

  Map<String, dynamic> _albumsMap;

  @override
  Future<bool> clear() async {
    return await _preferenceManager.delete(_kFileName);
  }

  @override
  Future<List<AlbumEntity>> get() async {
    final String json = await _preferenceManager.read(_kFileName);
    if (json == null) {
      return null;
    }
    Map<String, dynamic> albumsMap = jsonDecode(json);
    _albumsMap = new Map.from(albumsMap);
    return AlbumEntity.listFromJson(albumsMap);
  }

  @override
  Future<bool> set(List<AlbumEntity> albums) async {
    if (albums == null) {
      return false;
    }
    _albumsMap = {'albums': albums, _kLastCache: new DateTime.now().millisecondsSinceEpoch};
    final String json = jsonEncode(_albumsMap);
    return await _preferenceManager.write(_kFileName, json);
  }

  bool _isExpired(int lastCache) {
    return (lastCache == null || lastCache < new DateTime.now().millisecondsSinceEpoch - _kExpirationTime);
  }

  @override
  Future<bool> isExpired() async {
    if (await isCached()) {
      return _isExpired((_albumsMap[_kLastCache] as num));
    }

    return true;
  }

  @override
  Future<bool> isCached() async {
    if (_albumsMap == null) {
      await get();
    }
    final bool fileExists = await _preferenceManager.fileExist(_kFileName);
    final bool isCached = _albumsMap != null && fileExists;

    return isCached;
  }

}
