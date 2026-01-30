import 'package:app_lecturador/data/data_sources/repository/edit_consumo_impl.dart';
import 'package:app_lecturador/data/data_sources/services/edit_consumo_data_sources.dart';
import 'package:app_lecturador/domain/reporsitories/edit_consumo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editRepositoryProvider = Provider<EditConsumoRepository>((ref) {
  final remoteDataSource = EditConsumoRemoteDataSource();
  return EditConsumoImpl(remoteDataSource);
});
