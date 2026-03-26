import 'package:app_lecturador/presentation/providers/consumo/consumo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuscarConsumoScreen extends ConsumerStatefulWidget {
  const BuscarConsumoScreen({super.key});

  @override
  ConsumerState<BuscarConsumoScreen> createState() =>
      _BuscarConsumoScreenState();
}

class _BuscarConsumoScreenState extends ConsumerState<BuscarConsumoScreen> {
  final _dniController = TextEditingController();

  @override
  void dispose() {
    _dniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(consumoNotifierProvider);
    final result = state.searchResult;

    return Container(
      color: const Color(0xFFF4F7FB),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buscar lecturas o consumos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa el DNI del cliente para ver sus conexiones y el historial de lecturas disponible en la API.',
                  style: TextStyle(height: 1.45, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _dniController,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  decoration: InputDecoration(
                    hintText: 'Ingrese DNI',
                    prefixIcon: const Icon(Icons.badge_outlined),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _dniController.clear();
                        ref.read(consumoNotifierProvider.notifier).clearSearch();
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: state.isSearching
                      ? null
                      : () {
                          if (_dniController.text.trim().length != 8) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('El DNI debe tener 8 dígitos.'),
                              ),
                            );
                            return;
                          }
                          ref
                              .read(consumoNotifierProvider.notifier)
                              .buscarPorDni(_dniController.text.trim());
                        },
                  icon: const Icon(Icons.search_rounded),
                  label: const Text('Buscar'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (state.isSearching)
            const Center(child: CircularProgressIndicator())
          else if (state.searchError != null)
            _SearchMessage(
              title: 'No se pudo completar la búsqueda',
              description: state.searchError!,
              color: const Color(0xFFC44536),
            )
          else if (result != null) ...[
            _SearchHeader(
              fullName: result.cliente.nombreCompleto,
              dni: result.cliente.dni ?? '-',
              totalConnections: result.conexiones.length,
            ),
            const SizedBox(height: 16),
            ...result.conexiones.map((conexion) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Conexión ${conexion.codigo ?? conexion.id}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Chip(label: Text(conexion.estadoLecturaLabel)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        conexion.direccion.descripcionCorta,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 14),
                      if (conexion.consumos.isEmpty)
                        const Text('No hay lecturas registradas para esta conexión.')
                      else
                        ...conexion.consumos.map(
                          (consumo) => Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFD),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: const Color(0xFFE2EAF4)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Periodo ${consumo.mes ?? '-'}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Consumo: ${consumo.consumoActual ?? 0} | Recibo: ${consumo.estadoReciboLabel}',
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Chip(label: Text(consumo.estadoLecturaLabel)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.fullName,
    required this.dni,
    required this.totalConnections,
  });

  final String fullName;
  final String dni;
  final int totalConnections;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFEAF2FF),
            child: Icon(Icons.person_outline_rounded, color: Color(0xFF0F4C81)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text('DNI: $dni'),
              ],
            ),
          ),
          Chip(label: Text('$totalConnections conexiones')),
        ],
      ),
    );
  }
}

class _SearchMessage extends StatelessWidget {
  const _SearchMessage({
    required this.title,
    required this.description,
    required this.color,
  });

  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(90)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(description),
        ],
      ),
    );
  }
}
