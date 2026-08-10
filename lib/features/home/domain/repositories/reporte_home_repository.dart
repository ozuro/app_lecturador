import 'package:app_lecturador/features/home/domain/entities/reporte_home.dart';

abstract class ReporteHomeRepository {
  Future<ReporteHomeEntity> getReporteHome();
}
