import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/consumo_repository.dart';
import '../model/consumo.dart';

final consumoDetalleProvider = FutureProvider.family<Consumo, int>((ref, id) {
  return ref.read(consumoRepositoryProvider).getConsumoById(id);
});
