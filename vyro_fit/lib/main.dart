import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data/isar/isar_service.dart';
import 'data/services/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Deutsches Datumsformat für DateHelper
  await initializeDateFormatting('de_DE', null);

  // Isar lokale Datenbank initialisieren (Cache)
  // HINWEIS: Erfordert `dart run build_runner build` nach Schema-Änderungen!
  await IsarService.init();

  // Benachrichtigungen initialisieren
  await NotificationService.init();

  runApp(
    const ProviderScope(
      child: VyroFitApp(),
    ),
  );
}
