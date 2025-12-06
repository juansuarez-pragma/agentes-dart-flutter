/// Constantes para la configuracion de la API de clima.
abstract class ApiConstants {
  /// URL base de OpenWeatherMap API.
  static const String baseUrl = 'api.openweathermap.org';

  /// Endpoint para obtener clima actual.
  static const String weatherEndpoint = '/data/2.5/weather';

  /// Timeout por defecto para peticiones HTTP en milisegundos.
  static const int defaultTimeoutMs = 3000;

  /// Tiempo de vida del cache en milisegundos (10 minutos).
  static const int cacheTtlMs = 600000;

  /// Unidades de medida (metric = Celsius).
  static const String defaultUnits = 'metric';

  /// Idioma por defecto para descripciones.
  static const String defaultLang = 'es';
}
