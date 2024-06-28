class ApiException implements Exception {
  final String message;

  const ApiException(this.message);
}
