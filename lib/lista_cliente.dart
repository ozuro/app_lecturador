import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api_consumo.dart';

class ListaClientePage extends StatefulWidget {
  final Map<String, dynamic> cliente;

  const ListaClientePage({Key? key, required this.cliente}) : super(key: key);

  @override
  State<ListaClientePage> createState() => _ListaClientePageState();
}

class _ListaClientePageState extends State<ListaClientePage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarConsumos();
  }

  Future<void> _cargarConsumos() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception("Token no encontrado.");
      }

      await Provider.of<ApiConsumo>(context, listen: false)
          .obtenerConsumos(widget.cliente['id'], token);
    } catch (e) {
      print("Error al cargar consumos: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final consumos = Provider.of<ApiConsumo>(context).consumos;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cliente: ${widget.cliente['nombres']}'),
        backgroundColor: const Color(0xFF37AFE1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Datos del Cliente
            Text(
              "DNI: ${widget.cliente['dni']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Celular: ${widget.cliente['celular']}"),
            Text("Dirección: ${widget.cliente['direccion_id']}"),
            const SizedBox(height: 16),
            // Botón para Agregar Consumo
            ElevatedButton(
              onPressed: () {
                // Navegación a la pantalla de agregar consumo
                print("Navegar a agregar consumo");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF37AFE1),
              ),
              child: const Text("Agregar Consumo"),
            ),
            const SizedBox(height: 16),
            // Tabla de Consumos
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (consumos.isEmpty)
              const Center(child: Text("No hay consumos registrados."))
            else
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Mes")),
                      DataColumn(label: Text("C Ant")),
                      DataColumn(label: Text("C Act")),
                      DataColumn(label: Text("Acciones")),
                    ],
                    rows: consumos.map((consumo) {
                      return DataRow(
                        cells: [
                          DataCell(Text("${consumo['mes']}")),
                          DataCell(Text("${consumo['consumo_anterior']}")),
                          DataCell(Text("${consumo['consumo_actual']}")),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  print("Editar consumo ID: ${consumo['id']}");
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  print(
                                      "Eliminar consumo ID: ${consumo['id']}");
                                },
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
