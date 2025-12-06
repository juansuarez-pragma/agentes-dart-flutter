import '../entities/weather.dart';

/// Interface abstracta para el repositorio de clima.
///
/// Define el contrato que debe implementar cualquier fuente de datos
/// de clima, permitiendo desacoplar la capa de dominio de la de datos.
abstract class WeatherRepository {
  /// Obtiene el clima actual para una ciudad.
  ///
  /// [city] Nombre de la ciudad a consultar.
  /// Retorna un [Weather] con la informacion meteorologica.
  /// Puede lanzar excepciones si hay errores de red o la ciudad no existe.
  Future<Weather> getWeatherByCity(String city);

  /// Obtiene el clima actual para unas coordenadas geograficas.
  ///
  /// [latitude] Latitud en grados (-90 a 90).
  /// [longitude] Longitud en grados (-180 a 180).
  /// Retorna un [Weather] con la informacion meteorologica.
  Future<Weather> getWeatherByCoordinates(double latitude, double longitude);
}
