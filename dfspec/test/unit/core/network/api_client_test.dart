import 'dart:convert';

import 'package:dfspec/src/core/error/exceptions.dart';
import 'package:dfspec/src/core/network/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ApiClient apiClient;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    apiClient = ApiClient(client: mockHttpClient);
  });

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  group('ApiClient', () {
    group('get', () {
      test('debe retornar datos cuando la respuesta es 200', () async {
        final responseData = {'name': 'Madrid', 'temp': 25.0};
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response(jsonEncode(responseData), 200),
        );

        final result = await apiClient.get(
          Uri.parse('https://api.example.com/weather'),
        );

        expect(result, responseData);
        verify(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .called(1);
      });

      test('debe lanzar ServerException cuando la respuesta es 404', () async {
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('Not Found', 404),
        );

        expect(
          () => apiClient.get(Uri.parse('https://api.example.com/weather')),
          throwsA(isA<ServerException>()),
        );
      });

      test('debe lanzar ServerException cuando la respuesta es 500', () async {
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('Internal Server Error', 500),
        );

        expect(
          () => apiClient.get(Uri.parse('https://api.example.com/weather')),
          throwsA(isA<ServerException>()),
        );
      });

      test('debe lanzar NetworkException cuando hay error de conexion',
          () async {
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenThrow(Exception('Socket Exception'));

        expect(
          () => apiClient.get(Uri.parse('https://api.example.com/weather')),
          throwsA(isA<NetworkException>()),
        );
      });

      test('debe incluir headers por defecto', () async {
        when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
            .thenAnswer(
          (_) async => http.Response('{"data": "test"}', 200),
        );

        await apiClient.get(Uri.parse('https://api.example.com/weather'));

        final captured = verify(
          () => mockHttpClient.get(any(), headers: captureAny(named: 'headers')),
        ).captured;

        final headers = captured.first as Map<String, String>;
        expect(headers['Content-Type'], 'application/json');
        expect(headers['Accept'], 'application/json');
      });
    });
  });
}
