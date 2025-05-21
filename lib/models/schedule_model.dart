import 'dart:convert';
import 'intake_model.dart';

class Schedule {
  String? scheduleId;
  String? scheduledTime;
  String? medicationId;
  List<Intake>? intakes;

  Schedule({
    this.scheduleId,
    this.scheduledTime,
    this.medicationId,
    this.intakes,
  });

  factory Schedule.fromRawJson(String str) =>
      Schedule.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    scheduleId: json["schedule_id"],
    scheduledTime: json["scheduled_time"],
    medicationId: json["medicationId"],
    intakes:
        json["intakes"] != null
            ? List<Intake>.from(json["intakes"].map((x) => Intake.fromJson(x)))
            : [],
  );

  Map<String, dynamic> toJson() => {
    if (scheduleId != null) "schedule_id": scheduleId,
    if (scheduledTime != null) "scheduled_time": scheduledTime,
    if (medicationId != null) "medicationId": medicationId,
    if (intakes != null)
      "intakes": intakes!.map((intake) => intake.toJson()).toList(),
  };

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Schedule {');
    buffer.writeln('  scheduleId: $scheduleId,');
    buffer.writeln('  scheduledTime: $scheduledTime,');
    buffer.writeln('  medicationId: $medicationId,');
    buffer.writeln('  intakes: $intakes');
    buffer.write('}');
    return buffer.toString();
  }
}
