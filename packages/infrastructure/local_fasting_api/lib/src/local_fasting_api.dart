import 'package:local_fasting_api/src/db/core/database.dart';

class LocalFastingApi {
  final AppDatabase _db = AppDatabase();

  Future<Fast> createFast({required DateTime started}) async {
    final id = await _db.into(_db.fasts).insert(
          FastsCompanion.insert(start: started),
        );
    final createdFast = getFastById(id);

    return createdFast;
  }

  Future<Fast> getFastById(int id) async {
    final fast = await (_db.select(_db.fasts)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    if (fast == null) {
      throw Exception('Fast with id $id not found');
    }

    return fast;
  }
}
