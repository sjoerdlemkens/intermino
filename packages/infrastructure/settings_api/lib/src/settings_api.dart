/// The interface for an API that provides access to fasting settings.
abstract class SettingsApi {
  /// Gets the fasting type as an integer.
  int? getFastingType();

  // Sets the fasting type.
  Future<void> setFastingType(int type);
}
