import 'package:app_lecturador/data/data_sources/services/consumo_remote_data_sources.dart';
import 'package:app_lecturador/data/data_sources/repository/consumo_repositoy_impl.dart';
import 'package:app_lecturador/domain/reporsitories/consumo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final consumosRepositoryProvider = Provider<ConsumosRepository>((ref) {
  final remoteDataSource = ConsumosRemoteDataSource();
  return ConsumosRepositoryImpl(remoteDataSource);
});
