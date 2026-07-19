import 'package:app_lecturador/domain/entities/cliente_entities.dart';
import 'package:app_lecturador/domain/entities/conexion_entities.dart';
import 'package:app_lecturador/domain/entities/direccion_entites.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Direccion', () {
    test('parsea coordenadas desde ubicacion en formato texto', () {
      final direccion = Direccion.fromJson({
        'id': 1,
        'nombre': 'JAJANRA',
        'ubicacion': '-15.643634,-69.830829',
      });

      expect(direccion.latitud, -15.643634);
      expect(direccion.longitud, -69.830829);
      expect(direccion.tieneCoordenadas, isTrue);
    });

    test('ignora ubicacion nula como texto', () {
      final direccion = Direccion.fromJson({
        'id': 1,
        'nombre': 'JAJANRA',
        'ubicacion': 'NULL',
      });

      expect(direccion.latitud, isNull);
      expect(direccion.longitud, isNull);
      expect(direccion.tieneCoordenadas, isFalse);
    });
  });

  group('Conexion', () {
    test('traslada ubicacion de la conexion hacia la direccion', () {
      final conexion = Conexion.fromJson({
        'conexion_id': 2,
        'codigo': '0002',
        'estado': 'activa',
        'medidor': 1,
        'ubicacion': '-15.643634,-69.830829',
        'cliente': {
          'id': 1,
          'tipo_persona': 'natural',
          'nombres': 'ALVARO',
          'apellidos': 'lerma',
        },
        'direccion': {
          'id': 1,
          'nombre': 'JAJANRA',
          'distrito': 'CAPACHICA',
        },
      });

      expect(conexion.cliente, isA<Cliente>());
      expect(conexion.direccion.latitud, -15.643634);
      expect(conexion.direccion.longitud, -69.830829);
      expect(conexion.direccion.tieneCoordenadas, isTrue);
    });
  });
}
