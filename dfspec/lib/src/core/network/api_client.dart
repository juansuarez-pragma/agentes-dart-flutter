import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../error/exceptions.dart';

/// Cliente HTTP base para realizar peticiones a APIs externas.
///
/// Encapsula la logica comun de peticiones HTTP incluyendo:
/// - Headers por defecto
/// - Timeout configurable
/// - Manejo de errores HTTP
class ApiClient {
  ApiClient({
    http.Client? client,
    this.timeoutMs = ApiConstants.defaultTimeoutMs,
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final int timeoutMs;

  static const _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Realiza una peticion GET a la URL especificada.
  ///
  /// Retorna el cuerpo de la respuesta decodificado como Map.
  /// Lanza [ServerException] si el servidor retorna un error (4xx, 5xx).
  /// Lanza [NetworkException] si hay problemas de conexion.
  Future<Map<String, dynamic>> get(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    try {
      final mergedHeaders = {..._defaultHeaders, ...?headers};

      final response = await _client
          .get(url, headers: mergedHeaders)
          .timeout(Duration(milliseconds: timeoutMs));

      return _handleResponse(response);
    } on ServerException {
      rethrow;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw NetworkException('Error de conexion: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 404) {
      throw const ServerException('Recurso no encontrado');
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw ServerException('Error del cliente: ${response.statusCode}');
    } else {
      throw ServerException('Error del servidor: ${response.statusCode}');
    }
  }
}
