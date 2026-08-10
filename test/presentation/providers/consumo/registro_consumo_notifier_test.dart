import 'package:app_lecturador/features/consumos/domain/repositories/registro_consumo_repository.dart';
import 'package:app_lecturador/features/consumos/presentation/providers/registro_consumo/registro_consumo_notifier.dart';
import 'package:app_lecturador/features/consumos/presentation/providers/registro_consumo/registro_consumo_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RegistroconsumoNotifier', () {
    test('cambia a registrado cuando el registro es exitoso', () async {
      final notifier = RegistroconsumoNotifier(_FakeRegistroRepository());

      await notifier.registroConsumo(1, '2026-03', 20, 0, null, false);

      expect(notifier.state.status, RegistroStatus.registrado);
      expect(notifier.state.errorMessage, isNull);
    });

    test('cambia a error cuando el repositorio falla', () async {
      final notifier = RegistroconsumoNotifier(
        _FakeRegistroRepository(error: Exception('error de registro')),
      );

      await notifier.registroConsumo(1, '2026-03', 20, 0, null, false);

      expect(notifier.state.status, RegistroStatus.error);
      expect(notifier.state.errorMessage, contains('error de registro'));
    });
  });
}

class _FakeRegistroRepository implements RegistroConsumoRepository {
  _FakeRegistroRepository({this.error});

  final Exception? error;

  @override
  Future<void> registroConsumo(
    int idconexion,
    String fecha,
    int consumoActual,
    int consumoAnterior,
    String? foto,
    bool habilitarLecturaAnterior,
  ) async {
    if (error != null) throw error!;
  }
}
