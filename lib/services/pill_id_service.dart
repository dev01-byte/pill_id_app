import '../api/pill_api.dart';
import '../models/pill_result.dart';

class PillIdService {
  const PillIdService();

  /// Full search (imprint + optional color/shape)
  Future<List<PillResult>> searchPills({
    required String imprint,
    String? color,
    String? shape,
  }) async {
    final rows = await PillApi.identify(
      imprint: imprint,
      color: color,
      shape: shape,
    );

    return rows.map((j) => PillResult.fromJson(j)).toList();
  }

  /// ✅ Manual search convenience method (this fixes your error)
  Future<List<PillResult>> searchByImprint(String imprint) async {
    return searchPills(imprint: imprint);
  }
}
