import 'package:app_pastia/utils/interval_validator.dart';
import 'package:flutter/material.dart';

class IntervalTextFormField extends StatelessWidget {
  final TextEditingController controller;
  const IntervalTextFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Intervalo',
        hintText: 'Ejemplo: 08:00:00 para cada 8 horas',
        prefixIcon: Icon(Icons.schedule),
        border: OutlineInputBorder(),
      ),
      validator: intervalValidator,
    );
  }
}
