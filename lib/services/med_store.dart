import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MedStore {
  static const _kCurrentMeds = 'current_meds';
  static const _kHistory = 'history';
  static const _kRejected = 'rejected';

  static String _normImprint(dynamic v) {
    final s = (v ?? '').toString().toLowerCase();
    return s.replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  static String _normName(dynamic v) {
    final s = (v ?? '').toString().toLowerCase().trim();
    return s.replaceAll(RegExp(r'\s+'), ' ');
  }

  static Map<String, dynamic> _safeMap(dynamic pill) {
    if (pill is Map<String, dynamic>) return Map<String, dynamic>.from(pill);
    if (pill is Map) {
      return Map<String, dynamic>.from(
        pill.map((k, v) => MapEntry(k.toString(), v)),
      );
    }
    return <String, dynamic>{};
  }

  static Future<List<Map<String, dynamic>>> _getList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null || raw.trim().isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded.map((e) => _safeMap(e)).toList();
      return [];
    } catch (_) {
      return [];
    }
  }

  static Future<void> _setList(String key, List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(items));
  }

  static bool _matchesLoosely(Map<String, dynamic> saved, Map<String, dynamic> target) {
    final si = _normImprint(saved["imprint"]);
    final ti = _normImprint(target["imprint"]);
    if (si.isNotEmpty && ti.isNotEmpty) return si == ti;

    final sn = _normName(saved["name"]);
    final tn = _normName(target["name"]);
    if (sn.isNotEmpty && tn.isNotEmpty) return sn == tn;

    return false;
  }

  static Future<List<Map<String, dynamic>>> getCurrentMeds() => _getList(_kCurrentMeds);
  static Future<List<Map<String, dynamic>>> getHistory() => _getList(_kHistory);
  static Future<List<Map<String, dynamic>>> getRejected() => _getList(_kRejected);

  static Future<void> addToHistory(Map<String, dynamic> entry) async {
    final list = await _getList(_kHistory);
    list.insert(0, {
      ...entry,
      "timestamp": DateTime.now().toIso8601String(),
    });
    if (list.length > 200) list.removeRange(200, list.length);
    await _setList(_kHistory, list);
  }

  static Future<bool> addConfirmed(Map<String, dynamic> pill) async {
    final p = _safeMap(pill);
    final meds = await _getList(_kCurrentMeds);

    final exists = meds.any((m) => _matchesLoosely(m, p));

    if (!exists) {
      meds.insert(0, {
        ...p,
        "confirmedAt": DateTime.now().toIso8601String(),
      });
      await _setList(_kCurrentMeds, meds);
    }

    await addToHistory({"type": "confirm", "pill": p});
    return !exists;
  }

  /// ✅ SAFETY MODE:
  /// Reject NEVER removes anything from Current Meds.
  /// (Because your backend is currently duplicating imprint/color across results)
  static Future<void> addRejected(Map<String, dynamic> pill) async {
    final p = _safeMap(pill);

    final rej = await _getList(_kRejected);
    rej.insert(0, {
      ...p,
      "rejectedAt": DateTime.now().toIso8601String(),
    });
    if (rej.length > 200) rej.removeRange(200, rej.length);
    await _setList(_kRejected, rej);

    await addToHistory({"type": "reject", "pill": p});
  }

  static Future<void> removeConfirmedAt(int index) async {
    final meds = await _getList(_kCurrentMeds);
    if (index < 0 || index >= meds.length) return;
    final removed = meds.removeAt(index);
    await _setList(_kCurrentMeds, meds);
    await addToHistory({"type": "remove_confirmed", "pill": removed});
  }

  static Future<void> clearAll() async {
    await _setList(_kCurrentMeds, []);
    await _setList(_kHistory, []);
    await _setList(_kRejected, []);
  }
}
