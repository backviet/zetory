import 'package:meta/meta.dart';

class GithubUserViewModel {
  const GithubUserViewModel({
    @required this.type,
    @required this.login,
    @required this.name,
    @required this.location,
    @required this.url,
    @required this.avatarUrl,
    @required this.blog,
  });

  final String type;
  final String login;
  final String name;
  final String url;
  final String avatarUrl;
  final String blog;
  final String location;
}

