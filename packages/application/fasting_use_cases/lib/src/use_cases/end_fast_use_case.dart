import 'package:fasting_repository/fasting_repository.dart';

class EndFastUseCase {
  final FastingRepository _fastingRepo;

  EndFastUseCase({required FastingRepository fastingRepo})
    : _fastingRepo = fastingRepo;

  Future<FastingSession?> call(int fastId) async {
    final updatedFastingSession = await _fastingRepo.updateFastingSession(
      id: fastId,
      end: DateTime.now(),
      window: FastingWindow.sixteenEight, // TODO: Get window from user settings
    );

    return updatedFastingSession;
  }
}
