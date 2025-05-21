import 'dart:convert';
import 'medication_model.dart';

class Prescription {
  String? prescriptionId;
  String? name;
  String? source;
  DateTime? createdAt;
  int? medicationCount;
  List<Medication>? medications;

  Prescription({
    this.prescriptionId,
    this.name,
    this.source,
    this.createdAt,
    this.medicationCount,
    this.medications,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    List<Medication>? meds;
    if (json["medications"] is List) {
      meds = (json["medications"] as List)
          .map((e) => Medication.fromJson(e))
          .toList();
    }

    return Prescription(
      prescriptionId: json["prescription_id"],
      name: json["name"],
      source: json["source"],
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"])
          : null,
      medicationCount: json["medication_count"],
      medications: meds,
    );
  }

  Map<String, dynamic> toJson() => {
        if (prescriptionId != null) "prescription_id": prescriptionId,
        "name": name,
        "source": source,
        if (createdAt != null) "createdAt": createdAt!.toIso8601String(),
        if (medicationCount != null) "medication_count": medicationCount,
        if (medications != null)
          "medications": medications!.map((e) => e.toJson()).toList(),
      };

  static List<Prescription> listFromJson(List<dynamic> jsonList) =>
      jsonList.map((e) => Prescription.fromJson(e)).toList();

  static String listToJson(List<Prescription> list) =>
      json.encode(list.map((e) => e.toJson()).toList());

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Prescription {');
    buffer.writeln('  prescriptionId: $prescriptionId,');
    buffer.writeln('  name: $name,');
    buffer.writeln('  source: $source,');
    buffer.writeln('  createdAt: ${createdAt?.toIso8601String() ?? "null"},');
    buffer.writeln('  medicationCount: ${medicationCount ?? "null"},');
    buffer.writeln(
        '  medications: ${medications != null ? medications! : "null"}');
    buffer.write('}');
    return buffer.toString();
  }
}
