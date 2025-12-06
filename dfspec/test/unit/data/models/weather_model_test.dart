import 'dart:convert';
import 'dart:io';

import 'package:dfspec/src/data/models/weather_model.dart';
import 'package:dfspec/src/domain/entities/weather.dart';
import 'package:test/test.dart';

void main() {
  group('WeatherModel', () {
    late Map<String, dynamic> jsonMap;

    setUp(() {
      final file = File('test/fixtures/weather_response.json');
      jsonMap = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    });

    group('fromJson', () {
      test('debe parsear correctamente respuesta de OpenWeatherMap', () {
        final model = WeatherModel.fromJson(jsonMap);

        expect(model.cityName, 'Madrid');
        expect(model.temperature, 25.5);
        expect(model.humidity, 60);
        expect(model.description, 'cielo claro');
        expect(model.iconCode, '01d');
        expect(
          model.timestamp,
          DateTime.fromMillisecondsSinceEpoch(1701864000 * 1000),
        );
      });

      test('debe manejar respuesta con multiples weather items', () {
        final jsonWithMultipleWeather = {
          'name': 'Barcelona',
          'main': {'temp': 20.0, 'humidity': 70},
          'weather': [
            {'description': 'lluvia ligera', 'icon': '10d'},
            {'description': 'nublado', 'icon': '04d'},
          ],
          'dt': 1701864000,
        };

        final model = WeatherModel.fromJson(jsonWithMultipleWeather);

        // Debe tomar el primer elemento
        expect(model.description, 'lluvia ligera');
        expect(model.iconCode, '10d');
      });

      test('debe manejar valores de temperatura como int', () {
        final jsonWithIntTemp = {
          'name': 'Sevilla',
          'main': {'temp': 30, 'humidity': 50},
          'weather': [
            {'description': 'soleado', 'icon': '01d'},
          ],
          'dt': 1701864000,
        };

        final model = WeatherModel.fromJson(jsonWithIntTemp);

        expect(model.temperature, 30.0);
      });
    });

    group('toJson', () {
      test('debe serializar correctamente para cache', () {
        final model = WeatherModel(
          cityName: 'Madrid',
          temperature: 25.5,
          humidity: 60,
          description: 'cielo claro',
          iconCode: '01d',
          timestamp: DateTime.fromMillisecondsSinceEpoch(1701864000 * 1000),
        );

        final json = model.toJson();

        expect(json['cityName'], 'Madrid');
        expect(json['temperature'], 25.5);
        expect(json['humidity'], 60);
        expect(json['description'], 'cielo claro');
        expect(json['iconCode'], '01d');
        expect(json['timestamp'], 1701864000 * 1000);
      });

      test('debe ser reversible con fromCacheJson', () {
        final original = WeatherModel(
          cityName: 'Valencia',
          temperature: 22.3,
          humidity: 55,
          description: 'parcialmente nublado',
          iconCode: '02d',
          timestamp: DateTime.fromMillisecondsSinceEpoch(1701864000 * 1000),
        );

        final json = original.toJson();
        final restored = WeatherModel.fromCacheJson(json);

        expect(restored.cityName, original.cityName);
        expect(restored.temperature, original.temperature);
        expect(restored.humidity, original.humidity);
        expect(restored.description, original.description);
        expect(restored.iconCode, original.iconCode);
        expect(restored.timestamp, original.timestamp);
      });
    });

    group('toEntity', () {
      test('debe convertir a Weather entity', () {
        final model = WeatherModel(
          cityName: 'Madrid',
          temperature: 25.5,
          humidity: 60,
          description: 'cielo claro',
          iconCode: '01d',
          timestamp: DateTime.fromMillisecondsSinceEpoch(1701864000 * 1000),
        );

        final entity = model.toEntity();

        expect(entity, isA<Weather>());
        expect(entity.cityName, 'Madrid');
        expect(entity.temperature, 25.5);
        expect(entity.humidity, 60);
        expect(entity.description, 'cielo claro');
        expect(entity.iconCode, '01d');
      });
    });
  });
}
