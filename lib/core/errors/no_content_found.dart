///* Exception for HTTP Code [204]
class NoContentFoundException implements Exception {
  @override
  String toString() {
    return "NoContentFoundException";
  }
}
