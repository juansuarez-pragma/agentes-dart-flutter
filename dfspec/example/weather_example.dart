/// Ejemplo de uso del módulo Weather API.
///
/// Ejecutar con:
///   dart run example/weather_example.dart
///
/// Usa la API gratuita de Open-Meteo (no requiere API key).
library;

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dfspec/src/domain/entities/weather.dart';
import 'package:dfspec/src/data/datasources/weather_local_datasource.dart';

Future<void> main() async {
  final httpClient = http.Client();
  final cache = InMemoryKeyValueStore();

  print('=== Weather API Demo ===\n');
  print('Usando Open-Meteo API (gratuita, sin API key)\n');

  try {
    // Coordenadas de Madrid
    const lat = 40.4168;
    const lon = -3.7038;
    const city = 'Madrid';

    print('Consultando clima para $city (lat: $lat, lon: $lon)...\n');

    final weather = await fetchWeather(httpClient, lat, lon, city);

    print('Ciudad: ${weather.cityName}');
    print('Temperatura: ${weather.temperature.toStringAsFixed(1)}°C');
    print('Humedad: ${weather.humidity.toStringAsFixed(0)}%');
    print('Descripcion: ${weather.description}');
    print('Timestamp: ${weather.timestamp}');

    // Ejemplo con otra ciudad
    print('\n--- Consultando Barcelona ---\n');
    final weatherBcn = await fetchWeather(httpClient, 41.3851, 2.1734, 'Barcelona');
    print('Ciudad: ${weatherBcn.cityName}');
    print('Temperatura: ${weatherBcn.temperature.toStringAsFixed(1)}°C');
    print('Humedad: ${weatherBcn.humidity.toStringAsFixed(0)}%');

    print('\n=== Demo completada ===');
  } catch (e) {
    print('Error: $e');
  } finally {
    httpClient.close();
  }
}

/// Obtiene el clima usando Open-Meteo API (gratuita).
Future<Weather> fetchWeather(
  http.Client client,
  double lat,
  double lon,
  String cityName,
) async {
  final uri = Uri.https(
    'api.open-meteo.com',
    '/v1/forecast',
    {
      'latitude': lat.toString(),
      'longitude': lon.toString(),
      'current': 'temperature_2m,relative_humidity_2m,weather_code',
      'timezone': 'auto',
    },
  );

  final response = await client.get(uri);

  if (response.statusCode != 200) {
    throw Exception('Error del servidor: ${response.statusCode}');
  }

  final json = jsonDecode(response.body) as Map<String, dynamic>;
  final current = json['current'] as Map<String, dynamic>;

  return Weather(
    cityName: cityName,
    temperature: (current['temperature_2m'] as num).toDouble(),
    humidity: (current['relative_humidity_2m'] as num).toDouble(),
    description: _weatherCodeToDescription(current['weather_code'] as int),
    iconCode: _weatherCodeToIcon(current['weather_code'] as int),
    timestamp: DateTime.parse(current['time'] as String),
  );
}

String _weatherCodeToDescription(int code) {
  return switch (code) {
    0 => 'Cielo despejado',
    1 || 2 || 3 => 'Parcialmente nublado',
    45 || 48 => 'Niebla',
    51 || 53 || 55 => 'Llovizna',
    61 || 63 || 65 => 'Lluvia',
    71 || 73 || 75 => 'Nieve',
    80 || 81 || 82 => 'Chubascos',
    95 || 96 || 99 => 'Tormenta',
    _ => 'Desconocido',
  };
}

String _weatherCodeToIcon(int code) {
  return switch (code) {
    0 => '01d',
    1 || 2 || 3 => '02d',
    45 || 48 => '50d',
    51 || 53 || 55 || 61 || 63 || 65 => '09d',
    71 || 73 || 75 => '13d',
    80 || 81 || 82 => '10d',
    95 || 96 || 99 => '11d',
    _ => '03d',
  };
}
