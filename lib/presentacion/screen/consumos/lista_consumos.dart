import 'package:app_lecturador/services/lista_consumos/consumo_index_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ConsumosScreen extends StatefulWidget {
  @override
  _ConsumosScreenState createState() => _ConsumosScreenState();
}

class _ConsumosScreenState extends State<ConsumosScreen> {
  DateTime? _selectedMonthYear;
  String? _selectedEstado;
  int? _selectedDireccionId;
  List<Map<String, dynamic>> _direcciones = [
    {'id': null, 'nombre': 'Todas las direcciones'},
    {'id': 1, 'nombre': 'Dirección A'},
    {'id': 2, 'nombre': 'Dirección B'},
    // ... Carga tus direcciones
  ];

  @override
  void initState() {
    super.initState();
    _selectedMonthYear = DateTime.now();
    _loadConsumos();
  }

  Future<void> _loadConsumos() async {
    final consumoService = Provider.of<ConsumoService>(context, listen: false);
    final formattedMonthYear = _selectedMonthYear != null
        ? DateFormat('yyyy-MM').format(_selectedMonthYear!)
        : null;
    try {
      await consumoService.fetchConsumos(
        month: formattedMonthYear,
        estado: _selectedEstado,
        direccionId: _selectedDireccionId,
      );
    } catch (e) {
      print('Error al cargar consumos: $e');
    }
  }

  void _showMonthYearPicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonthYear ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year, // Inicia en la vista de años
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              accentColor: Colors.blueAccent,
              // primaryColorDark: Colors.blue[700],
            ),
            textTheme: const TextTheme(
                // headline6: TextStyle(fontWeight: FontWeight.bold),
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedMonthYear = DateTime(picked.year, picked.month);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final consumoService = Provider.of<ConsumoService>(context);
    final conexiones = consumoService.conexiones;

    final totalSinLectura = conexiones.where((conexion) {
      final consumo = conexion['consumos']?.isNotEmpty == true
          ? conexion['consumos'][0]
          : null;
      return consumo == null ||
          consumo['estado_consumo'] == null ||
          !consumo['estado_consumo'];
    }).length;

    final totalConexiones = conexiones.length;
    final direccionSeleccionadaNombre = _direcciones.firstWhere(
      (d) => d['id'] == _selectedDireccionId,
      orElse: () => {'nombre': 'todas las direcciones'},
    )['nombre'];

    String lecturasStatusText;
    Color lecturasStatusColor;
    String lecturasStatusIcon = '';

    if (totalSinLectura == 0) {
      lecturasStatusText = 'Todas las lecturas realizadas';
      lecturasStatusColor = Colors.green;
      lecturasStatusIcon = '✅';
    } else if (totalSinLectura < 5) {
      lecturasStatusText = '$totalSinLectura lecturas pendientes';
      lecturasStatusColor = Colors.orange;
    } else {
      lecturasStatusText = '$totalSinLectura lecturas pendientes';
      lecturasStatusColor = Colors.red;
    }

    final currentMonthYearFormatted = _selectedMonthYear != null
        ? DateFormat('MMMM ' 'yyyy', 'es_PE').format(_selectedMonthYear!)
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Consumos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Filtros',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap:
                                _showMonthYearPicker, // Llama al DatePicker configurado
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Mes y Año',
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                currentMonthYearFormatted,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Estado',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedEstado,
                            items: <String>['todos', 'registrado', 'pendiente']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value == 'todos'
                                    ? 'Todos'
                                    : (value == 'registrado'
                                        ? 'Pagado'
                                        : 'Registrado')),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedEstado = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Dirección',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedDireccionId,
                      items: _direcciones.map((direccion) {
                        return DropdownMenuItem<int>(
                          value: direccion['id'],
                          child: Text(direccion['nombre']),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedDireccionId = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadConsumos,
                      child: Text('Filtrar'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Mes: $currentMonthYearFormatted',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Realizar las lecturas de $direccionSeleccionadaNombre: $lecturasStatusText $lecturasStatusIcon de $totalConexiones',
              style: TextStyle(fontSize: 16, color: lecturasStatusColor),
            ),
            SizedBox(height: 10),
            if (conexiones.isNotEmpty)
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Cliente')),
                  DataColumn(label: Text('Dirección')),
                  DataColumn(label: Text('Estado Recibo')),
                  DataColumn(label: Text('Estado Consumo')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: conexiones.map((conexion) {
                  final consumo = conexion['consumos']?.isNotEmpty == true
                      ? conexion['consumos'][0]
                      : null;
                  final estadoConsumoRecibo =
                      consumo?['recibo_generado'] == true
                          ? 'Recibo Emitido'
                          : 'Pendiente';
                  final estadoLectura = consumo?['estado_consumo'] == true
                      ? 'Con Lectura Ok'
                      : 'Sin Lectura';
                  final colorEstadoRecibo = consumo?['recibo_generado'] == true
                      ? Colors.green
                      : Colors.orange;
                  final colorEstadoLectura = consumo?['estado_consumo'] == true
                      ? Colors.green
                      : Colors.red;

                  return DataRow(cells: <DataCell>[
                    DataCell(Text('${conexion['id']}')),
                    DataCell(Text(
                        '${conexion['cliente']['nombres']} ${conexion['cliente']['apellidos']}')),
                    DataCell(Text('${conexion['direccion']['nombre']}')),
                    DataCell(Text(estadoConsumoRecibo,
                        style: TextStyle(color: colorEstadoRecibo))),
                    DataCell(Text(estadoLectura,
                        style: TextStyle(color: colorEstadoLectura))),
                    DataCell(
                      Row(
                        children: <Widget>[
                          if (consumo != null) ...[
                            ElevatedButton(
                              onPressed: () {
                                // Navegar a la vista de detalle
                                print('Ver consumo ${consumo['id']}');
                              },
                              child: Text('Ver'),
                            ),
                            SizedBox(width: 8),
                            if (!consumo['recibo_generado'])
                              ElevatedButton(
                                onPressed: () {
                                  // Navegar a la edición
                                  print('Editar consumo ${consumo['id']}');
                                },
                                child: Text('Editar'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange),
                              ),
                            SizedBox(width: 8),
                            if (!consumo['recibo_generado'])
                              ElevatedButton(
                                onPressed: () {
                                  // Mostrar diálogo de confirmación para eliminar
                                  print('Eliminar consumo ${consumo['id']}');
                                },
                                child: Text('Eliminar'),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                              ),
                          ] else
                            ElevatedButton(
                              onPressed: () {
                                // Navegar a la creación
                                print(
                                    'Crear consumo para conexión ${conexion['id']}');
                              },
                              child: Text('Registrar'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                            ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              )
            else
              Center(
                  child: Text(
                      'No se encontraron consumos con los filtros seleccionados.')),
          ],
        ),
      ),
    );
  }
}
