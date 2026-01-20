import 'package:app_lecturador/data/data_sources/services/reporte_home_data_sources.dart';
import 'package:app_lecturador/domain/entities/reporte_entities.dart';
import 'package:app_lecturador/domain/reporsitories/reporte_home_repository.dart';

class ReporteHomeRepositoryImpl implements ReporteHomeRepository {
  final ReporteHomeRemoteDataSource remote;

  ReporteHomeRepositoryImpl(this.remote);

  @override
  Future<ReporteHomeEntity> getReporteHome() {
    return remote.getReporteHome();
  }
}
