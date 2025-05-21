import 'package:app_pastia/models/schedule_model.dart';
import 'package:flutter/material.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key, required this.schedule});

  final Schedule schedule;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Proxima toma',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Medicamento: schedule.medication_name'),
            const SizedBox(height: 4),
            const Text('Hora: schedule.scheduledTime'),
          ],
        ),
      ),
    );
  }
}
