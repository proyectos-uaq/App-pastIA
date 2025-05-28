import 'package:past_ia/pages/schedules/intake_logs_page.dart';
import 'package:past_ia/providers/providers.dart';
import 'package:past_ia/widgets/custom_circular_progress_indicator.dart';
import 'package:past_ia/widgets/notification_container.dart';
import 'package:past_ia/pages/schedules/widgets/schedule_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchedulePage extends ConsumerWidget {
  final String token;
  const SchedulePage({super.key, required this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(schedulesProvider(token));

    return schedulesAsync.when(
      data: (data) {
        final now = TimeOfDay.now();
        List schedules = List.from(data.data ?? []);

        int minutesTo(TimeOfDay from, String scheduled) {
          final parts = scheduled.split(":");
          final schedTime = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
          int diff =
              (schedTime.hour - from.hour) * 60 +
              (schedTime.minute - from.minute);
          if (diff < 0) diff += 24 * 60;
          return diff;
        }

        schedules.sort((a, b) {
          final diffA = minutesTo(now, a.scheduledTime!);
          final diffB = minutesTo(now, b.scheduledTime!);
          return diffA.compareTo(diffB);
        });

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Próximos horarios",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                ...schedules.map<Widget>(
                  (schedule) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ScheduleCard(
                      schedule: schedule,
                      token: token,
                      onEventUpdated: () {
                        ref.invalidate(schedulesProvider(token));
                      },
                      onTapNavigate: (context, schedule) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => IntakeLogsPage(
                                  scheduleId: schedule.scheduleId!,
                                  token: token,
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (schedules.isEmpty)
                  Center(
                    child: NotificationContainer(
                      message:
                          'No tienes horarios programados. Puedes agregarlos desde la página de detalles de medicamento.',
                      icon: Icons.error_outline_outlined,
                      backgroundColor: Colors.blue.shade100,
                      textColor: Colors.blue.shade900,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: MyCustomLoader()),
      error:
          (err, stack) => NotificationContainer(
            message: '$err',
            icon: Icons.error_outline,
            backgroundColor: Colors.red.shade100,
            textColor: Colors.red,
          ),
    );
  }
}
