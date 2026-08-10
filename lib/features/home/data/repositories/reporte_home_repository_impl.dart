import 'package:app_lecturador/features/home/data/datasources/reporte_home_remote_datasource.dart';
import 'package:app_lecturador/features/home/domain/entities/reporte_home.dart';
import 'package:app_lecturador/features/home/domain/repositories/reporte_home_repository.dart';

class ReporteHomeRepositoryImpl implements ReporteHomeRepository {
  final ReporteHomeRemoteDataSource remote;

  ReporteHomeRepositoryImpl(this.remote);

  @override
  Future<ReporteHomeEntity> getReporteHome() {
    return remote.getReporteHome();
  }
}
