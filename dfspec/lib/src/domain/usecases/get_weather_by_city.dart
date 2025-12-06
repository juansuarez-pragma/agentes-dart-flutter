import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

/// Caso de uso para obtener el clima de una ciudad.
///
/// Valida que el nombre de ciudad no este vacio antes de delegar
/// al repositorio.
class GetWeatherByCity {
  const GetWeatherByCity(this._repository);

  final WeatherRepository _repository;

  /// Ejecuta el caso de uso.
  ///
  /// [city] Nombre de la ciudad a consultar.
  /// Lanza [ArgumentError] si [city] esta vacio o contiene solo espacios.
  Future<Weather> call(String city) async {
    final trimmedCity = city.trim();

    if (trimmedCity.isEmpty) {
      throw ArgumentError('El nombre de la ciudad no puede estar vacio');
    }

    return _repository.getWeatherByCity(trimmedCity);
  }
}
