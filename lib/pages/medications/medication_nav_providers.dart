import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider para el índice seleccionado en la NavigationBar
final navBarIndexProvider = StateProvider<int>((ref) => 2);

/// Provider para el texto de búsqueda de medicamentos
final medicationSearchProvider = StateProvider<String>((ref) => '');
