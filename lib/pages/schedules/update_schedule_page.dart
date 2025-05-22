import 'package:flutter/material.dart';

class UpdateSchedulePage extends StatefulWidget {
  final String scheduleId;
  final String? initialTime; // Formato "HH:mm:ss"

  const UpdateSchedulePage({
    super.key,
    required this.scheduleId,
    this.initialTime,
  });

  @override
  State<UpdateSchedulePage> createState() => _UpdateSchedulePageState();
}

class _UpdateSchedulePageState extends State<UpdateSchedulePage> {
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialTime != null) {
      final parts = widget.initialTime!.split(':');
      if (parts.length >= 2) {
        _selectedTime = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 0,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveSchedule(BuildContext context) async {
    if (_selectedTime == null) return;

    setState(() {
      _isLoading = true;
    });

    // Aquí debes llamar a tu función/provider para actualizar el schedule con la nueva hora.
    // Ejemplo:
    // await context.read(schedulesProvider.notifier).updateSchedule(
    //   scheduleId: widget.scheduleId,
    //   medicationId: widget.medicationId,
    //   scheduledTime: "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}:00",
    // );

    // Simulación de espera
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Horario actualizado correctamente')),
      );
      Navigator.pop(context, true); // Notifica a la pantalla anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modificar horario"),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hora programada",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Text(
                  _selectedTime != null
                      ? _selectedTime!.format(context)
                      : 'No seleccionada',
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 18),
                ElevatedButton.icon(
                  icon: const Icon(Icons.access_time),
                  label: const Text('Elegir hora'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.blue.shade900,
                  ),
                  onPressed: _isLoading ? null : () => _pickTime(context),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(_isLoading ? 'Guardando...' : 'Guardar cambios'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed:
                    _isLoading || _selectedTime == null
                        ? null
                        : () => _saveSchedule(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
