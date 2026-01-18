import 'package:flutter/material.dart';

class _MonthSelector extends StatelessWidget {
  final String selectedMonth;
  final void Function(String year, String month) onChanged;

  const _MonthSelector({
    required this.selectedMonth,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final year = selectedMonth.substring(0, 4);
    final month = selectedMonth.substring(5);

    return Row(
      children: [
        DropdownButton<String>(
          value: year,
          items: ['2024', '2025', '2026']
              .map(
                (y) => DropdownMenuItem(
                  value: y,
                  child: Text(y),
                ),
              )
              .toList(),
          onChanged: (y) {
            if (y != null) onChanged(y, month);
          },
        ),
        const SizedBox(width: 12),
        DropdownButton<String>(
          value: month,
          items: List.generate(12, (index) {
            final m = (index + 1).toString().padLeft(2, '0');
            return DropdownMenuItem(
              value: m,
              child: Text(m),
            );
          }),
          onChanged: (m) {
            if (m != null) onChanged(year, m);
          },
        ),
      ],
    );
  }
}
