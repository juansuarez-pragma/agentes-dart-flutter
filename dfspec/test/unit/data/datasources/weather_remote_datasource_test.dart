import 'dart:convert';
import 'dart:io';

import 'package:dfspec/src/core/error/exceptions.dart';
import 'package:dfspec/src/core/network/api_client.dart';
import 'package:dfspec/src/data/datasources/weather_remote_datasource.dart';
import 'package:dfspec/src/data/models/weather_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late WeatherRemoteDataSourceImpl dataSource;
  late MockApiClient mockApiClient;
  late Map<String, dynamic> jsonResponse;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = WeatherRemoteDataSourceImpl(
      apiClient: mockApiClient,
      apiKey: 'test_api_key',
    );

    final file = File('test/fixtures/weather_response.json');
    jsonResponse = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  });

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  group('WeatherRemoteDataSource', () {
    group('getWeatherByCity', () {
      test('debe retornar WeatherModel cuando la llamada es exitosa', () async {
        when(() => mockApiClient.get(any()))
            .thenAnswer((_) async => jsonResponse);

        final result = await dataSource.getWeatherByCity('Madrid');

        expect(result, isA<WeatherModel>());
        expect(result.cityName, 'Madrid');
      });

      test('debe llamar a la API con los parametros correctos', () async {
        when(() => mockApiClient.get(any()))
            .thenAnswer((_) async => jsonResponse);

        await dataSource.getWeatherByCity('Madrid');

        final captured =
            verify(() => mockApiClient.get(captureAny())).captured;
        final uri = captured.first as Uri;

        expect(uri.host, 'api.openweathermap.org');
        expect(uri.path, '/data/2.5/weather');
        expect(uri.queryParameters['q'], 'Madrid');
        expect(uri.queryParameters['appid'], 'test_api_key');
        expect(uri.queryParameters['units'], 'metric');
        expect(uri.queryParameters['lang'], 'es');
      });

      test('debe propagar ServerException del ApiClient', () async {
        when(() => mockApiClient.get(any()))
            .thenThrow(const ServerException('Not found'));

        expect(
          () => dataSource.getWeatherByCity('CiudadInexistente'),
          throwsA(isA<ServerException>()),
        );
      });

      test('debe propagar NetworkException del ApiClient', () async {
        when(() => mockApiClient.get(any()))
            .thenThrow(const NetworkException());

        expect(
          () => dataSource.getWeatherByCity('Madrid'),
          throwsA(isA<NetworkException>()),
        );
      });
    });

    group('getWeatherByCoordinates', () {
      test('debe retornar WeatherModel cuando la llamada es exitosa', () async {
        when(() => mockApiClient.get(any()))
            .thenAnswer((_) async => jsonResponse);

        final result =
            await dataSource.getWeatherByCoordinates(40.4168, -3.7038);

        expect(result, isA<WeatherModel>());
      });

      test('debe llamar a la API con lat/lon correctos', () async {
        when(() => mockApiClient.get(any()))
            .thenAnswer((_) async => jsonResponse);

        await dataSource.getWeatherByCoordinates(40.4168, -3.7038);

        final captured =
            verify(() => mockApiClient.get(captureAny())).captured;
        final uri = captured.first as Uri;

        expect(uri.queryParameters['lat'], '40.4168');
        expect(uri.queryParameters['lon'], '-3.7038');
        expect(uri.queryParameters['appid'], 'test_api_key');
      });
    });
  });
}
