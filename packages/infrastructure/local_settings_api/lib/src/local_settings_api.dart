import 'package:settings_api/settings_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsApi implements SettingsApi {
  final SharedPreferences _sharedPrefs;

  LocalSettingsApi({
    required SharedPreferences sharedPrefs,
  }) : _sharedPrefs = sharedPrefs;

  @override
  int getFastingType() {
    throw UnimplementedError();
  }

  @override
  Future<void> setFastingType(int type) {
    throw UnimplementedError();
  }
}
