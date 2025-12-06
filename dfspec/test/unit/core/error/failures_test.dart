import 'package:dfspec/src/core/error/failures.dart';
import 'package:test/test.dart';

void main() {
  group('Failures', () {
    group('ServerFailure', () {
      test('debe ser igual a otra instancia con mismo mensaje', () {
        const failure1 = ServerFailure('Error del servidor');
        const failure2 = ServerFailure('Error del servidor');

        expect(failure1, equals(failure2));
      });

      test('debe ser diferente a otra instancia con mensaje distinto', () {
        const failure1 = ServerFailure('Error 1');
        const failure2 = ServerFailure('Error 2');

        expect(failure1, isNot(equals(failure2)));
      });

      test('debe tener props correctos', () {
        const failure = ServerFailure('mensaje');

        expect(failure.props, ['mensaje']);
      });
    });

    group('NetworkFailure', () {
      test('debe ser igual a otra instancia con mismo mensaje', () {
        const failure1 = NetworkFailure('Sin conexion');
        const failure2 = NetworkFailure('Sin conexion');

        expect(failure1, equals(failure2));
      });

      test('debe tener mensaje por defecto', () {
        const failure = NetworkFailure();

        expect(failure.message, 'Error de conexion de red');
      });
    });

    group('CacheFailure', () {
      test('debe ser igual a otra instancia con mismo mensaje', () {
        const failure1 = CacheFailure('Error de cache');
        const failure2 = CacheFailure('Error de cache');

        expect(failure1, equals(failure2));
      });
    });

    group('CityNotFoundFailure', () {
      test('debe contener el nombre de la ciudad', () {
        const failure = CityNotFoundFailure('Madrid');

        expect(failure.cityName, 'Madrid');
        expect(failure.message, contains('Madrid'));
      });

      test('debe ser igual a otra instancia con misma ciudad', () {
        const failure1 = CityNotFoundFailure('Barcelona');
        const failure2 = CityNotFoundFailure('Barcelona');

        expect(failure1, equals(failure2));
      });
    });

    group('Failure base', () {
      test('diferentes tipos de failure no deben ser iguales', () {
        const serverFailure = ServerFailure('error');
        const networkFailure = NetworkFailure('error');

        expect(serverFailure, isNot(equals(networkFailure)));
      });
    });
  });
}
