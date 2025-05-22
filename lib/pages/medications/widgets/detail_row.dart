import 'package:flutter/material.dart';

/// Widget para una fila de detalle de medicamento.
class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const DetailRow({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.blueGrey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
