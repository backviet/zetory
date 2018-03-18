class FetchDataException implements Exception {
  FetchDataException(this._message);

  final String _message;

  @override
  String toString() {
    return "Exception: $_message";
  }
}