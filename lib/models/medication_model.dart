import 'dart:convert';
import 'schedule_model.dart';

class Medication {
  String? medicationId;
  String? name;
  String? dosage;
  String? form;
  String? instructions;
  String?
  startDate; // ISO 8601 string, puedes cambiar a DateTime si lo necesitas
  String? interval; // Ej: "4:00:00"
  String? prescriptionId;
  List<Schedule>? schedules;

  Medication({
    this.medicationId,
    this.name,
    this.dosage,
    this.form,
    this.instructions,
    this.startDate,
    this.interval,
    this.prescriptionId,
    this.schedules,
  });

  factory Medication.fromRawJson(String str) =>
      Medication.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Medication.fromJson(Map<String, dynamic> json) {
    List<Schedule>? scheduleList;
    if (json["schedules"] is List) {
      scheduleList =
          (json["schedules"] as List).map((e) => Schedule.fromJson(e)).toList();
    }

    return Medication(
      medicationId: json["medication_id"],
      name: json["name"],
      dosage: json["dosage"],
      form: json["form"],
      instructions: json["instructions"],
      startDate: json["start_date"],
      interval: json["interval"],
      prescriptionId: json["prescriptionId"],
      schedules: scheduleList,
    );
  }

  Map<String, dynamic> toJson() => {
    if (medicationId != null) "medication_id": medicationId,
    "name": name,
    "dosage": dosage,
    "form": form,
    "instructions": instructions,
    if (startDate != null) "start_date": startDate,
    if (interval != null) "interval": interval,
    if (prescriptionId != null) "prescriptionId": prescriptionId,
    if (schedules != null)
      "schedules": schedules!.map((e) => e.toJson()).toList(),
  };

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Medication {');
    buffer.writeln('  medicationId: $medicationId,');
    buffer.writeln('  name: $name,');
    buffer.writeln('  dosage: $dosage,');
    buffer.writeln('  form: $form,');
    buffer.writeln('  instructions: $instructions,');
    buffer.writeln('  startDate: $startDate,');
    buffer.writeln('  interval: $interval,');
    buffer.writeln('  prescriptionId: $prescriptionId,');
    buffer.writeln('  schedules: ${schedules ?? "null"}');
    buffer.write('}');
    return buffer.toString();
  }
}
