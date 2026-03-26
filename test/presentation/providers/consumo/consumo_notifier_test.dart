import 'package:app_lecturador/domain/entities/busqueda_cliente_entity.dart';
import 'package:app_lecturador/domain/entities/cliente_entities.dart';
import 'package:app_lecturador/domain/entities/conexion_entities.dart';
import 'package:app_lecturador/domain/entities/consumo_entities.dart';
import 'package:app_lecturador/domain/entities/direccion_entites.dart';
import 'package:app_lecturador/domain/entities/lecturas_resumen_entity.dart';
import 'package:app_lecturador/domain/reporsitories/consumo_repository.dart';
import 'package:app_lecturador/presentation/providers/consumo/consumo_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConsumoNotifier', () {
    test('carga consumos y actualiza el estado correctamente', () async {
      final repository = _FakeConsumosRepository(
        resumen: LecturasResumenEntity(
          month: '2026-03',
          total: 1,
          conLectura: 1,
          sinLectura: 0,
          direcciones: [
            Direccion(id: 1, nombre: 'Jajanra', distrito: 'Capachica'),
          ],
          conexiones: [
            Conexion(
              id: 1,
              codigo: '0001',
              medidor: true,
              cliente: Cliente(
                id: 1,
                tipoPersona: 'natural',
                nombres: 'Juan',
                apellidos: 'Perez',
                dni: '12345678',
              ),
              direccion: Direccion(
                id: 1,
                nombre: 'Jajanra',
                distrito: 'Capachica',
              ),
              tieneLecturaRegistrada: true,
            ),
          ],
        ),
      );

      final notifier = ConsumoNotifier(repository);

      await notifier.loadConsumos(year: '2026', month: '03');

      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.month, '2026-03');
      expect(notifier.state.totalConexiones, 1);
      expect(notifier.state.lecturasRegistradas, 1);
      expect(notifier.state.lecturasFaltantes, 0);
      expect(notifier.state.data, hasLength(1));
      expect(notifier.state.error, isNull);
    });

    test('guarda error en el estado si falla la carga de consumos', () async {
      final repository = _FakeConsumosRepository(
        loadError: Exception('fallo al cargar'),
      );

      final notifier = ConsumoNotifier(repository);

      await notifier.loadConsumos(year: '2026', month: '03');

      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.error, contains('fallo al cargar'));
    });

    test('buscarPorDni actualiza searchResult cuando la busqueda es exitosa', () async {
      final cliente = Cliente(
        id: 99,
        tipoPersona: 'juridica',
        razonSocial: 'COMISARIA PNP',
        ruc: '10406805714',
      );

      final repository = _FakeConsumosRepository(
        searchResult: BusquedaClienteEntity(
          cliente: cliente,
          conexiones: const [],
        ),
      );

      final notifier = ConsumoNotifier(repository);

      await notifier.buscarPorDni('10406805714');

      expect(notifier.state.isSearching, isFalse);
      expect(notifier.state.searchResult?.cliente.nombreCompleto, 'COMISARIA PNP');
      expect(notifier.state.searchError, isNull);
    });
  });
}

class _FakeConsumosRepository implements ConsumosRepository {
  _FakeConsumosRepository({
    this.resumen,
    this.searchResult,
    this.loadError,
    this.searchError,
  });

  final LecturasResumenEntity? resumen;
  final BusquedaClienteEntity? searchResult;
  final Exception? loadError;
  final Exception? searchError;

  @override
  Future<LecturasResumenEntity> getConexiones({
    required String month,
    String? direccionId,
  }) async {
    if (loadError != null) throw loadError!;
    return resumen!;
  }

  @override
  Future<BusquedaClienteEntity> buscarPorDni(String dni) async {
    if (searchError != null) throw searchError!;
    return searchResult!;
  }

  @override
  Future<List<Consumo>> getLecturasPorConexion(int conexionId) async {
    return const <Consumo>[];
  }
}
