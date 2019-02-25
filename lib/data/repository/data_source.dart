import 'dart:async';

import 'package:zetory/data/entity/entity.dart';
import 'package:zetory/data/mock/albums_mock.dart';
import 'package:zetory/data/net/net.dart';
import 'package:zetory/data/cache/cache.dart';

enum ProductFlavor {
  mock, production
}

abstract class AbsAlbumDataStore {
  Future<List<AlbumEntity>> get();
}

class AlbumDataStoreFactory {
  static final AlbumDataStoreFactory _instance = new AlbumDataStoreFactory._internal();

  factory AlbumDataStoreFactory() {
    return _instance;
  }

  AlbumDataStoreFactory._internal() : _cache = new AlbumCacheImpl(new PreferenceManager());

  final AlbumCache _cache;

  Future<AbsAlbumDataStore> create({ProductFlavor flavor = ProductFlavor.mock}) async {
    if (flavor == ProductFlavor.mock) {
      return _createMockDataStore();
    } else {
      return _createNetDataStore();
    }
  }

  AbsAlbumDataStore _createMockDataStore() {
    return new AlbumMockDataStore(new AlbumMock());
  }

  Future<AbsAlbumDataStore> _createNetDataStore() async {
    AbsAlbumDataStore dataStore;

    if (!(await this._cache.isExpired())) {
      dataStore = new AlbumCacheDataStore(_cache);
    } else {
      final AlbumNetApi restApi = new AlbumNetApi(_cache);
      dataStore = new AlbumNetDataStore(restApi);
    }

    return dataStore;
  }

}

class AlbumMockDataStore extends AbsAlbumDataStore {

  AlbumMockDataStore(this._albumMock);

  final AlbumMock _albumMock;

  @override
  Future<List<AlbumEntity>> get() async {
    return await _albumMock.get();
  }
}

class AlbumCacheDataStore extends AbsAlbumDataStore {

  AlbumCacheDataStore(this._albumCache);

  final AlbumCache _albumCache;

  @override
  Future<List<AlbumEntity>> get() async {
    final List<AlbumEntity> albums = await _albumCache.get();
//    albums?.forEach((a) => print("album: ${a.toString()}"));
    return albums;
  }

}

class AlbumNetDataStore extends AbsAlbumDataStore {

  AlbumNetDataStore(this._albumNetApi);

  final AlbumNetApi _albumNetApi;

  @override
  Future<List<AlbumEntity>> get() async {
    return await _albumNetApi.fetch();
  }

}