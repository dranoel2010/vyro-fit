import 'package:health/health.dart';
import '../../core/constants/health_types.dart';

/// Abstraktions-Layer über Health Connect via `health` Package.
/// WICHTIG: Wird NUR von Repositories verwendet, NIEMALS direkt von der UI!
class HealthService {
  final Health _health = Health();

  // ── Berechtigungen ──────────────────────────────────────────

  /// Fragt alle benötigten Health Connect Berechtigungen an
  Future<bool> requestPermissions() async {
    try {
      final permissions = HealthTypes.allTypes
          .map((_) => HealthDataAccess.READ)
          .toList();

      return await _health.requestAuthorization(
        HealthTypes.allTypes,
        permissions: permissions,
      );
    } catch (_) {
      return false;
    }
  }

  /// Prüft ob Health Connect verfügbar und Berechtigungen vorhanden sind
  Future<bool> isAvailable() async {
    try {
      return await _health.hasPermissions(HealthTypes.allTypes) ?? false;
    } catch (_) {
      return false;
    }
  }

  // ── Rohdaten lesen (nur für Repositories) ──────────────────

  /// Liest Health-Rohdaten eines Zeitraums
  Future<List<HealthDataPoint>> fetchRawData({
    required DateTime start,
    required DateTime end,
    required List<HealthDataType> types,
  }) async {
    try {
      final data = await _health.getHealthDataFromTypes(
        startTime: start,
        endTime: end,
        types: types,
      );
      // Duplikate entfernen (verschiedene Apps können gleiche Daten liefern)
      return _health.removeDuplicates(data);
    } catch (_) {
      return [];
    }
  }

  /// Aggregierte Schritte für einen Zeitraum
  Future<int?> getTotalSteps(DateTime start, DateTime end) async {
    try {
      return await _health.getTotalStepsInInterval(start, end);
    } catch (_) {
      return null;
    }
  }
}
