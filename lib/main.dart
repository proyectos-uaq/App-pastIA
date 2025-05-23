import 'package:past_ia/models/medication_model.dart';
import 'package:past_ia/pages/medications/create_medication_page.dart';
import 'package:past_ia/pages/medications/medication_details_page.dart';
import 'package:past_ia/pages/medications/update_medication_page.dart';
import 'package:past_ia/pages/prescriptions/prescription_details_page.dart';
import 'package:past_ia/pages/principal/home_page.dart';
import 'package:past_ia/pages/principal/login_page.dart';
import 'package:past_ia/pages/principal/register_page.dart';
import 'package:past_ia/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:past_ia/widgets/custom_circular_progress_indicator.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Método que verifica si el token existe
  Future<bool> hasToken() async {
    final token = await _secureStorage.read(key: 'token');
    return token != null && token.isNotEmpty;
  }

  // Método para obtener el token, útil para pasar a CreateMedicationPage
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textScale = ref.watch(textScaleProvider);

    return MaterialApp(
      title: 'Mi App',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        );
      },
      home: FutureBuilder<bool>(
        future: hasToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Puedes poner un splash o loader
            return const Scaffold(body: Center(child: MyCustomLoader()));
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
        '/createMedication': (context) {
          // Lee los argumentos
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>?;

          // Obtiene el token de forma asíncrona
          return FutureBuilder<String?>(
            future: _secureStorage.read(key: 'token'),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(body: Center(child: MyCustomLoader()));
              }
              final token = snapshot.data;
              if (token == null || token.isEmpty) {
                return const Scaffold(
                  body: Center(child: Text('No hay token de sesión')),
                );
              }
              // Obtén prescriptionId de los argumentos (puede ser null)
              final prescriptionId =
                  args != null ? args['prescriptionId'] as String? : null;
              return CreateMedicationPage(
                token: token,
                prescriptionId: prescriptionId,
              );
            },
          );
        },
        '/updateMedication': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>?;
          final Medication? medication = args?['medication'] as Medication?;
          // Asegúrate de enviar el token en los arguments
          return FutureBuilder<String?>(
            future: _secureStorage.read(key: 'token'),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(body: Center(child: MyCustomLoader()));
              }
              final token = snapshot.data;
              if (token == null || token.isEmpty) {
                return const Scaffold(
                  body: Center(child: Text('No hay token de sesión')),
                );
              }
              if (medication == null) {
                return const Scaffold(
                  body: Center(
                    child: Text('No hay información del medicamento'),
                  ),
                );
              }
              return UpdateMedicationPage(token: token, medication: medication);
            },
          );
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
