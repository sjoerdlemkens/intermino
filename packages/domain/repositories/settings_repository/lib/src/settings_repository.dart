import 'package:settings_api/settings_api.dart';

class SettingsRepository {
  final SettingsApi _settingsApi;

  const SettingsRepository({
    required SettingsApi settingsApi,
  }) : _settingsApi = settingsApi;
}
