import 'package:fasting_repository/fasting_repository.dart';
import 'package:settings_repository/settings_repository.dart';

class EndFastUseCase {
  final FastingRepository _fastingRepo;
  final SettingsRepository _settingsRepo;

  EndFastUseCase({
    required FastingRepository fastingRepo,
    required SettingsRepository settingsRepo,
  }) : _fastingRepo = fastingRepo,
       _settingsRepo = settingsRepo;

  Future<FastingSession?> call(int fastId) async {
    final fastingWindow = await _settingsRepo.getFastingWindow();
    final updatedFastingSession = await _fastingRepo.updateFastingSession(
      id: fastId,
      end: DateTime.now(),
      window: fastingWindow,
    );

    return updatedFastingSession;
  }
}
