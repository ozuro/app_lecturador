import 'package:flutter/material.dart';

class MonthSelector extends StatelessWidget {
  const MonthSelector({
    super.key,
    required this.selectedMonth,
    required this.onChanged,
  });

  final String selectedMonth;
  final void Function(String year, String month) onChanged;

  @override
  Widget build(BuildContext context) {
    final year = selectedMonth.substring(0, 4);
    final month = selectedMonth.substring(5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD6E6FF)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Icon(
            Icons.calendar_month_rounded,
            color: Color(0xFF2F80ED),
            size: 16,
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: year,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF243447),
              ),
              items: ['2024', '2025', '2026']
                  .map((item) =>
                      DropdownMenuItem(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value, month);
                }
              },
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: month,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF243447),
              ),
              items: List.generate(12, (index) {
                final value = (index + 1).toString().padLeft(2, '0');
                return DropdownMenuItem(
                  value: value,
                  child: Text(_monthName(value)),
                );
              }),
              onChanged: (value) {
                if (value != null) {
                  onChanged(year, value);
                }
              },
            ),
          ),
          Chip(
            backgroundColor: const Color(0xFF2F80ED),
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            label: Text(
              '${_monthName(month)} $year',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(String month) {
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
    return months[int.parse(month) - 1];
  }
}
