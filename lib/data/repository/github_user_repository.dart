import 'dart:async';

import 'package:zetory/data/entity/entity.dart' show GithubUserEntity, EntityWrapperFactory, GithubUserWrapper;
import 'package:zetory/domain/domain.dart' show AbsGithubUserRepository, GithubUser;
import 'package:zetory/data/net/net.dart' show GithubUserApi;

class GithubUserRepository extends AbsGithubUserRepository {
  GithubUserRepository()
      : this._api = GithubUserApi(),
        this._entityWrapper = EntityWrapperFactory().githubUserWrapper;

  final GithubUserWrapper _entityWrapper;
  final GithubUserApi _api;

  @override
  Future<GithubUser> get() async {
    final entity = await _api.fetch();
    return _entityWrapper.transform(entity);
  }
}
