import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider para el índice seleccionado en la NavigationBar
final navBarIndexProvider = StateProvider<int>((ref) => 1);

/// Provider para el texto de búsqueda de medicamentos
final prescriptionSearchProvider = StateProvider<String>((ref) => '');
