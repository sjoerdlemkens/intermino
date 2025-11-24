import 'package:drift/drift.dart';
import 'package:local_fasting_api/src/db/core/database.dart';

class LocalFastingApi {
  final AppDatabase _db = AppDatabase();

  Future<FastingSession> createFastingSession({
    required DateTime started,
  }) async {
    final id = await _db.into(_db.fastingSessions).insert(
          FastingSessionsCompanion.insert(
            start: started,
          ),
        );

    final createdFast = await getFastingSessionById(id);

    return createdFast;
  }

  Future<FastingSession> getFastingSessionById(int id) async {
    final fastingSession = await (_db.select(_db.fastingSessions)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();

    if (fastingSession == null) {
      throw Exception('Fasting session with id $id not found');
    }

    return fastingSession;
  }

  Future<List<FastingSession>> getFastingSessions({
    bool? isActive,
    int? limit,
    DateTime? startAfter,
    DateTime? startBefore,
  }) async {
    final query = _db.select(_db.fastingSessions);

    // Apply filters
    if (isActive != null) {
      if (isActive) {
        query.where((table) => table.end.isNull());
      } else {
        query.where((table) => table.end.isNotNull());
      }
    }

    if (startAfter != null) {
      query.where((table) => table.start.isBiggerThanValue(startAfter));
    }

    if (startBefore != null) {
      query.where((table) => table.start.isSmallerThanValue(startBefore));
    }

    // Order by most recent first
    query.orderBy([
      (table) => OrderingTerm(expression: table.start, mode: OrderingMode.desc)
    ]);

    // Apply limit
    if (limit != null) {
      query.limit(limit);
    }

    return await query.get();
  }

  Future<FastingSession> updateFastingSession({
    required int id,
    DateTime? start,
    DateTime? end,
    int? window,
  }) async {
    final companion = FastingSessionsCompanion(
      id: Value(id),
      start: start != null ? Value(start) : const Value.absent(),
      end: end != null ? Value(end) : const Value.absent(),
      window: window != null ? Value(window) : const Value.absent(),
    );

    await _db.update(_db.fastingSessions).replace(companion);
    return await getFastingSessionById(id);
  }

  Future<void> deleteFastingSession(int id) async {
    await (_db.delete(_db.fastingSessions)
          ..where((table) => table.id.equals(id)))
        .go();
  }
}
