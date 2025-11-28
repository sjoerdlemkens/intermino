import 'package:settings_api/settings_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalSettingsApi implements SettingsApi {
  final SharedPreferences _sharedPrefs;

  static const String _fastingTypeKey = 'fasting_type';

  LocalSettingsApi({
    required SharedPreferences sharedPrefs,
  }) : _sharedPrefs = sharedPrefs;

  @override
  int? getFastingType() => _sharedPrefs.getInt(_fastingTypeKey);

  @override
  Future<void> setFastingType(int type) =>
      _sharedPrefs.setInt(_fastingTypeKey, type);
}
