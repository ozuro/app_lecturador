import 'package:app_lecturador/features/consumos/data/datasources/registro_consumo_remote_datasource.dart';
import 'package:app_lecturador/features/consumos/data/repositories/registro_consumo_repository_impl.dart';
import 'package:app_lecturador/features/consumos/domain/repositories/registro_consumo_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final registroconsumosRepositoryProvider =
    Provider<RegistroConsumoRepository>((ref) {
  final remote = RegistroConsumoRemoteDataSource();
  return RegistroConsumoRepositoryImpl(remote);
});
