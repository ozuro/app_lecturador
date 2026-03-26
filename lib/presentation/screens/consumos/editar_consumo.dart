import 'dart:convert';
import 'dart:io';

import 'package:app_lecturador/core/storage/config/api_config.dart';
import 'package:app_lecturador/domain/entities/conexion_entities.dart';
import 'package:app_lecturador/presentation/providers/consumo/editar_consumo/edit_notifier.dart';
import 'package:app_lecturador/presentation/providers/consumo/editar_consumo/edit_provider.dart';
import 'package:app_lecturador/presentation/providers/consumo/editar_consumo/edit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditConsumoPage extends ConsumerStatefulWidget {
  final int consumoId;
  final int conexionId;
  final String initialMonth;
  final Conexion conexion;

  const EditConsumoPage({
    super.key,
    required this.consumoId,
    required this.conexionId,
    required this.initialMonth,
    required this.conexion,
  });

  @override
  ConsumerState<EditConsumoPage> createState() => _EditConsumoPageState();
}

class _EditConsumoPageState extends ConsumerState<EditConsumoPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _mesController = TextEditingController();
  final _consumoActualController = TextEditingController();

  bool _habilitarLecturaAnterior = false;
  String? _fotoBase64;
  XFile? _selectedImage;
  bool _isShowingSuccessDialog = false;
  ProviderSubscription<EditconsumoState>? _editSubscription;

  @override
  void initState() {
    super.initState();
    _mesController.text = widget.initialMonth;
    _consumoActualController.text =
        '${widget.conexion.lectura?.consumoActual ?? 0}';
    _habilitarLecturaAnterior = (widget.conexion.lectura?.consumoAnterior ?? 0) > 0;
    _editSubscription = ref.listenManual<EditconsumoState>(
      editConsumoNotifierProvider,
      (previous, next) {
        if (next.status == EditStatus.actualizado && !_isShowingSuccessDialog) {
          _isShowingSuccessDialog = true;
          Future.microtask(() async {
            await _showSuccessDialog();
            if (!mounted) return;
            ref.read(editConsumoNotifierProvider.notifier).logout();
            Navigator.pop(context, true);
            _isShowingSuccessDialog = false;
          });
        }

        if (next.status == EditStatus.error && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.errorMessage ?? 'Error desconocido')),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _editSubscription?.close();
    _mesController.dispose();
    _consumoActualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editConsumoNotifierProvider);
    final notifier = ref.read(editConsumoNotifierProvider.notifier);
    final theme = Theme.of(context);
    final conexion = widget.conexion;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      appBar: AppBar(
        title: const Text('Editar consumo'),
        elevation: 0,
      ),
      body: AbsorbPointer(
        absorbing: state.status == EditStatus.loading,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
          children: [
            _EditHeaderCard(
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
                        'Actualizar lectura',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Edita la lectura registrada, corrige el valor del medidor y reemplaza la foto si hace falta.',
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
        helperText: 'Se mantiene el periodo que estas editando.',
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
        if (!RegExp(r'^\d{4}-\d{2}$').hasMatch(normalized)) {
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
            'Actualiza el valor del medidor. Lectura anterior sugerida: ${conexion.consumoAnteriorSugerido}.',
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
          'Referencia actual: ${conexion.consumoAnteriorSugerido}. Activalo si quieres conservar otra lectura anterior.',
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
                  'Actualizar foto del medidor',
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
            'Si lo necesitas, puedes reemplazar la imagen registrada por una foto nueva.',
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
          ] else if (widget.conexion.lectura?.fotoUrl != null) ...[
            _NetworkPhotoPreview(imageUrl: _resolvePhotoUrl(widget.conexion.lectura!.fotoUrl!)),
            const SizedBox(height: 12),
          ],
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.photo_camera_rounded),
                label: const Text('Cambiar foto'),
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
    EditconsumoState state,
    EditConsumoNotifier notifier,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton.icon(
        onPressed: state.status == EditStatus.loading
            ? null
            : () {
                if (!_formKey.currentState!.validate()) return;

                final consumoActual =
                    int.tryParse(_consumoActualController.text.trim()) ?? 0;
                final lecturaAnterior = widget.conexion.consumoAnteriorSugerido;

                notifier.editConsumo(
                  widget.consumoId,
                  widget.conexionId,
                  _mesController.text.trim(),
                  consumoActual,
                  lecturaAnterior,
                  _fotoBase64,
                  _habilitarLecturaAnterior,
                );
              },
        icon: state.status == EditStatus.loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.edit_rounded),
        label: Text(
          state.status == EditStatus.loading
              ? 'Actualizando lectura...'
              : 'Guardar cambios',
        ),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFE67E22),
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
                    color: const Color(0xFFFFF0E2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.task_alt_rounded,
                    color: Color(0xFFE67E22),
                    size: 42,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Cambios guardados',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'La lectura del periodo ${_formatPeriod(_mesController.text)} se actualizo correctamente.',
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

  String _resolvePhotoUrl(String rawUrl) {
    final imageUri = Uri.tryParse(rawUrl);
    final apiUri = Uri.tryParse(ApiConfig.baseUrl);

    if (imageUri == null || apiUri == null) {
      return rawUrl;
    }

    final isLocalHost = imageUri.host == 'localhost' || imageUri.host == '127.0.0.1';
    if (!isLocalHost) {
      return rawUrl;
    }

    return imageUri.replace(
      scheme: apiUri.scheme,
      host: apiUri.host,
      port: apiUri.hasPort ? apiUri.port : null,
    ).toString();
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

class _NetworkPhotoPreview extends StatelessWidget {
  const _NetworkPhotoPreview({
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 180,
        width: double.infinity,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
          cacheWidth: 960,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: const Color(0xFFEFF4FA),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFEFF4FA),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image_outlined,
                    size: 36,
                    color: Color(0xFF7A8797),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No se pudo cargar la foto actual.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF5D6775)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EditHeaderCard extends StatelessWidget {
  const _EditHeaderCard({
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
          colors: [Color(0xFFE67E22), Color(0xFFF2994A)],
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
            '${conexion.cliente.tipoPersonaLabel} · ${conexion.cliente.documentoLabel}: ${conexion.cliente.documentoPrincipal}',
            style: const TextStyle(
              color: Colors.white70,
              height: 1.4,
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
              _EditHeaderBadge(
                icon: Icons.pin_outlined,
                label: 'Codigo ${conexion.codigo ?? conexion.id}',
              ),
              _EditHeaderBadge(
                icon: Icons.speed_rounded,
                label: conexion.medidor ? 'Con medidor' : 'Sin medidor',
              ),
              _EditHeaderBadge(
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

class _EditHeaderBadge extends StatelessWidget {
  const _EditHeaderBadge({
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
