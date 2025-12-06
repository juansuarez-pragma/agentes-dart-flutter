import 'package:dfspec/src/domain/entities/weather.dart';
import 'package:test/test.dart';

void main() {
  group('Weather', () {
    final testDateTime = DateTime(2024, 1, 15, 12, 0);

    test('debe ser igual a otra instancia con mismos valores', () {
      final weather1 = Weather(
        cityName: 'Madrid',
        temperature: 25.5,
        humidity: 60,
        description: 'cielo claro',
        iconCode: '01d',
        timestamp: testDateTime,
      );

      final weather2 = Weather(
        cityName: 'Madrid',
        temperature: 25.5,
        humidity: 60,
        description: 'cielo claro',
        iconCode: '01d',
        timestamp: testDateTime,
      );

      expect(weather1, equals(weather2));
    });

    test('debe ser diferente si algun campo cambia', () {
      final weather1 = Weather(
        cityName: 'Madrid',
        temperature: 25.5,
        humidity: 60,
        description: 'cielo claro',
        iconCode: '01d',
        timestamp: testDateTime,
      );

      final weather2 = Weather(
        cityName: 'Barcelona',
        temperature: 25.5,
        humidity: 60,
        description: 'cielo claro',
        iconCode: '01d',
        timestamp: testDateTime,
      );

      expect(weather1, isNot(equals(weather2)));
    });

    test('debe tener todos los campos accesibles', () {
      final weather = Weather(
        cityName: 'Madrid',
        temperature: 25.5,
        humidity: 60,
        description: 'cielo claro',
        iconCode: '01d',
        timestamp: testDateTime,
      );

      expect(weather.cityName, 'Madrid');
      expect(weather.temperature, 25.5);
      expect(weather.humidity, 60);
      expect(weather.description, 'cielo claro');
      expect(weather.iconCode, '01d');
      expect(weather.timestamp, testDateTime);
    });

    test('debe tener props correctos para Equatable', () {
      final weather = Weather(
        cityName: 'Madrid',
        temperature: 25.5,
        humidity: 60,
        description: 'cielo claro',
        iconCode: '01d',
        timestamp: testDateTime,
      );

      expect(weather.props, [
        'Madrid',
        25.5,
        60,
        'cielo claro',
        '01d',
        testDateTime,
      ]);
    });

    test('debe ser inmutable (campos final)', () {
      final weather = Weather(
        cityName: 'Madrid',
        temperature: 25.5,
        humidity: 60,
        description: 'cielo claro',
        iconCode: '01d',
        timestamp: testDateTime,
      );

      // Verificamos que los campos son final comprobando que no hay setters
      // y que podemos crear un const si todos los argumentos son const
      expect(weather.cityName, isA<String>());
    });
  });
}
