import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/weather.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_datasource.dart';
import '../datasources/weather_remote_datasource.dart';
import '../models/weather_model.dart';

/// Implementacion del repositorio de clima.
///
/// Maneja la logica de cache y fallback a la API remota.
class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl({
    required WeatherRemoteDataSource remoteDataSource,
    required WeatherLocalDataSource localDataSource,
    int? cacheTtlMs,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _cacheTtlMs = cacheTtlMs ?? ApiConstants.cacheTtlMs;

  final WeatherRemoteDataSource _remoteDataSource;
  final WeatherLocalDataSource _localDataSource;
  final int _cacheTtlMs;

  @override
  Future<Weather> getWeatherByCity(String city) async {
    final cacheKey = city.toLowerCase();

    // Intentar cache primero
    if (await _localDataSource.isCacheValid(cacheKey, _cacheTtlMs)) {
      final cachedModel = await _localDataSource.getCachedWeather(cacheKey);
      if (cachedModel != null) {
        return cachedModel.toEntity();
      }
    }

    // Llamar a la API
    return _fetchAndCache(
      cacheKey: cacheKey,
      fetcher: () => _remoteDataSource.getWeatherByCity(city),
      cityName: city,
    );
  }

  @override
  Future<Weather> getWeatherByCoordinates(
    double latitude,
    double longitude,
  ) async {
    final cacheKey = '${latitude}_$longitude';

    // Intentar cache primero
    if (await _localDataSource.isCacheValid(cacheKey, _cacheTtlMs)) {
      final cachedModel = await _localDataSource.getCachedWeather(cacheKey);
      if (cachedModel != null) {
        return cachedModel.toEntity();
      }
    }

    // Llamar a la API
    return _fetchAndCache(
      cacheKey: cacheKey,
      fetcher: () =>
          _remoteDataSource.getWeatherByCoordinates(latitude, longitude),
    );
  }

  Future<Weather> _fetchAndCache({
    required String cacheKey,
    required Future<WeatherModel> Function() fetcher,
    String? cityName,
  }) async {
    try {
      final model = await fetcher();
      await _localDataSource.cacheWeather(cacheKey, model);
      return model.toEntity();
    } on ServerException catch (e) {
      if (e.message.contains('no encontrado') && cityName != null) {
        throw CityNotFoundFailure(cityName);
      }
      throw ServerFailure(e.message);
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    }
  }
}
