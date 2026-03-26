import 'dart:convert';
import 'dart:io';

import 'package:app_lecturador/domain/entities/conexion_entities.dart';
import 'package:app_lecturador/presentation/providers/consumo/registro_consumo/registroConsumo_notifier.dart';
import 'package:app_lecturador/presentation/providers/consumo/registro_consumo/registroConsumo_provider.dart';
import 'package:app_lecturador/presentation/providers/consumo/registro_consumo/registroConsumo_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class RegistroConsumoPage extends ConsumerStatefulWidget {
  final int conexionId;
  final String initialMonth;
  final Conexion conexion;

  const RegistroConsumoPage({
    super.key,
    required this.conexionId,
    required this.initialMonth,
    required this.conexion,
  });

  @override
  ConsumerState<RegistroConsumoPage> createState() =>
      _RegistroConsumoPageState();
}

class _RegistroConsumoPageState extends ConsumerState<RegistroConsumoPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _mesController = TextEditingController();
  final _consumoActualController = TextEditingController();

  bool _habilitarLecturaAnterior = false;
  String? _fotoBase64;
  XFile? _selectedImage;
  bool _isShowingSuccessDialog = false;

  @override
  void initState() {
    super.initState();
    _mesController.text = widget.initialMonth;
  }

  @override
  void dispose() {
    _mesController.dispose();
    _consumoActualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registroConsumoNotifierProvider);
    final notifier = ref.read(registroConsumoNotifierProvider.notifier);
    final theme = Theme.of(context);
    final conexion = widget.conexion;

    ref.listen(registroConsumoNotifierProvider, (previous, next) {
      if (next.status == RegistroStatus.registrado && !_isShowingSuccessDialog) {
        _isShowingSuccessDialog = true;
        Future.microtask(() async {
          await _showSuccessDialog();
          if (!mounted) return;
          ref.read(registroConsumoNotifierProvider.notifier).logout();
          Navigator.pop(context, true);
          _isShowingSuccessDialog = false;
        });
      }

      if (next.status == RegistroStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Error desconocido')),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        title: const Text('Registrar consumo'),
        elevation: 0,
      ),
      body: AbsorbPointer(
        absorbing: state.status == RegistroStatus.loading,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          children: [
            _HeaderCard(
              conexion: conexion,
              periodLabel: _formatPeriod(_mesController.text),
            ),
            const SizedBox(height: 18),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nueva lectura',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Pon aqui la lectura actual que ves en el medidor y adjunta una foto para respaldarla.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildMesField(),
                      const SizedBox(height: 16),
                      _buildConsumoActualField(conexion),
                      const SizedBox(height: 16),
                      _buildLecturaAnteriorSwitch(conexion),
                      const SizedBox(height: 16),
                      _buildPhotoSection(),
                      const SizedBox(height: 24),
                      _buildSubmitButton(state, notifier),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMesField() {
    return TextFormField(
      controller: _mesController,
      decoration: InputDecoration(
        labelText: 'Periodo',
        hintText: 'YYYY-MM',
        helperText: 'Se completa con el filtro usado en consumo actual.',
        prefixIcon: const Icon(Icons.calendar_month_rounded),
        filled: true,
        fillColor: const Color(0xFFF8FAFD),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ingrese el periodo';
        }
        final normalized = value.trim();
        final isValid = RegExp(r'^\d{4}-\d{2}$').hasMatch(normalized);
        if (!isValid) {
          return 'Use el formato YYYY-MM';
        }
        return null;
      },
    );
  }

  Widget _buildConsumoActualField(Conexion conexion) {
    return TextFormField(
      controller: _consumoActualController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Lectura actual del medidor',
        hintText: 'Ejemplo: 1285',
        helperText:
            'Pon aqui su consumo que esta en medidor. Ultima lectura sugerida: ${conexion.consumoAnteriorSugerido}.',
        prefixIcon: const Icon(Icons.speed_rounded),
        suffixText: 'm3',
        filled: true,
        fillColor: const Color(0xFFF8FAFD),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ingrese la lectura actual';
        }
        if (int.tryParse(value.trim()) == null) {
          return 'Debe ser un numero entero';
        }
        return null;
      },
    );
  }

  Widget _buildLecturaAnteriorSwitch(Conexion conexion) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: const Text(
          'Usar lectura anterior manual',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          'Referencia actual: ${conexion.consumoAnteriorSugerido}. Activalo si luego vas a manejar otra lectura anterior.',
        ),
        value: _habilitarLecturaAnterior,
        onChanged: (value) {
          setState(() {
            _habilitarLecturaAnterior = value;
          });
        },
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.photo_camera_back_rounded, color: Color(0xFF0F4C81)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Foto del medidor',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Toma una foto clara del medidor para dejar evidencia de la lectura.',
            style: TextStyle(color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 14),
          if (_selectedImage != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(_selectedImage!.path),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.photo_camera_rounded),
                label: Text(_selectedImage == null ? 'Tomar foto' : 'Cambiar foto'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0F4C81),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Elegir de galeria'),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
    RegistroconsumoState state,
    RegistroconsumoNotifier notifier,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton.icon(
        onPressed: state.status == RegistroStatus.loading
            ? null
            : () {
                if (!_formKey.currentState!.validate()) return;

                final consumoActual =
                    int.tryParse(_consumoActualController.text.trim()) ?? 0;
                final lecturaAnterior = widget.conexion.consumoAnteriorSugerido;

                notifier.registroConsumo(
                  widget.conexionId,
                  _mesController.text.trim(),
                  consumoActual,
                  lecturaAnterior,
                  _fotoBase64,
                  _habilitarLecturaAnterior,
                );
              },
        icon: state.status == RegistroStatus.loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.save_rounded),
        label: Text(
          state.status == RegistroStatus.loading
              ? 'Guardando lectura...'
              : 'Guardar consumo',
        ),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF1F9D68),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _picker.pickImage(
      source: source,
      imageQuality: 45,
      maxWidth: 960,
      maxHeight: 960,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();

    setState(() {
      _selectedImage = image;
      _fotoBase64 = base64Encode(bytes);
    });
  }

  Future<void> _showSuccessDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F7EF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF1F9D68),
                    size: 42,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Registro exitoso',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'La lectura del periodo ${_formatPeriod(_mesController.text)} se guardo correctamente y la lista se actualizara al volver.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    height: 1.45,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0F4C81),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Volver a consumos'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatPeriod(String period) {
    final parts = period.split('-');
    if (parts.length != 2) return period;

    const months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    final monthIndex = int.tryParse(parts[1]);
    if (monthIndex == null || monthIndex < 1 || monthIndex > 12) {
      return period;
    }

    return '${months[monthIndex - 1]} ${parts[0]}';
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.conexion,
    required this.periodLabel,
  });

  final Conexion conexion;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F4C81), Color(0xFF2F80ED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(40),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              periodLabel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            conexion.cliente.nombreCompleto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            conexion.direccion.descripcionCorta,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeaderBadge(
                icon: Icons.pin_outlined,
                label: 'Codigo ${conexion.codigo ?? conexion.id}',
              ),
              _HeaderBadge(
                icon: Icons.speed_rounded,
                label: conexion.medidor ? 'Con medidor' : 'Sin medidor',
              ),
              _HeaderBadge(
                icon: Icons.history_rounded,
                label: 'Anterior ${conexion.consumoAnteriorSugerido}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(28),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
