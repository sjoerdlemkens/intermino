import 'package:fasting_repository/fasting_repository.dart';

class EndFastUseCase {
  final FastingRepository _fastingRepo;

  EndFastUseCase({required FastingRepository fastingRepo})
    : _fastingRepo = fastingRepo;

  Future<FastingSession?> call(int fastId) async {
    print('EndFastUseCase called with fastId: $fastId');

    //Update fasting session end time in repository
    // _fastingRepo.updateFastingSession()

    return null;
  }
}
