import 'package:flutter/material.dart';

class HomeConsumos extends StatefulWidget {
  static String routeName = '/homeConsumo';
  const HomeConsumos({super.key});

  @override
  State<HomeConsumos> createState() => _HomeConsumosState();
}

int selectedMonth = DateTime.now().month;
int selectedYear = DateTime.now().year;

final List<String> months = [
  "Enero",
  "Febrero",
  "Marzo",
  "Abril",
  "Mayo",
  "Junio",
  "Julio",
  "Agosto",
  "Septiembre",
  "Octubre",
  "Noviembre",
  "Diciembre"
];

class _HomeConsumosState extends State<HomeConsumos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Registrar los Consumos'),
          backgroundColor: const Color(0xFF37AFE1)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDropdown(
                    value: selectedMonth,
                    items: List.generate(
                        12,
                        (i) => DropdownMenuItem(
                            value: i + 1, child: Text(months[i]))),
                    onChanged: (val) => setState(() => selectedMonth = val!),
                  ),
                  SizedBox(width: 20),
                  _buildDropdown(
                    value: selectedYear,
                    items: List.generate(
                        25,
                        (i) => DropdownMenuItem(
                            value: selectedYear - 10 + i,
                            child: Text("${selectedYear - 10 + i}"))),
                    onChanged: (val) => setState(() => selectedYear = val!),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes manejar la acción al presionar el botón
                print("Mes seleccionado: $selectedMonth, Año: $selectedYear");
              },
              child: Text("Empezar a Registrar"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
      {required int value,
      required List<DropdownMenuItem<int>> items,
      required ValueChanged<int?> onChanged}) {
    return DropdownButton<int>(
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }
}
