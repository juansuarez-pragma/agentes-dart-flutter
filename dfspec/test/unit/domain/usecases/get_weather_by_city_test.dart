import 'package:dfspec/src/domain/entities/weather.dart';
import 'package:dfspec/src/domain/repositories/weather_repository.dart';
import 'package:dfspec/src/domain/usecases/get_weather_by_city.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetWeatherByCity useCase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetWeatherByCity(mockRepository);
  });

  final testWeather = Weather(
    cityName: 'Madrid',
    temperature: 25.5,
    humidity: 60,
    description: 'cielo claro',
    iconCode: '01d',
    timestamp: DateTime(2024, 1, 15, 12, 0),
  );

  group('GetWeatherByCity', () {
    test('debe retornar Weather cuando ciudad es valida', () async {
      when(() => mockRepository.getWeatherByCity('Madrid'))
          .thenAnswer((_) async => testWeather);

      final result = await useCase('Madrid');

      expect(result, testWeather);
      verify(() => mockRepository.getWeatherByCity('Madrid')).called(1);
    });

    test('debe lanzar ArgumentError cuando ciudad esta vacia', () async {
      expect(
        () => useCase(''),
        throwsA(isA<ArgumentError>()),
      );

      verifyNever(() => mockRepository.getWeatherByCity(any()));
    });

    test('debe lanzar ArgumentError cuando ciudad es solo espacios', () async {
      expect(
        () => useCase('   '),
        throwsA(isA<ArgumentError>()),
      );

      verifyNever(() => mockRepository.getWeatherByCity(any()));
    });

    test('debe propagar excepciones del repositorio', () async {
      when(() => mockRepository.getWeatherByCity('Madrid'))
          .thenThrow(Exception('Error de servidor'));

      expect(
        () => useCase('Madrid'),
        throwsA(isA<Exception>()),
      );
    });

    test('debe hacer trim del nombre de ciudad', () async {
      when(() => mockRepository.getWeatherByCity('Madrid'))
          .thenAnswer((_) async => testWeather);

      await useCase('  Madrid  ');

      verify(() => mockRepository.getWeatherByCity('Madrid')).called(1);
    });
  });
}
