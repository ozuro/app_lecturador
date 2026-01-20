import 'package:app_lecturador/data/data_sources/services/reporte_home_data_sources.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lecturador/domain/reporsitories/reporte_home_repository.dart';
import 'package:app_lecturador/data/data_sources/repository/reporte_home_impl.dart';

final reporteHomeRepositoryProvider = Provider<ReporteHomeRepository>((ref) {
  final remote = ReporteHomeRemoteDataSource();
  return ReporteHomeRepositoryImpl(remote);
});
