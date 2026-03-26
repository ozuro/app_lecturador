import 'package:app_lecturador/domain/entities/cliente_entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cliente', () {
    test('muestra nombre completo y DNI para persona natural', () {
      final cliente = Cliente.fromJson({
        'id': 1,
        'tipo_persona': 'natural',
        'nombres': 'Juan',
        'apellidos': 'Perez',
        'dni': '12345678',
      });

      expect(cliente.esJuridica, isFalse);
      expect(cliente.tipoPersonaLabel, 'Persona natural');
      expect(cliente.documentoLabel, 'DNI');
      expect(cliente.documentoPrincipal, '12345678');
      expect(cliente.nombreCompleto, 'Juan Perez');
    });

    test('muestra razon social y RUC para persona juridica', () {
      final cliente = Cliente.fromJson({
        'id': 2,
        'tipo_persona': 'juridica',
        'razon_social': 'COMISARIA PNP',
        'ruc': '10406805714',
      });

      expect(cliente.esJuridica, isTrue);
      expect(cliente.tipoPersonaLabel, 'Persona juridica');
      expect(cliente.documentoLabel, 'RUC');
      expect(cliente.documentoPrincipal, '10406805714');
      expect(cliente.nombreCompleto, 'COMISARIA PNP');
    });

    test('usa valores por defecto cuando faltan datos principales', () {
      final cliente = Cliente.fromJson({
        'tipo_persona': 'juridica',
      });

      expect(cliente.documentoPrincipal, '-');
      expect(cliente.nombreCompleto, 'Persona juridica');
    });
  });
}
