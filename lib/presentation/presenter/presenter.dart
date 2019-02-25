export 'get_albums.dart';
export 'get_user_info.dart';
export 'presenter_factory.dart';

import 'package:zetory/domain/domain.dart' show AbsWrapper;

abstract class AbsPresenter {
  void resume() {}

  void pause() {}

  void destroy() {}
}

abstract class AbsLoader<Result, Params> {
  void onLoadStarted(Params params);

  void onLoadCompleted() {}

  void onLoadSuccess(Result result);

  void onLoadError(Exception e);

  void onLoadStop();
}

abstract class AbsLoaderPresenter<Result, PresentableResult, Params> extends AbsLoader<Result, Params> {

  AbsLoaderPresenter(this._wrapper): assert(_wrapper != null);

  final AbsWrapper<Result, PresentableResult> _wrapper;
  Result _result;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AbsLoader<PresentableResult, Params> uiView;

  void setUiView(AbsLoader<PresentableResult, Params> presenterView) {
    this.uiView = presenterView;
  }

  PresentableResult get presentableResult => _wrapper.transform(_result);

  @override
  void onLoadStarted(Params params) {
    _isLoading = true;
  }

  @override
  void onLoadSuccess(Result result) {
    _result = result;
    _isLoading = false;
    if (uiView != null) {
      uiView.onLoadSuccess(presentableResult);
    }
  }

  @override
  void onLoadCompleted() {
    _isLoading = false;
  }

  @override
  void onLoadError(Exception e) {
    _isLoading = false;
    uiView?.onLoadError(e);
  }

  @override
  void onLoadStop() {
    _isLoading = false;
    uiView?.onLoadStop();
  }
}