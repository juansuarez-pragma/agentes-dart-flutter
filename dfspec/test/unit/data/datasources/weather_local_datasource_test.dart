import 'package:dfspec/src/data/datasources/weather_local_datasource.dart';
import 'package:dfspec/src/data/models/weather_model.dart';
import 'package:test/test.dart';

void main() {
  late WeatherLocalDataSourceImpl dataSource;
  late InMemoryKeyValueStore store;

  final testModel = WeatherModel(
    cityName: 'Madrid',
    temperature: 25.5,
    humidity: 60,
    description: 'cielo claro',
    iconCode: '01d',
    timestamp: DateTime.fromMillisecondsSinceEpoch(1701864000 * 1000),
  );

  setUp(() {
    store = InMemoryKeyValueStore();
    dataSource = WeatherLocalDataSourceImpl(store: store);
  });

  group('WeatherLocalDataSource', () {
    group('cacheWeather', () {
      test('debe guardar el modelo en cache', () async {
        await dataSource.cacheWeather('madrid', testModel);

        final cached = await dataSource.getCachedWeather('madrid');

        expect(cached, isNotNull);
        expect(cached!.cityName, 'Madrid');
      });

      test('debe guardar timestamp de cache', () async {
        await dataSource.cacheWeather('madrid', testModel);

        final isValid = await dataSource.isCacheValid(
          'madrid',
          600000, // 10 min
        );

        expect(isValid, true);
      });
    });

    group('getCachedWeather', () {
      test('debe retornar null cuando no hay cache', () async {
        final result = await dataSource.getCachedWeather('barcelona');

        expect(result, isNull);
      });

      test('debe retornar WeatherModel cuando existe cache', () async {
        await dataSource.cacheWeather('madrid', testModel);

        final result = await dataSource.getCachedWeather('madrid');

        expect(result, isA<WeatherModel>());
        expect(result!.temperature, 25.5);
      });

      test('debe manejar cache corrupto retornando null', () async {
        // Guardamos datos corruptos directamente en el store
        await store.setString('weather_data_corrupted', 'not valid json');

        final result = await dataSource.getCachedWeather('corrupted');

        expect(result, isNull);
      });
    });

    group('isCacheValid', () {
      test('debe retornar false cuando no hay cache', () async {
        final isValid = await dataSource.isCacheValid('noexiste', 600000);

        expect(isValid, false);
      });

      test('debe retornar true cuando cache esta dentro del TTL', () async {
        await dataSource.cacheWeather('madrid', testModel);

        final isValid = await dataSource.isCacheValid('madrid', 600000);

        expect(isValid, true);
      });

      test('debe retornar false cuando cache expiro', () async {
        // Guardamos cache con timestamp antiguo (11+ minutos atras)
        final cacheTime =
            DateTime.now().millisecondsSinceEpoch - 700000; // 11+ min ago

        await store.setString(
          'weather_data_old',
          '{"cityName":"Madrid","temperature":25.5,"humidity":60,"description":"cielo claro","iconCode":"01d","timestamp":1701864000000}',
        );
        await store.setInt('weather_time_old', cacheTime);

        final isValid = await dataSource.isCacheValid('old', 600000);

        expect(isValid, false);
      });
    });

    group('clearCache', () {
      test('debe eliminar todo el cache de weather', () async {
        await dataSource.cacheWeather('madrid', testModel);
        await dataSource.cacheWeather('barcelona', testModel);

        await dataSource.clearCache();

        final madrid = await dataSource.getCachedWeather('madrid');
        final barcelona = await dataSource.getCachedWeather('barcelona');

        expect(madrid, isNull);
        expect(barcelona, isNull);
      });
    });
  });

  group('InMemoryKeyValueStore', () {
    test('debe almacenar y recuperar strings', () async {
      await store.setString('key', 'value');

      expect(store.getString('key'), 'value');
    });

    test('debe almacenar y recuperar ints', () async {
      await store.setInt('number', 42);

      expect(store.getInt('number'), 42);
    });

    test('debe retornar null para claves inexistentes', () {
      expect(store.getString('noexiste'), isNull);
      expect(store.getInt('noexiste'), isNull);
    });

    test('debe listar todas las claves', () async {
      await store.setString('a', '1');
      await store.setString('b', '2');

      expect(store.getKeys(), containsAll(['a', 'b']));
    });

    test('debe eliminar claves', () async {
      await store.setString('key', 'value');
      await store.remove('key');

      expect(store.getString('key'), isNull);
    });

    test('debe limpiar todo el store', () async {
      await store.setString('a', '1');
      await store.setString('b', '2');
      await store.clear();

      expect(store.getKeys(), isEmpty);
    });
  });
}
