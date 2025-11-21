import 'package:fasting_entities/fasting_entities.dart';
import 'package:local_fasting_api/local_fasting_api.dart';

class FastingRepository {
  final LocalFastingApi _fastingApi;

  const FastingRepository({
    required LocalFastingApi fastingApi,
  }) : _fastingApi = fastingApi;

  Future<Fast> createFast({
    required DateTime started,
    required FastingWindow window,
  }) async {
    final createdFast = await _fastingApi.createFast(
      started: started,
    );

//TODO: use extension method to map
    final mappedFast = Fast(
      id: createdFast.id,
      start: createdFast.start,
      window: window, // map fasting window appropriately
    );

    return mappedFast;
  }

  Future<Fast?> getActiveFast() async {
    final activeFast = await _fastingApi.getActiveFast();
    if (activeFast == null) {
      return null;
    }

    final mappedFast = Fast(
      id: activeFast.id,
      start: activeFast.start,
      window: FastingWindow.eighteenSix, // map fasting window appropriately
    );

    return mappedFast;
  }
}
