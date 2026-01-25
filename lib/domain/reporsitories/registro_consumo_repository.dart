abstract class RegistroConsumoRepository {
  Future<void> registroConsumo(int idconexion, String fecha, int consumoActual,
      int consumoAnterior, String? foto, bool habilitarLecturaAnterior);
}
