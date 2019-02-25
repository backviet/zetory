import 'presenter.dart';
import 'package:zetory/domain/domain.dart' show GithubUser, UseCase;
import 'package:zetory/presentation/view_model/view_model.dart' show GithubUserViewModel, GithubUserWrapper;

class GetUserInfoPresenter extends AbsLoaderPresenter<GithubUser, GithubUserViewModel, Null> {
  GetUserInfoPresenter(this._useCase, GithubUserWrapper wrapper)
      : assert(_useCase != null),
        super(wrapper);

  final UseCase<GithubUser, Null> _useCase;

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
