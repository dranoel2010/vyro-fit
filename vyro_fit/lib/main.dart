import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Deutsches Datumsformat initialisieren (für DateHelper)
  await initializeDateFormatting('de_DE', null);

  // Isar-Initialisierung kommt in Phase 3 (IsarService.init())

  runApp(
    const ProviderScope(
      child: VyroFitApp(),
    ),
  );
}
