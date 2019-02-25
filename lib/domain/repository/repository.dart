import 'dart:async';
import 'package:zetory/domain/domain.dart' show Album, GithubUser;

abstract class AbsAlbumRepository {
  Future<List<Album>> fetch();
}

abstract class AbsGithubUserRepository {
  Future<GithubUser> get();
}