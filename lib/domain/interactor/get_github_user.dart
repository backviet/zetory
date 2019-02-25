import 'dart:async';

import 'usecase.dart';
import 'package:zetory/domain/models/models.dart' show GithubUser;

import 'package:zetory/domain/repository/repository.dart' show AbsGithubUserRepository;

class GetGithubUser extends UseCase<GithubUser, Null> {

  GetGithubUser(this._repository);

  final AbsGithubUserRepository _repository;

  @override
  Future<GithubUser> buildUseCase(Null params) {
    return _repository.get();
  }
}