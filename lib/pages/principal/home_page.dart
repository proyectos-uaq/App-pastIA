import 'package:app_pastia/pages/medications/medications_page.dart';
import 'package:app_pastia/pages/prescriptions/prescription_page.dart';
import 'package:app_pastia/pages/schedules/schedule_page.dart';
import 'package:app_pastia/pages/principal/settings_page.dart';
import 'package:app_pastia/providers/providers.dart';
import 'package:app_pastia/pages/principal/widgets/home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final navBarIndexProvider = StateProvider<int>((ref) => 0);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenAsync = ref.watch(jwtTokenProvider);
    final selectedIndex = ref.watch(navBarIndexProvider);

    ref.listen<AsyncValue<void>>(autoRefreshProvider, (_, __) {
      final token = ref.read(jwtTokenProvider).valueOrNull;
      if (token != null) {
        ref.invalidate(schedulesProvider(token));
      }
    });

    return tokenAsync.when(
      data: (token) {
        if (token == null) {
          return const Scaffold(
            body: Center(child: Text('Ningún token fue encontrado')),
          );
        }

        Widget content;
        if (selectedIndex == 0) {
          content = SchedulePage(token: token);
        } else if (selectedIndex == 1) {
          content = const PrescriptionPage();
        } else if (selectedIndex == 2) {
          content = const MedicationsPage();
        } else if (selectedIndex == 3) {
          content = const SettingsPage();
        } else {
          content = const SizedBox();
        }

        return Scaffold(
          appBar: HomeAppBar(
            selectedIndex: selectedIndex,
            token: token,
            ref: ref,
          ),
          body: content,
          bottomNavigationBar: NavigationBar(
            height: 70,
            backgroundColor: Colors.white,
            indicatorColor: Colors.blue.shade100,
            elevation: 4,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: const Duration(milliseconds: 300),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: Colors.grey),
                selectedIcon: Icon(Icons.home, color: Colors.blue),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.description_outlined, color: Colors.grey),
                selectedIcon: Icon(Icons.description, color: Colors.blue),
                label: 'Recetas',
              ),
              NavigationDestination(
                icon: Icon(FontAwesomeIcons.capsules, color: Colors.grey),
                selectedIcon: Icon(
                  FontAwesomeIcons.capsules,
                  color: Colors.blue,
                ),
                label: 'Medicamentos',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined, color: Colors.grey),
                selectedIcon: Icon(Icons.settings, color: Colors.blue),
                label: 'Ajustes',
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              ref.read(navBarIndexProvider.notifier).state = index;
            },
          ),
        );
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (err, stack) => Scaffold(
            body: Center(child: Text('Error al obtener el token: $err')),
          ),
    );
  }
}
