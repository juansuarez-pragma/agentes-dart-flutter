import '../../domain/entities/weather.dart';

/// Modelo de datos para clima que maneja la serializacion JSON.
///
/// Soporta dos formatos de JSON:
/// - OpenWeatherMap API response (fromJson)
/// - Cache local simplificado (fromCacheJson/toJson)
class WeatherModel {
  const WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.iconCode,
    required this.timestamp,
  });

  /// Parsea respuesta de OpenWeatherMap API.
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>;
    final weatherList = json['weather'] as List<dynamic>;
    final weather = weatherList.first as Map<String, dynamic>;
    final dt = json['dt'] as int;

    return WeatherModel(
      cityName: json['name'] as String,
      temperature: (main['temp'] as num).toDouble(),
      humidity: (main['humidity'] as num).toDouble(),
      description: weather['description'] as String,
      iconCode: weather['icon'] as String,
      timestamp: DateTime.fromMillisecondsSinceEpoch(dt * 1000),
    );
  }

  /// Parsea desde formato de cache local.
  factory WeatherModel.fromCacheJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['cityName'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      description: json['description'] as String,
      iconCode: json['iconCode'] as String,
      timestamp:
          DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
    );
  }

  final String cityName;
  final double temperature;
  final double humidity;
  final String description;
  final String iconCode;
  final DateTime timestamp;

  /// Serializa a formato de cache local.
  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'humidity': humidity,
      'description': description,
      'iconCode': iconCode,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  /// Convierte a entidad de dominio.
  Weather toEntity() {
    return Weather(
      cityName: cityName,
      temperature: temperature,
      humidity: humidity,
      description: description,
      iconCode: iconCode,
      timestamp: timestamp,
    );
  }
}
