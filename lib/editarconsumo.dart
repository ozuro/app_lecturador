// import 'dart:convert';
// import 'package:app_lecturador/services/editconsumo_api.dart';
// // import 'package:app_lecturador/services/editconsumo_api.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // import 'services/api_consumo_update.dart'; // Asegúrate de importar la clase ApiConsumoUpdate

// class FormularioConsumo extends StatefulWidget {
//   final int consumoId; // ID del consumo a editar
//   final int clienteId; // ID del cliente

//   const FormularioConsumo({
//     Key? key,
//     required this.consumoId,
//     required this.clienteId,
//   }) : super(key: key);

//   @override
//   State<FormularioConsumo> createState() => _FormularioConsumoState();
// }

// class _FormularioConsumoState extends State<FormularioConsumo> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _mesController = TextEditingController();
//   final TextEditingController _consumoActualController =
//       TextEditingController();
//   final TextEditingController _costoMantenimientoController =
//       TextEditingController();

//   String? _estadoMedidor;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _obtenerConsumo(); // Cargar el consumo actual cuando se inicie el formulario
//   }

//   Future<void> _obtenerConsumo() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token =
//         prefs.getString('auth_token'); // Obtener el token de SharedPreferences

//     if (token == null) {
//       throw Exception("Token no encontrado.");
//     }

//     final consumoApi = Provider.of<ApiConsumoUpdate>(context, listen: false);
//     try {
//       // Obtener el consumo actual para cargarlo en el formulario
//       final consumo =
//           await consumoApi.ApiConsumoUpdate(widget.consumoId, token);

//       // Cargar los valores del consumo en los campos del formulario
//       setState(() {
//         _mesController.text = consumo['mes'];
//         _consumoActualController.text = consumo['consumo_actual'].toString();
//         _costoMantenimientoController.text =
//             consumo['costo_mantenimiento'].toString();
//         _estadoMedidor = consumo['estado_medidor'];
//       });
//     } catch (e) {
//       print("Error al obtener consumo: $e");
//     }
//   }

//   Future<void> _actualizarConsumo() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       isLoading = true;
//     });

//     final prefs = await SharedPreferences.getInstance();
//     final token =
//         prefs.getString('auth_token'); // Obtener el token de SharedPreferences

//     if (token == null) {
//       throw Exception("Token no encontrado.");
//     }

//     final consumoApi = Provider.of<ApiConsumoUpdate>(context, listen: false);
//     try {
//       final response = await consumoApi.actualizarConsumo(
//         consumoId: widget.consumoId,
//         mes: _mesController.text,
//         consumoActual: double.tryParse(_consumoActualController.text) ?? 0,
//         clienteId: widget.clienteId,
//         costoMantenimiento:
//             double.tryParse(_costoMantenimientoController.text) ?? 0,
//         token: token,
//       );

//       // Mostrar mensaje de éxito
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Consumo actualizado: ${response['id']}')),
//       );

//       Navigator.pop(context); // Regresar a la pantalla anterior
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error al actualizar consumo: $e')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Editar Consumo'),
//         backgroundColor: const Color(0xFF37AFE1),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Campo para seleccionar el mes
//               TextFormField(
//                 controller: _mesController,
//                 decoration: const InputDecoration(
//                   labelText: 'Mes',
//                   prefixIcon: Icon(Icons.calendar_today),
//                 ),
//                 readOnly: true,
//                 onTap: () async {
//                   final selectedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2100),
//                   );
//                   if (selectedDate != null) {
//                     _mesController.text =
//                         DateFormat('yyyy-MM').format(selectedDate);
//                   }
//                 },
//                 validator: (value) =>
//                     value!.isEmpty ? 'Por favor selecciona un mes' : null,
//               ),
//               const SizedBox(height: 16),
//               // Campo para ingresar el consumo actual
//               TextFormField(
//                 controller: _consumoActualController,
//                 decoration: const InputDecoration(
//                   labelText: 'Consumo Actual',
//                   prefixIcon: Icon(Icons.water),
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Por favor ingresa el consumo actual';
//                   }
//                   if (double.tryParse(value) == null) {
//                     return 'Por favor ingresa un valor válido';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               // Campo para el costo de mantenimiento
//               TextFormField(
//                 controller: _costoMantenimientoController,
//                 decoration: const InputDecoration(
//                   labelText: 'Costo de Mantenimiento',
//                   prefixIcon: Icon(Icons.attach_money),
//                 ),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Por favor ingresa el costo de mantenimiento';
//                   }
//                   if (double.tryParse(value) == null) {
//                     return 'Por favor ingresa un valor válido';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               // Dropdown para estado del medidor
//               DropdownButtonFormField<String>(
//                 value: _estadoMedidor,
//                 items: const [
//                   DropdownMenuItem(
//                     value: 'con_medidor',
//                     child: Text('Con Medidor'),
//                   ),
//                   DropdownMenuItem(
//                     value: 'sin_medidor',
//                     child: Text('Sin Medidor'),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     _estadoMedidor = value;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Estado del Medidor',
//                   prefixIcon: Icon(Icons.settings),
//                 ),
//                 validator: (value) =>
//                     value == null ? 'Por favor selecciona un estado' : null,
//               ),
//               const SizedBox(height: 16),
//               // Botón para enviar formulario
//               isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : ElevatedButton(
//                       onPressed: _actualizarConsumo,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF37AFE1),
//                       ),
//                       child: const Text('Actualizar Consumo'),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
