import 'package:app_lecturador/data/data_sources/repository/registro_consumo_repository_impl.dart';
import 'package:app_lecturador/data/data_sources/services/registro_consumo_data_sources.dart';
import 'package:app_lecturador/domain/reporsitories/registro_consumo_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final registroconsumosRepositoryProvider =
    Provider<RegistroConsumoRepository>((ref) {
  final remote = RegistroConsumoRemoteDataSource();
  return RegistroConsumoRepositoryImpl(remote);
});
