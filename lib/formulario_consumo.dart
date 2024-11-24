import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/createconsumo_api.dart';

class FormularioConsumo extends StatefulWidget {
  final int clienteId;

  const FormularioConsumo({Key? key, required this.clienteId})
      : super(key: key);

  @override
  State<FormularioConsumo> createState() => _FormularioConsumoState();
}

class _FormularioConsumoState extends State<FormularioConsumo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mesController = TextEditingController();
  final TextEditingController _consumoActualController =
      TextEditingController();

  String? _estadoMedidor;
  String? _foto;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mesController.text =
        DateFormat('yyyy-MM').format(DateTime.now()); // Mes actual por defecto
  }

  Future<void> _crearConsumo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token =
          prefs.getString('auth_token'); // Autenticación si es necesaria

      if (token == null) {
        throw Exception("Token no encontrado.");
      }

      final consumoApi = Provider.of<ApiConsumocreate>(context, listen: false);
      final response = await consumoApi.crearConsumo(
        clienteId: widget.clienteId,
        mes: _mesController.text,
        consumoActual: double.tryParse(_consumoActualController.text) ?? 0,
        foto: _foto, // Lógica para subir una foto si es necesario
        estadoMedidor: _estadoMedidor!,
        token: token, // Pasar el token aquí
      );

      // Acceder al ID de la respuesta
      final consumoId = response['id'];

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Consumo creado: $consumoId')),
      );

      Navigator.pop(context); // Regresar a la lista de consumos
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear consumo: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Consumo'),
        backgroundColor: const Color(0xFF37AFE1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para seleccionar el mes
              TextFormField(
                controller: _mesController,
                decoration: const InputDecoration(
                  labelText: 'Mes',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    _mesController.text =
                        DateFormat('yyyy-MM').format(selectedDate);
                  }
                },
                validator: (value) =>
                    value!.isEmpty ? 'Por favor selecciona un mes' : null,
              ),
              const SizedBox(height: 16),
              // Campo para ingresar el consumo actual
              TextFormField(
                controller: _consumoActualController,
                decoration: const InputDecoration(
                  labelText: 'Consumo Actual',
                  prefixIcon: Icon(Icons.water),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el consumo actual';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingresa un valor válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Dropdown para estado del medidor
              DropdownButtonFormField<String>(
                value: _estadoMedidor,
                items: const [
                  DropdownMenuItem(
                    value: 'con_medidor',
                    child: Text('Con Medidor'),
                  ),
                  DropdownMenuItem(
                    value: 'sin_medidor',
                    child: Text('Sin Medidor'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _estadoMedidor = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Estado del Medidor',
                  prefixIcon: Icon(Icons.settings),
                ),
                validator: (value) =>
                    value == null ? 'Por favor selecciona un estado' : null,
              ),
              const SizedBox(height: 16),
              // Botón para tomar foto
              TextButton.icon(
                onPressed: () {
                  // Implementa la lógica para tomar o seleccionar una foto
                  setState(() {
                    _foto = "ruta/foto.jpg"; // Ruta simulada
                  });
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text("Tomar Foto"),
              ),
              const SizedBox(height: 16),
              // Botón para enviar formulario
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _crearConsumo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF37AFE1),
                      ),
                      child: const Text("Registrar Consumo"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
