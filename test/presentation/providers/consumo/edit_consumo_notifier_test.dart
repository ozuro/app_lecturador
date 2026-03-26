import 'package:app_lecturador/domain/reporsitories/edit_consumo_repository.dart';
import 'package:app_lecturador/presentation/providers/consumo/editar_consumo/edit_notifier.dart';
import 'package:app_lecturador/presentation/providers/consumo/editar_consumo/edit_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EditConsumoNotifier', () {
    test('cambia a actualizado cuando la edicion es exitosa', () async {
      final notifier = EditConsumoNotifier(_FakeEditRepository());

      await notifier.editConsumo(10, 1, '2026-03', 25, 0, null, false);

      expect(notifier.state.status, EditStatus.actualizado);
      expect(notifier.state.errorMessage, isNull);
    });

    test('cambia a error cuando la edicion falla', () async {
      final notifier = EditConsumoNotifier(
        _FakeEditRepository(error: Exception('error al editar')),
      );

      await notifier.editConsumo(10, 1, '2026-03', 25, 0, null, false);

      expect(notifier.state.status, EditStatus.error);
      expect(notifier.state.errorMessage, contains('error al editar'));
    });
  });
}

class _FakeEditRepository implements EditConsumoRepository {
  _FakeEditRepository({this.error});

  final Exception? error;

  @override
  Future<void> editConsumo(
    int? idConsumo,
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
