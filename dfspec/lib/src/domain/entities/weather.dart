import 'package:equatable/equatable.dart';

/// Entidad que representa informacion meteorologica.
///
/// Esta clase es inmutable y utiliza Equatable para comparaciones
/// basadas en valor.
class Weather extends Equatable {
  const Weather({
    required this.cityName,
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.iconCode,
    required this.timestamp,
  });

  /// Nombre de la ciudad.
  final String cityName;

  /// Temperatura en grados Celsius.
  final double temperature;

  /// Humedad relativa en porcentaje (0-100).
  final double humidity;

  /// Descripcion textual del clima (ej: "cielo claro").
  final String description;

  /// Codigo del icono del clima (ej: "01d").
  final String iconCode;

  /// Momento de la medicion.
  final DateTime timestamp;

  @override
  List<Object?> get props => [
        cityName,
        temperature,
        humidity,
        description,
        iconCode,
        timestamp,
      ];
}
