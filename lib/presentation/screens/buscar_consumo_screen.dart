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
      color: const Color(0xFFF4F8FB),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFE3EBF3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF2FF),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.manage_search_rounded,
                        color: Color(0xFF0F4C81),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buscar lecturas por cliente',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Ingresa el DNI para revisar conexiones y el historial de lecturas disponible en la API.',
                            style: TextStyle(
                              height: 1.45,
                              color: Color(0xFF526074),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _dniController,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  decoration: InputDecoration(
                    hintText: 'Ingresa DNI',
                    prefixIcon: const Icon(Icons.badge_outlined),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _dniController.clear();
                        ref
                            .read(consumoNotifierProvider.notifier)
                            .clearSearch();
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: state.isSearching
                          ? null
                          : () {
                              if (_dniController.text.trim().length != 8) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('El DNI debe tener 8 digitos.'),
                                  ),
                                );
                                return;
                              }
                              ref
                                  .read(consumoNotifierProvider.notifier)
                                  .buscarPorDni(_dniController.text.trim());
                            },
                      icon: const Icon(Icons.search_rounded),
                      label: const Text('Buscar cliente'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        _dniController.clear();
                        ref
                            .read(consumoNotifierProvider.notifier)
                            .clearSearch();
                      },
                      icon: const Icon(Icons.restart_alt_rounded),
                      label: const Text('Limpiar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (state.isSearching)
            const Center(child: CircularProgressIndicator())
          else if (state.searchError != null)
            _SearchMessage(
              title: 'No se pudo completar la busqueda',
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
            ...result.conexiones.map(
              (conexion) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2EAF4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(8),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Conexion ${conexion.codigo ?? conexion.id}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                conexion.direccion.descripcionCorta,
                                style: const TextStyle(
                                  color: Color(0xFF526074),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Chip(label: Text(conexion.estadoLecturaLabel)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (conexion.consumos.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFD),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text(
                          'No hay lecturas registradas para esta conexion.',
                          style: TextStyle(
                            color: Color(0xFF526074),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
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
                                        color: Color(0xFF526074),
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
            ),
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
        border: Border.all(color: const Color(0xFFE2EAF4)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 26,
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
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'DNI: $dni',
                  style: const TextStyle(color: Color(0xFF526074)),
                ),
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
