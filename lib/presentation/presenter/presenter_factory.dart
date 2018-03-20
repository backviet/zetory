import 'presenter.dart';
import 'package:zetory/data/data.dart';
import '../view_model/view_model.dart';
import 'package:zetory/domain/domain.dart' show GetAlbums;

class PresenterFactory {

  static final PresenterFactory _sInstance = new PresenterFactory._internal();

  factory PresenterFactory() {
    return _sInstance;
  }

  GetAlbumsPresenter _getAlbumsPresenter;

  PresenterFactory._internal();

  GetAlbumsPresenter getAlbumsPresenter({ProductFlavor productFlavor = ProductFlavor.mock}) {
    if (_getAlbumsPresenter == null) {
      _getAlbumsPresenter = new GetAlbumsPresenter(new GetAlbums(new AlbumDataRepository(productFlavor: productFlavor)), new ViewModelWrapperFactory().albumListWrapper);
    }

    return _getAlbumsPresenter;
  }
}