import 'dart:convert';
import 'intake_model.dart';

class Schedule {
  String? scheduleId;
  String? scheduledTime;
  String? medicationId;
  String? medicationName;
  List<Intake>? intakes;

  Schedule({
    this.scheduleId,
    this.scheduledTime,
    this.medicationId,
    this.medicationName,
    this.intakes,
  });

  factory Schedule.fromRawJson(String str) =>
      Schedule.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    scheduleId: json["schedule_id"],
    scheduledTime: json["scheduled_time"],
    medicationId: json["medicationId"],
    medicationName: json["medication_name"],
    intakes:
        (json["intakes"] is List)
            ? List<Intake>.from(json["intakes"].map((x) => Intake.fromJson(x)))
            : [],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (scheduleId != null) data["schedule_id"] = scheduleId;
    if (scheduledTime != null) data["scheduled_time"] = scheduledTime;
    if (medicationId != null) data["medicationId"] = medicationId;
    if (intakes != null) {
      data["intakes"] = intakes!.map((i) => i.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return '''
Schedule {
  scheduleId: $scheduleId,
  scheduledTime: $scheduledTime,
  medicationId: $medicationId,
  medicationName: $medicationName,
  intakes: $intakes
}''';
  }
}
