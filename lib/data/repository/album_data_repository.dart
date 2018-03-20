import 'dart:async';

import 'data_source.dart' show AlbumDataStoreFactory;
import '../entity/entity.dart' show AlbumEntity, EtityWrapperFactory;
import 'package:zetory/domain/domain.dart'
    show AbsAlbumRepository, Album, ListWrapper;
import 'package:zetory/data/data.dart' show ProductFlavor;

class AlbumDataRepository extends AbsAlbumRepository {
  AlbumDataRepository({ProductFlavor productFlavor = ProductFlavor.mock})
      : this._productFlavor = productFlavor,
        _dataStoreFactory = new AlbumDataStoreFactory(),
        _entityWrapper = new EtityWrapperFactory().albumListWrapper;

  final ProductFlavor _productFlavor;
  final AlbumDataStoreFactory _dataStoreFactory;
  final ListWrapper<AlbumEntity, Album> _entityWrapper;

  @override
  Future<List<Album>> fetch() async {
    final List<AlbumEntity> albums =
        await (await _dataStoreFactory.create(flavor: _productFlavor)).get();
//    albums.forEach((a) => print("album: ${a.toString()}"));
    return _entityWrapper.transform(albums);
  }
}
