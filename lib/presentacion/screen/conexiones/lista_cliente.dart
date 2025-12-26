import 'package:app_lecturador/presentacion/screen/conexiones/conexiones.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/consumos/api_consumo.dart';
import 'package:app_lecturador/presentacion/screen/conexiones/crear_consumo.dart'; // Asegúrate de importar el archivo donde tienes definido el formulario

class ListaClientePage extends StatefulWidget {
  final Map<String, dynamic> cliente;
  static String routeName = '/lista_cliente';
  const ListaClientePage({Key? key, required this.cliente}) : super(key: key);

  @override
  State<ListaClientePage> createState() => _ListaClientePageState();
}

class _ListaClientePageState extends State<ListaClientePage> {
  bool isLoading = false;
  int _currentPage = 1; // Página actual
  final int _rowsPerPage = 8; // Filas por página

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

    // Calcular paginación
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = (_currentPage * _rowsPerPage) > consumos.length
        ? consumos.length
        : _currentPage * _rowsPerPage;
    final paginatedConsumos = consumos.sublist(startIndex, endIndex);

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
              "Nombre: ${widget.cliente['nombres']}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              "Apellidos: ${widget.cliente['apellidosssssss']}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              "DNI: ${widget.cliente['dni']}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("Celular: ${widget.cliente['celular']}"),
            // Text("Dirección: ${widget.conexion['direccion_id']}"),
            const SizedBox(height: 16),
            // Botón para Agregar Consumo
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormularioConsumo(
                      clienteId: widget.cliente['id'],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF37AFE1),
              ),
              child: const Text("Agregar Conexiones"),
            ),
            const SizedBox(height: 16),
            // Tabla de Consumos
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (consumos.isEmpty)
              const Center(child: Text("No hay consumos registrados."))
            else
              Expanded(
                child: Column(
                  children: [
                    Text("Lista de conexiones"),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Id")),
                          DataColumn(label: Text("Cod")),
                          DataColumn(label: Text("Estado")),
                          DataColumn(label: Text("Acciones")),
                        ],
                        rows: paginatedConsumos.map((conexion) {
                          return DataRow(
                            cells: [
                              DataCell(Text("${conexion['id']}")),
                              DataCell(Text("${conexion['codigo']}")),
                              DataCell(Text("${conexion['estado']}")),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.search,
                                        color: Colors.red),
                                    onPressed: () {
                                      final id = conexion['id'];
                                      final cliente = widget.cliente['id'];

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ConsumoLista(
                                            id,
                                          ),
                                        ),
                                      );
                                      print(
                                          "ver consumo ID: ${conexion['id']}");
                                    },
                                  ),
                                ],
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Controles de paginación
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _currentPage > 1
                              ? () {
                                  setState(() {
                                    _currentPage--;
                                  });
                                }
                              : null,
                          child: const Text("Anterior"),
                        ),
                        Text(
                          "Página $_currentPage de ${((consumos.length - 1) / _rowsPerPage).ceil() + 1}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: endIndex < consumos.length
                              ? () {
                                  setState(() {
                                    _currentPage++;
                                  });
                                }
                              : null,
                          child: const Text("Siguiente"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
