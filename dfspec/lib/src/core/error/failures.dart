import 'package:equatable/equatable.dart';

/// Clase base abstracta para representar fallos en la aplicacion.
///
/// Los Failures representan errores esperados que pueden ser manejados
/// por la capa de presentacion.
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Failure cuando el servidor retorna un error.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error del servidor']);
}

/// Failure cuando hay problemas de conexion de red.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Error de conexion de red']);
}

/// Failure cuando hay errores con el cache local.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error de cache']);
}

/// Failure cuando no se encuentra la ciudad solicitada.
class CityNotFoundFailure extends Failure {
  const CityNotFoundFailure(this.cityName)
      : super('No se encontro la ciudad: $cityName');

  final String cityName;

  @override
  List<Object?> get props => [cityName, message];
}
