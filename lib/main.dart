import 'package:app_pastia/pages/medications/medication_details_page.dart';
import 'package:app_pastia/pages/prescriptions/prescription_details_page.dart';
import 'package:app_pastia/pages/principal/home_page.dart';
import 'package:app_pastia/pages/principal/login_page.dart';
import 'package:app_pastia/pages/principal/register_page.dart';
import 'package:app_pastia/pages/schedules/update_schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Método que verifica si el token existe
  Future<bool> hasToken() async {
    final token = await _secureStorage.read(key: 'token');
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      home: FutureBuilder<bool>(
        future: hasToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Puedes poner un splash o loader
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData && snapshot.data == true) {
            return HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const RegisterPage(),
        '/prescriptionDetails': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map?;
          final prescriptionId =
              args != null && args['prescriptionId'] != null
                  ? args['prescriptionId'] as String
                  : '';
          return PrescriptionDetailPage(prescriptionId: prescriptionId);
        },
        '/medicationDetails': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map?;
          final medicationId =
              args != null && args['medicationId'] != null
                  ? args['medicationId'] as String
                  : '';
          return MedicationDetailsPage(medicationId: medicationId);
        },
        '/updateSchedule': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map?;
          final scheduleId =
              args != null && args['scheduleId'] != null
                  ? args['scheduleId'] as String
                  : '';
          return UpdateSchedulePage(scheduleId: scheduleId);
        },
      },
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
