import 'package:app_lecturador/presentation/providers/home/home_provider.dart';
import 'package:app_lecturador/presentation/widget/carta.dart';
import 'package:app_lecturador/presentation/widget/navegacion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:month_selector/month_selector.dart';

class RegistroConsumoPage extends ConsumerWidget {
  final int conexionId;
  const RegistroConsumoPage({super.key, required this.conexionId});

  static const String title = 'Sistema Jass Capachica';
  static const Color colorazul = Color.fromARGB(255, 68, 128, 219);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el provider que trae los datos del home
    final reporteHome = ref.watch(reporteHomeProvider);
    final _formKey = GlobalKey<FormState>();
    bool _obscureText = true;

// month
    DateTime? month;

    String monthDisplay(DateTime date) {
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();
      return "$month/$year";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(RegistroConsumoPage.title),
      ),
      drawer: navegacion(context),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Registro de Consumo",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E)),
                ),
                const SizedBox(height: 8),
                Text("id:$conexionId",
                    style: TextStyle(color: Colors.grey[600])),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return MonthSelector(
                            selectedDate: month != null ? [month!] : [],
                            callback: (res) {
                              Navigator.pop(context);
                              // if (res != null && res != []) {
                              //   setState(() {
                              //     month = res[0];
                              //   });
                              // }
                            },
                          );
                        });
                  },
                  child: Text(
                      month != null ? monthDisplay(month!) : "Seleccionar Mes"),
                ),
                const SizedBox(height: 20),
                // Campo de Email
                _buildTextField(
                  label: "Mes de Consumo",
                  hint: "",
                  icon: Icons.calendar_month,
                  validator: (value) =>
                      value!.contains('-') ? null : "Ingresa un mes válido",
                ),
                SizedBox(height: 20),

                // Campo de Password
                _buildTextField(
                  label: "Consumo Actual",
                  hint: "50",
                  icon: Icons.safety_check,
                  isPassword: false,
                  obscureText: _obscureText,
                  validator: (value) =>
                      value!.length < 6 ? "Mínimo 6 caracteres" : null,
                ),

                const SizedBox(height: 40),

                // Botón Moderno

                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4361EE),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Lógica de éxito
                      }
                    },
                    child: const Text("Registrar",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget reutilizable para mantener el código limpio
  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? togglePassword,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        SizedBox(height: 8),
        TextFormField(
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Color(0xFF4361EE)),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: togglePassword)
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Color(0xFF4361EE), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}
