import 'package:app_lecturador/features/home/data/datasources/reporte_home_remote_datasource.dart';
import 'package:app_lecturador/features/home/data/repositories/reporte_home_repository_impl.dart';
import 'package:app_lecturador/features/home/domain/repositories/reporte_home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reporteHomeRepositoryProvider = Provider<ReporteHomeRepository>((ref) {
  final remote = ReporteHomeRemoteDataSource();
  return ReporteHomeRepositoryImpl(remote);
});
