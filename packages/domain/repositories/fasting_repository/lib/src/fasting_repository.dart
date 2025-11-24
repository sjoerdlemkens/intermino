import 'package:fasting_repository/fasting_repository.dart';
import 'package:local_fasting_api/local_fasting_api.dart' hide FastingSession;

class FastingRepository {
  final LocalFastingApi _fastingApi;

  const FastingRepository({
    required LocalFastingApi fastingApi,
  }) : _fastingApi = fastingApi;

  Future<FastingSession> createFastingSession({
    required DateTime started,
  }) async {
    final createdFast = await _fastingApi.createFastingSession(
      started: started,
    );

    final mappedFast = createdFast.toDomain();

    return mappedFast;
  }

  Future<List<FastingSession>> getFastingSessions({
    bool? isActive,
    int? limit,
    DateTime? startAfter,
    DateTime? startBefore,
  }) async {
    final sessions = await _fastingApi.getFastingSessions(
      isActive: isActive,
      limit: limit,
      startAfter: startAfter,
      startBefore: startBefore,
    );

    return sessions.map((session) => session.toDomain()).toList();
  }

  Future<FastingSession> updateFastingSession({
    required int id,
    DateTime? start,
    DateTime? end,
    FastingWindow? window,
  }) async {
    final updatedSession = await _fastingApi.updateFastingSession(
      id: id,
      start: start,
      end: end,
      window: window?.toInt(),
    );

    return updatedSession.toDomain();
  }

  Future<void> deleteFastingSession(int id) async {
    await _fastingApi.deleteFastingSession(id);
  }
}
