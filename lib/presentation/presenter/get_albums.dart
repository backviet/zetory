import 'presenter.dart';
import 'package:zetory/domain/domain.dart' show Album, ListWrapper, UseCase;
import 'package:zetory/presentation/view_model/view_model.dart' show AlbumInfo;

class GetAlbumsPresenter extends AbsLoaderPresenter<List<Album>, List<AlbumInfo>, Null> {

  GetAlbumsPresenter(this._useCase, ListWrapper<Album, AlbumInfo> wrapper)
      : assert(_useCase != null),
        super(wrapper);

  final UseCase<List<Album>, Null> _useCase;

  @override
  void onLoadStarted(Null params) {
    super.onLoadStarted(params);
    this._useCase.execute(onLoadSuccess, params, onError: onLoadError, onDispose: onLoadStop);
  }

  @override
  void onLoadStop() {
    super.onLoadStop();
    _useCase.dispose();
  }
}