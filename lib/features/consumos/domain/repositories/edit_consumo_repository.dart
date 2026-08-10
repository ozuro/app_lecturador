abstract class EditConsumoRepository {
  Future<void> editConsumo(
      int? idConsumo,
      int idconexion,
      String fecha,
      int consumoActual,
      int consumoAnterior,
      String? foto,
      bool habilitarLecturaAnterior);
}
