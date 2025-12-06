import 'dart:convert';

import '../models/weather_model.dart';

/// Interface para el datasource local de clima (cache).
abstract class WeatherLocalDataSource {
  /// Obtiene el clima cacheado para una clave.
  Future<WeatherModel?> getCachedWeather(String key);

  /// Guarda el clima en cache.
  Future<void> cacheWeather(String key, WeatherModel model);

  /// Verifica si el cache es valido segun el TTL.
  Future<bool> isCacheValid(String key, int ttlMs);

  /// Limpia todo el cache de clima.
  Future<void> clearCache();
}

/// Abstraccion para almacenamiento clave-valor.
///
/// Permite inyectar diferentes implementaciones (memoria, archivo, etc).
abstract class KeyValueStore {
  String? getString(String key);
  Future<void> setString(String key, String value);
  int? getInt(String key);
  Future<void> setInt(String key, int value);
  Set<String> getKeys();
  Future<void> remove(String key);
  Future<void> clear();
}

/// Implementacion en memoria del KeyValueStore.
///
/// Util para testing y para proyectos Dart puros.
class InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, dynamic> _store = {};

  @override
  String? getString(String key) => _store[key] as String?;

  @override
  Future<void> setString(String key, String value) async {
    _store[key] = value;
  }

  @override
  int? getInt(String key) => _store[key] as int?;

  @override
  Future<void> setInt(String key, int value) async {
    _store[key] = value;
  }

  @override
  Set<String> getKeys() => _store.keys.toSet();

  @override
  Future<void> remove(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }
}

/// Implementacion del datasource local usando KeyValueStore.
class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  WeatherLocalDataSourceImpl({required KeyValueStore store}) : _store = store;

  final KeyValueStore _store;

  static const _dataPrefix = 'weather_data_';
  static const _timePrefix = 'weather_time_';

  @override
  Future<WeatherModel?> getCachedWeather(String key) async {
    try {
      final jsonString = _store.getString('$_dataPrefix$key');
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return WeatherModel.fromCacheJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheWeather(String key, WeatherModel model) async {
    final jsonString = jsonEncode(model.toJson());
    final cacheTime = DateTime.now().millisecondsSinceEpoch;

    await _store.setString('$_dataPrefix$key', jsonString);
    await _store.setInt('$_timePrefix$key', cacheTime);
  }

  @override
  Future<bool> isCacheValid(String key, int ttlMs) async {
    final cacheTime = _store.getInt('$_timePrefix$key');
    if (cacheTime == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsed = now - cacheTime;

    return elapsed < ttlMs;
  }

  @override
  Future<void> clearCache() async {
    final keys = _store.getKeys();
    final weatherKeys = keys.where(
      (k) => k.startsWith(_dataPrefix) || k.startsWith(_timePrefix),
    );

    for (final key in weatherKeys.toList()) {
      await _store.remove(key);
    }
  }
}
