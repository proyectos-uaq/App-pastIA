import 'dart:convert';
import 'schedule_model.dart';

class Medication {
  String? name;
  String? dosage;
  String? form;
  String? instructions;
  String? prescriptionId;
  List<Schedule>? schedules;

  Medication({
    this.name,
    this.dosage,
    this.form,
    this.instructions,
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
      name: json["name"],
      dosage: json["dosage"],
      form: json["form"],
      instructions: json["instructions"],
      prescriptionId: json["prescriptionId"],
      schedules: scheduleList,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "dosage": dosage,
        "form": form,
        "instructions": instructions,
        if (prescriptionId != null) "prescriptionId": prescriptionId,
        if (schedules != null)
          "schedules": schedules!.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Medication {');
    buffer.writeln('  name: $name,');
    buffer.writeln('  dosage: $dosage,');
    buffer.writeln('  form: $form,');
    buffer.writeln('  instructions: $instructions,');
    buffer.writeln('  prescriptionId: $prescriptionId,');
    buffer.writeln('  schedules: ${schedules != null ? schedules : "null"}');
    buffer.write('}');
    return buffer.toString();
  }
}
