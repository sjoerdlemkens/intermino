import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:fasting_repository/fasting_repository.dart';
import 'package:fasting_use_cases/fasting_use_cases.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetMonthlyHistoryUseCase _getMonthlyHistory;
  final FastingRepository _fastingRepository;

  HistoryBloc({
    required GetMonthlyHistoryUseCase getMonthlyHistory,
    required FastingRepository fastingRepository,
  })  : _getMonthlyHistory = getMonthlyHistory,
        _fastingRepository = fastingRepository,
        super(const HistoryInitial()) {
    on<LoadHistoryMonth>(_onLoadHistoryMonth);
    on<ChangeMonth>(_onChangeMonth);
  }

  Future<void> _onLoadHistoryMonth(
    LoadHistoryMonth event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());

    try {
      final month = event.month;
      final sessionsByDay = await _getMonthlyHistory(month);

      // Get last 3 completed fasts
      final lastFasts = await _fastingRepository.getFastingSessions(
        isActive: false,
        limit: 3,
      );

      // Get active fast if any
      final activeFasts = await _fastingRepository.getFastingSessions(
        isActive: true,
        limit: 1,
      );
      final activeFast = activeFasts.isNotEmpty ? activeFasts.first : null;

      emit(HistoryLoaded(
        currentMonth: month,
        fastingSessionsByDay: sessionsByDay,
        lastFasts: lastFasts,
        activeFast: activeFast,
      ));
    } catch (error) {
      emit(HistoryError(error.toString()));
    }
  }

  Future<void> _onChangeMonth(
    ChangeMonth event,
    Emitter<HistoryState> emit,
  ) async {
    add(LoadHistoryMonth(event.month));
  }
}
