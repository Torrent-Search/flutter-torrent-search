///* Exception for HTTP Code [500]
class InternalServerError implements Exception {
  @override
  String toString() {
    return "InternalServerError";
  }
}
