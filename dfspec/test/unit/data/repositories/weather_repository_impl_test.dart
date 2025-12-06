import 'package:dfspec/src/core/constants/api_constants.dart';
import 'package:dfspec/src/core/error/exceptions.dart';
import 'package:dfspec/src/core/error/failures.dart';
import 'package:dfspec/src/data/datasources/weather_local_datasource.dart';
import 'package:dfspec/src/data/datasources/weather_remote_datasource.dart';
import 'package:dfspec/src/data/models/weather_model.dart';
import 'package:dfspec/src/data/repositories/weather_repository_impl.dart';
import 'package:dfspec/src/domain/entities/weather.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockWeatherRemoteDataSource extends Mock
    implements WeatherRemoteDataSource {}

class MockWeatherLocalDataSource extends Mock
    implements WeatherLocalDataSource {}

void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherRemoteDataSource mockRemoteDataSource;
  late MockWeatherLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockWeatherRemoteDataSource();
    mockLocalDataSource = MockWeatherLocalDataSource();
    repository = WeatherRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final testModel = WeatherModel(
    cityName: 'Madrid',
    temperature: 25.5,
    humidity: 60,
    description: 'cielo claro',
    iconCode: '01d',
    timestamp: DateTime.fromMillisecondsSinceEpoch(1701864000 * 1000),
  );

  group('WeatherRepositoryImpl', () {
    group('getWeatherByCity', () {
      test('debe retornar cache cuando es valido', () async {
        when(() => mockLocalDataSource.isCacheValid('madrid', any()))
            .thenAnswer((_) async => true);
        when(() => mockLocalDataSource.getCachedWeather('madrid'))
            .thenAnswer((_) async => testModel);

        final result = await repository.getWeatherByCity('Madrid');

        expect(result, isA<Weather>());
        expect(result.cityName, 'Madrid');
        verify(() => mockLocalDataSource.isCacheValid('madrid', any()))
            .called(1);
        verify(() => mockLocalDataSource.getCachedWeather('madrid')).called(1);
        verifyNever(() => mockRemoteDataSource.getWeatherByCity(any()));
      });

      test('debe llamar API cuando cache expira', () async {
        when(() => mockLocalDataSource.isCacheValid('madrid', any()))
            .thenAnswer((_) async => false);
        when(() => mockRemoteDataSource.getWeatherByCity('Madrid'))
            .thenAnswer((_) async => testModel);
        when(() => mockLocalDataSource.cacheWeather('madrid', testModel))
            .thenAnswer((_) async {});

        final result = await repository.getWeatherByCity('Madrid');

        expect(result, isA<Weather>());
        verify(() => mockRemoteDataSource.getWeatherByCity('Madrid')).called(1);
        verify(() => mockLocalDataSource.cacheWeather('madrid', testModel))
            .called(1);
      });

      test('debe lanzar ServerFailure cuando API falla con ServerException',
          () async {
        when(() => mockLocalDataSource.isCacheValid('madrid', any()))
            .thenAnswer((_) async => false);
        when(() => mockRemoteDataSource.getWeatherByCity('Madrid'))
            .thenThrow(const ServerException('Not found'));

        expect(
          () => repository.getWeatherByCity('Madrid'),
          throwsA(isA<ServerFailure>()),
        );
      });

      test('debe lanzar NetworkFailure cuando hay error de red', () async {
        when(() => mockLocalDataSource.isCacheValid('madrid', any()))
            .thenAnswer((_) async => false);
        when(() => mockRemoteDataSource.getWeatherByCity('Madrid'))
            .thenThrow(const NetworkException());

        expect(
          () => repository.getWeatherByCity('Madrid'),
          throwsA(isA<NetworkFailure>()),
        );
      });

      test('debe lanzar CityNotFoundFailure para error 404', () async {
        when(() => mockLocalDataSource.isCacheValid('noexiste', any()))
            .thenAnswer((_) async => false);
        when(() => mockRemoteDataSource.getWeatherByCity('NoExiste'))
            .thenThrow(const ServerException('Recurso no encontrado'));

        expect(
          () => repository.getWeatherByCity('NoExiste'),
          throwsA(isA<CityNotFoundFailure>()),
        );
      });

      test('debe usar clave en minusculas para cache', () async {
        when(() => mockLocalDataSource.isCacheValid('madrid', any()))
            .thenAnswer((_) async => true);
        when(() => mockLocalDataSource.getCachedWeather('madrid'))
            .thenAnswer((_) async => testModel);

        await repository.getWeatherByCity('MADRID');

        verify(() => mockLocalDataSource.isCacheValid('madrid', any()))
            .called(1);
      });
    });

    group('getWeatherByCoordinates', () {
      const lat = 40.4168;
      const lon = -3.7038;
      final cacheKey = '${lat}_$lon';

      test('debe retornar cache cuando es valido', () async {
        when(() => mockLocalDataSource.isCacheValid(cacheKey, any()))
            .thenAnswer((_) async => true);
        when(() => mockLocalDataSource.getCachedWeather(cacheKey))
            .thenAnswer((_) async => testModel);

        final result = await repository.getWeatherByCoordinates(lat, lon);

        expect(result, isA<Weather>());
        verifyNever(
          () => mockRemoteDataSource.getWeatherByCoordinates(any(), any()),
        );
      });

      test('debe llamar API cuando cache no es valido', () async {
        when(() => mockLocalDataSource.isCacheValid(cacheKey, any()))
            .thenAnswer((_) async => false);
        when(() => mockRemoteDataSource.getWeatherByCoordinates(lat, lon))
            .thenAnswer((_) async => testModel);
        when(() => mockLocalDataSource.cacheWeather(cacheKey, testModel))
            .thenAnswer((_) async {});

        final result = await repository.getWeatherByCoordinates(lat, lon);

        expect(result, isA<Weather>());
        verify(() => mockRemoteDataSource.getWeatherByCoordinates(lat, lon))
            .called(1);
      });

      test('debe lanzar NetworkFailure cuando hay error de red', () async {
        when(() => mockLocalDataSource.isCacheValid(cacheKey, any()))
            .thenAnswer((_) async => false);
        when(() => mockRemoteDataSource.getWeatherByCoordinates(lat, lon))
            .thenThrow(const NetworkException());

        expect(
          () => repository.getWeatherByCoordinates(lat, lon),
          throwsA(isA<NetworkFailure>()),
        );
      });
    });
  });
}
