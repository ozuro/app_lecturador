import 'package:app_lecturador/presentation/providers/consumo/editar_consumo/edit_notifier.dart';
import 'package:app_lecturador/presentation/providers/consumo/editar_consumo/edit_provider.dart';
import 'package:app_lecturador/presentation/providers/consumo/editar_consumo/edit_state.dart';
import 'package:app_lecturador/presentation/providers/consumo/registro_consumo/registroConsumo_notifier.dart';
import 'package:app_lecturador/presentation/providers/consumo/registro_consumo/registroConsumo_provider.dart';
import 'package:app_lecturador/presentation/providers/consumo/registro_consumo/registroConsumo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditConsumoPage extends ConsumerStatefulWidget {
  final int consumoId;
  final int conexionId;

  const EditConsumoPage({
    super.key,
    required this.consumoId,
    required this.conexionId,
  });

  @override
  ConsumerState<EditConsumoPage> createState() => _EditConsumoPageState();
}

class _EditConsumoPageState extends ConsumerState<EditConsumoPage> {
  final _formKey = GlobalKey<FormState>();

  final _mesController = TextEditingController();
  final _consumoActualController = TextEditingController();

  bool _habilitarLecturaAnterior = false;
  String? _fotoBase64;

  @override
  void dispose() {
    _mesController.dispose();
    _consumoActualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editConsumoNotifierProvider);
    final notifier = ref.read(editConsumoNotifierProvider.notifier);

    ref.listen(editConsumoNotifierProvider, (previous, next) {
      if (next.status == EditStatus.actualizado) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Consumo actualizado correctamente')),
        );
        Navigator.pop(context);
      }

      if (next.status == EditStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Error desconocido')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Consumo'),
      ),
      body: AbsorbPointer(
        absorbing: state.status == EditStatus.loading,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildMesField(),
                const SizedBox(height: 16),
                _buildConsumoActualField(),
                const SizedBox(height: 16),
                _buildLecturaAnteriorSwitch(),
                const SizedBox(height: 24),
                _buildSubmitButton(state, notifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMesField() {
    return TextFormField(
      controller: _mesController,
      decoration: const InputDecoration(
        labelText: 'Mes (YYYY-MM)',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese el mes';
        }
        return null;
      },
    );
  }

  Widget _buildConsumoActualField() {
    return TextFormField(
      controller: _consumoActualController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Consumo Actual',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingrese el consumo actual';
        }
        if (int.tryParse(value) == null) {
          return 'Debe ser un número';
        }
        return null;
      },
    );
  }

  Widget _buildLecturaAnteriorSwitch() {
    return SwitchListTile(
      title: const Text('Habilitar lectura anterior'),
      value: _habilitarLecturaAnterior,
      onChanged: (value) {
        setState(() {
          _habilitarLecturaAnterior = value;
        });
      },
    );
  }

  Widget _buildSubmitButton(
    EditconsumoState state,
    EditConsumoNotifier notifier,
  ) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: state.status == EditStatus.loading
            ? null
            : () {
                if (!_formKey.currentState!.validate()) return;

                /// 🔒 Valores seguros (NUNCA null)
                final int consumoActual =
                    int.tryParse(_consumoActualController.text) ?? 0;

                final int lecturaAnterior = _habilitarLecturaAnterior ? 0 : 0;
                // si luego traes lectura real, aquí la cambias

                notifier.editConsumo(
                  widget.consumoId,
                  widget.conexionId,
                  _mesController.text,
                  consumoActual,
                  lecturaAnterior,
                  _fotoBase64,
                  _habilitarLecturaAnterior,
                );
              },
        child: state.status == EditStatus.loading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Guardar Consumo'),
      ),
    );
  }
}
