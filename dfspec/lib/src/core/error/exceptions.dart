/// Excepcion lanzada cuando el servidor retorna un error (4xx, 5xx).
class ServerException implements Exception {
  const ServerException([this.message = 'Error del servidor']);

  final String message;

  @override
  String toString() => 'ServerException: $message';
}

/// Excepcion lanzada cuando hay problemas de conexion de red.
class NetworkException implements Exception {
  const NetworkException([this.message = 'Error de conexion de red']);

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

/// Excepcion lanzada cuando hay errores con el cache local.
class CacheException implements Exception {
  const CacheException([this.message = 'Error de cache']);

  final String message;

  @override
  String toString() => 'CacheException: $message';
}
