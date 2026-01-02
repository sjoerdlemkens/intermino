import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fasting_app/settings/settings.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:settings_repository/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepo;

  SettingsBloc({
    required SettingsRepository settingsRepo,
  })  : _settingsRepo = settingsRepo,
        super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateFastingWindow>(_onUpdateFastingWindow);
    on<UpdateNotificationsEnabled>(_onUpdateNotificationsEnabled);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());

    try {
      // Get fasting window (repository has default fallback)
      final fastingWindow = await _settingsRepo.getFastingWindow();
      final notificationsEnabled =
          await _settingsRepo.getNotificationsEnabled();
      final settings = Settings(
        fastingWindow: fastingWindow,
        notificationsEnabled: notificationsEnabled,
      );

      if (!isClosed) {
        emit(SettingsLoaded(settings));
      }
    } catch (_) {
      // Fallback to initial state on error and maybe log the error
      if (!isClosed) {
        emit(SettingsInitial());
      }
    }
  }

  void _onUpdateFastingWindow(
      UpdateFastingWindow event, Emitter<SettingsState> emit) async {
    final currentState = state;

    if (currentState is SettingsLoaded) {
      try {
        await _settingsRepo.setFastingWindow(event.fastingWindow);

        final updatedSettings = currentState.settings.copyWith(
          fastingWindow: event.fastingWindow,
        );

        if (!isClosed) {
          emit(SettingsLoaded(updatedSettings));
        }
      } catch (_) {
        // On error, keep the current state unchanged
        // Could emit an error state if needed
      }
    }
  }

  void _onUpdateNotificationsEnabled(
      UpdateNotificationsEnabled event, Emitter<SettingsState> emit) async {
    final currentState = state;

    if (currentState is SettingsLoaded) {
      try {
        await _settingsRepo.setNotificationsEnabled(event.enabled);

        final updatedSettings = currentState.settings.copyWith(
          notificationsEnabled: event.enabled,
        );

        if (!isClosed) {
          emit(SettingsLoaded(updatedSettings));
        }
      } catch (_) {
        // On error, keep the current state unchanged
        // Could emit an error state if needed
      }
    }
  }
}
