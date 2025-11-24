import 'package:fasting_repository/fasting_repository.dart';

class GetActiveFastUseCase {
  final FastingRepository _fastingRepo;

  GetActiveFastUseCase({required FastingRepository fastingRepo})
    : _fastingRepo = fastingRepo;

  Future<FastingSession?> call() async {
    // TODO:  This should be a more generic query to get the active fasting session
    return _fastingRepo.getActiveFastingSession();
  }
}
