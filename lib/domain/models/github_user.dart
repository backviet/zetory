class GithubUser {
  const GithubUser({
    this.type,
    this.login,
    this.name,
    this.location,
    this.url,
    this.avatarUrl,
    this.blog,
  });

  final String type;
  final String login;
  final String name;
  final String url;
  final String avatarUrl;
  final String blog;
  final String location;
}
