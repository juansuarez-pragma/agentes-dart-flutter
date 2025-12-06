import 'package:dfspec/src/domain/entities/weather.dart';
import 'package:dfspec/src/domain/repositories/weather_repository.dart';
import 'package:dfspec/src/domain/usecases/get_weather_by_coordinates.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetWeatherByCoordinates useCase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetWeatherByCoordinates(mockRepository);
  });

  final testWeather = Weather(
    cityName: 'Madrid',
    temperature: 25.5,
    humidity: 60,
    description: 'cielo claro',
    iconCode: '01d',
    timestamp: DateTime(2024, 1, 15, 12, 0),
  );

  group('GetWeatherByCoordinates', () {
    test('debe retornar Weather con coordenadas validas', () async {
      when(() => mockRepository.getWeatherByCoordinates(40.4168, -3.7038))
          .thenAnswer((_) async => testWeather);

      final result = await useCase(latitude: 40.4168, longitude: -3.7038);

      expect(result, testWeather);
      verify(() => mockRepository.getWeatherByCoordinates(40.4168, -3.7038))
          .called(1);
    });

    test('debe lanzar ArgumentError cuando latitud es menor a -90', () async {
      expect(
        () => useCase(latitude: -91, longitude: 0),
        throwsA(isA<ArgumentError>()),
      );

      verifyNever(
        () => mockRepository.getWeatherByCoordinates(any(), any()),
      );
    });

    test('debe lanzar ArgumentError cuando latitud es mayor a 90', () async {
      expect(
        () => useCase(latitude: 91, longitude: 0),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('debe lanzar ArgumentError cuando longitud es menor a -180', () async {
      expect(
        () => useCase(latitude: 0, longitude: -181),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('debe lanzar ArgumentError cuando longitud es mayor a 180', () async {
      expect(
        () => useCase(latitude: 0, longitude: 181),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('debe aceptar coordenadas en los limites', () async {
      when(() => mockRepository.getWeatherByCoordinates(90, 180))
          .thenAnswer((_) async => testWeather);
      when(() => mockRepository.getWeatherByCoordinates(-90, -180))
          .thenAnswer((_) async => testWeather);

      await useCase(latitude: 90, longitude: 180);
      await useCase(latitude: -90, longitude: -180);

      verify(() => mockRepository.getWeatherByCoordinates(90, 180)).called(1);
      verify(() => mockRepository.getWeatherByCoordinates(-90, -180)).called(1);
    });

    test('debe propagar excepciones del repositorio', () async {
      when(() => mockRepository.getWeatherByCoordinates(40.4168, -3.7038))
          .thenThrow(Exception('Error'));

      expect(
        () => useCase(latitude: 40.4168, longitude: -3.7038),
        throwsA(isA<Exception>()),
      );
    });
  });
}
