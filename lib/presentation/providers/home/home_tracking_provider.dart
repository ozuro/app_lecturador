import 'package:app_lecturador/domain/entities/conexion_entities.dart';
import 'package:app_lecturador/presentation/providers/consumo/consumo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTrackingSummary {
  const HomeTrackingSummary({
    required this.months,
  });

  final List<MonthTrackingStatus> months;

  bool get isUpToDate => months.every((month) => month.pendingCount == 0);

  int get totalPending => months.fold(
        0,
        (total, month) => total + month.pendingCount,
      );
}

class MonthTrackingStatus {
  const MonthTrackingStatus({
    required this.monthKey,
    required this.monthLabel,
    required this.pendingCount,
    required this.totalCount,
    required this.pendingConnections,
  });

  final String monthKey;
  final String monthLabel;
  final int pendingCount;
  final int totalCount;
  final List<Conexion> pendingConnections;

  bool get isUpToDate => pendingCount == 0;
}

final homeTrackingProvider = FutureProvider<HomeTrackingSummary>((ref) async {
  final repository = ref.watch(consumosRepositoryProvider);
  final now = DateTime.now();

  final monthDates = List.generate(
    3,
    (index) => DateTime(now.year, now.month - index, 1),
  );

  final months = await Future.wait(
    monthDates.map((date) async {
      final monthKey = '${date.year}-${date.month.toString().padLeft(2, '0')}';
      final result = await repository.getConexiones(month: monthKey);
      final pendingConnections = result.conexiones
          .where((conexion) => !conexion.tieneLecturaRegistrada)
          .toList();

      return MonthTrackingStatus(
        monthKey: monthKey,
        monthLabel: _monthLabel(date),
        pendingCount: pendingConnections.length,
        totalCount: result.total,
        pendingConnections: pendingConnections,
      );
    }),
  );

  return HomeTrackingSummary(months: months);
});

String _monthLabel(DateTime date) {
  const months = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];

  return '${months[date.month - 1]} ${date.year}';
}
