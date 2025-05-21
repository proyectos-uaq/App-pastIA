import 'dart:convert';

class Intake {
  String? intakeLogId;
  String? buttonPressTime;
  bool? isTaken;
  String? scheduleId;

  Intake({
    this.intakeLogId,
    this.buttonPressTime,
    this.isTaken,
    this.scheduleId,
  });

  factory Intake.fromRawJson(String str) => Intake.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Intake.fromJson(Map<String, dynamic> json) => Intake(
        intakeLogId: json["intake_log_id"],
        buttonPressTime: json["button_press_time"],
        isTaken: json["is_taken"],
        scheduleId: json["schedule"],
      );

  Map<String, dynamic> toJson() => {
        if (intakeLogId != null) "intake_log_id": intakeLogId,
        if (buttonPressTime != null) "button_press_time": buttonPressTime,
        if (isTaken != null) "is_taken": isTaken,
        if (scheduleId != null) "schedule": scheduleId,
      };

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Intake {');
    buffer.writeln('  intakeLogId: $intakeLogId,');
    buffer.writeln('  buttonPressTime: $buttonPressTime,');
    buffer.writeln('  isTaken: $isTaken,');
    buffer.writeln('  scheduleId: $scheduleId');
    buffer.write('}');
    return buffer.toString();
  }
}
