import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

/// Caso de uso para obtener el clima por coordenadas geograficas.
///
/// Valida que las coordenadas esten dentro de los rangos validos:
/// - Latitud: [-90, 90]
/// - Longitud: [-180, 180]
class GetWeatherByCoordinates {
  const GetWeatherByCoordinates(this._repository);

  final WeatherRepository _repository;

  /// Ejecuta el caso de uso.
  ///
  /// [latitude] Latitud en grados decimales.
  /// [longitude] Longitud en grados decimales.
  /// Lanza [ArgumentError] si las coordenadas estan fuera de rango.
  Future<Weather> call({
    required double latitude,
    required double longitude,
  }) async {
    _validateCoordinates(latitude, longitude);

    return _repository.getWeatherByCoordinates(latitude, longitude);
  }

  void _validateCoordinates(double latitude, double longitude) {
    if (latitude < -90 || latitude > 90) {
      throw ArgumentError(
        'La latitud debe estar entre -90 y 90 grados. Valor recibido: $latitude',
      );
    }

    if (longitude < -180 || longitude > 180) {
      throw ArgumentError(
        'La longitud debe estar entre -180 y 180 grados. Valor recibido: $longitude',
      );
    }
  }
}
