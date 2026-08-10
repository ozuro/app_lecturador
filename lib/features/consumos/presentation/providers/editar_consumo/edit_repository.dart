import 'package:app_lecturador/features/consumos/data/datasources/edit_consumo_remote_datasource.dart';
import 'package:app_lecturador/features/consumos/data/repositories/edit_consumo_repository_impl.dart';
import 'package:app_lecturador/features/consumos/domain/repositories/edit_consumo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editRepositoryProvider = Provider<EditConsumoRepository>((ref) {
  final remoteDataSource = EditConsumoRemoteDataSource();
  return EditConsumoImpl(remoteDataSource);
});
