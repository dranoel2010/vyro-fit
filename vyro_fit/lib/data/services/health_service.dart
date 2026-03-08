import 'package:health/health.dart';
import '../../core/constants/health_types.dart';

/// Abstraktions-Layer über Health Connect via `health` Package.
///
/// ARCHITEKTUR-REGEL: Wird NUR von Repositories aufgerufen!
/// Die UI greift NIEMALS direkt auf diesen Service zu.
/// Aggregation/Verarbeitung passiert im Aggregation-Layer, nicht hier.
class HealthService {
  final Health _health = Health();

  // ── Berechtigungen ───────────────────────────────────────────

  /// Fragt alle benötigten Health Connect Berechtigungen an.
  /// Gibt true zurück wenn alle Berechtigungen erteilt wurden.
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

  /// Prüft ob Health Connect verfügbar und Berechtigungen vorhanden sind.
  Future<bool> isAvailable() async {
    try {
      final hasPerms =
          await _health.hasPermissions(HealthTypes.allTypes) ?? false;
      return hasPerms;
    } catch (_) {
      return false;
    }
  }

  // ── Rohdaten lesen ───────────────────────────────────────────

  /// Liest Health-Rohdaten für einen Zeitraum.
  /// Entfernt automatisch Duplikate (verschiedene Apps können gleiche Daten liefern).
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
      return _health.removeDuplicates(data);
    } catch (_) {
      return [];
    }
  }

  /// Aggregierte Gesamt-Schritte für einen Zeitraum.
  /// Effizienter als Rohdaten summieren (nutzt Health Connect Aggregation).
  Future<int?> getTotalSteps(DateTime start, DateTime end) async {
    try {
      return await _health.getTotalStepsInInterval(start, end);
    } catch (_) {
      return null;
    }
  }
}
