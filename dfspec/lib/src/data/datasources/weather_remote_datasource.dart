import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/weather_model.dart';

/// Interface para el datasource remoto de clima.
abstract class WeatherRemoteDataSource {
  /// Obtiene el clima de una ciudad desde la API.
  Future<WeatherModel> getWeatherByCity(String city);

  /// Obtiene el clima por coordenadas desde la API.
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon);
}

/// Implementacion del datasource remoto usando OpenWeatherMap API.
class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  WeatherRemoteDataSourceImpl({
    required ApiClient apiClient,
    required String apiKey,
  })  : _apiClient = apiClient,
        _apiKey = apiKey;

  final ApiClient _apiClient;
  final String _apiKey;

  @override
  Future<WeatherModel> getWeatherByCity(String city) async {
    final uri = _buildUri({'q': city});
    final response = await _apiClient.get(uri);
    return WeatherModel.fromJson(response);
  }

  @override
  Future<WeatherModel> getWeatherByCoordinates(double lat, double lon) async {
    final uri = _buildUri({
      'lat': lat.toString(),
      'lon': lon.toString(),
    });
    final response = await _apiClient.get(uri);
    return WeatherModel.fromJson(response);
  }

  Uri _buildUri(Map<String, String> queryParams) {
    return Uri.https(
      ApiConstants.baseUrl,
      ApiConstants.weatherEndpoint,
      {
        ...queryParams,
        'appid': _apiKey,
        'units': ApiConstants.defaultUnits,
        'lang': ApiConstants.defaultLang,
      },
    );
  }
}
