import 'package:app_lecturador/domain/entities/reporte_entities.dart';

abstract class ReporteHomeRepository {
  Future<ReporteHomeEntity> getReporteHome();
}
