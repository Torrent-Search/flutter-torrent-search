class NoContentFoundException implements Exception{
  String _message = "No Content Found";
  NoContentFoundException();

  @override
  String toString() {
    return _message;
  }
}