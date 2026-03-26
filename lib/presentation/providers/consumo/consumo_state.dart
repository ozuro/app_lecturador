import 'package:app_lecturador/domain/entities/busqueda_cliente_entity.dart';
import 'package:app_lecturador/domain/entities/conexion_entities.dart';
import 'package:app_lecturador/domain/entities/direccion_entites.dart';

class ConsumoState {
  final bool isLoading;
  final List<Conexion> data;
  final List<Direccion> direcciones;
  final String? error;
  final String month;
  final int totalConexiones;
  final int lecturasRegistradas;
  final int lecturasFaltantes;
  final String? direccionId;
  final bool isSearching;
  final String? searchError;
  final BusquedaClienteEntity? searchResult;

  const ConsumoState({
    required this.isLoading,
    required this.data,
    required this.direcciones,
    this.error,
    required this.month,
    required this.totalConexiones,
    required this.lecturasRegistradas,
    required this.lecturasFaltantes,
    this.direccionId,
    required this.isSearching,
    this.searchError,
    this.searchResult,
  });

  factory ConsumoState.initial() {
    return const ConsumoState(
      isLoading: false,
      data: [],
      direcciones: [],
      error: null,
      month: '2026-03',
      totalConexiones: 0,
      lecturasRegistradas: 0,
      lecturasFaltantes: 0,
      direccionId: null,
      isSearching: false,
      searchError: null,
      searchResult: null,
    );
  }

  ConsumoState copyWith({
    bool? isLoading,
    List<Conexion>? data,
    List<Direccion>? direcciones,
    String? error,
    String? month,
    int? totalConexiones,
    int? lecturasRegistradas,
    int? lecturasFaltantes,
    String? direccionId,
    bool clearDireccionId = false,
    bool? isSearching,
    String? searchError,
    bool clearSearchError = false,
    BusquedaClienteEntity? searchResult,
    bool clearSearchResult = false,
  }) {
    return ConsumoState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      direcciones: direcciones ?? this.direcciones,
      error: error,
      month: month ?? this.month,
      totalConexiones: totalConexiones ?? this.totalConexiones,
      lecturasRegistradas: lecturasRegistradas ?? this.lecturasRegistradas,
      lecturasFaltantes: lecturasFaltantes ?? this.lecturasFaltantes,
      direccionId: clearDireccionId ? null : direccionId ?? this.direccionId,
      isSearching: isSearching ?? this.isSearching,
      searchError: clearSearchError ? null : searchError ?? this.searchError,
      searchResult:
          clearSearchResult ? null : searchResult ?? this.searchResult,
    );
  }
}
