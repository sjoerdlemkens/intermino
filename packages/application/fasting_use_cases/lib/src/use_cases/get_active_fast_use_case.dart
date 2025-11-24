import 'package:fasting_repository/fasting_repository.dart';

class GetActiveFastUseCase {
  final FastingRepository _fastingRepo;

  GetActiveFastUseCase({required FastingRepository fastingRepo})
    : _fastingRepo = fastingRepo;

  Future<FastingSession?> call() async {
    final sessions = await _fastingRepo.getFastingSessions(
      limit: 1,
      isActive: true,
    );

    return sessions.firstOrNull;
  }
}
