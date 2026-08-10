import 'package:app_lecturador/features/consumos/data/datasources/consumo_remote_datasource.dart';
import 'package:app_lecturador/features/consumos/data/repositories/consumo_repository_impl.dart';
import 'package:app_lecturador/features/consumos/domain/repositories/consumo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final consumosRepositoryProvider = Provider<ConsumosRepository>((ref) {
  final remoteDataSource = ConsumosRemoteDataSource();
  return ConsumosRepositoryImpl(remoteDataSource);
});
